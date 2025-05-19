import socket
import functools
import itertools
import sys
import threading
from binascii import unhexlify, hexlify
import random
import os
import time
import hashlib
import json
from time import perf_counter
from func_timeout import func_timeout, FunctionTimedOut
import logging
from crccheck.crc import Crc32, CrcXmodem, Crc16
from crccheck.checksum import ChecksumXor8, Checksum32, Checksum16, ChecksumXor16
from lib.packet_parser import *
from lib.elk import *
from protocol.t301 import *

logging.basicConfig(filename="T301.log", level=logging.INFO)

if sys.version_info[0] == 3:
	iterbytes = iter
else:
	iterbytes = functools.partial(itertools.imap, ord)


T301s = {}

CRC_TAB = (
	0x0000, 0x1189, 0x2312, 0x329B, 0x4624, 0x57AD, 0x6536, 0x74BF,
	0x8C48, 0x9DC1, 0xAF5A, 0xBED3, 0xCA6C, 0xDBE5, 0xE97E, 0xF8F7,
	0x1081, 0x0108, 0x3393, 0x221A, 0x56A5, 0x472C, 0x75B7, 0x643E,
	0x9CC9, 0x8D40, 0xBFDB, 0xAE52, 0xDAED, 0xCB64, 0xF9FF, 0xE876,
	0x2102, 0x308B, 0x0210, 0x1399, 0x6726, 0x76AF, 0x4434, 0x55BD,
	0xAD4A, 0xBCC3, 0x8E58, 0x9FD1, 0xEB6E, 0xFAE7, 0xC87C, 0xD9F5,
	0x3183, 0x200A, 0x1291, 0x0318, 0x77A7, 0x662E, 0x54B5, 0x453C,
	0xBDCB, 0xAC42, 0x9ED9, 0x8F50, 0xFBEF, 0xEA66, 0xD8FD, 0xC974,
	0x4204, 0x538D, 0x6116, 0x709F, 0x0420, 0x15A9, 0x2732, 0x36BB,
	0xCE4C, 0xDFC5, 0xED5E, 0xFCD7, 0x8868, 0x99E1, 0xAB7A, 0xBAF3,
	0x5285, 0x430C, 0x7197, 0x601E, 0x14A1, 0x0528, 0x37B3, 0x263A,
	0xDECD, 0xCF44, 0xFDDF, 0xEC56, 0x98E9, 0x8960, 0xBBFB, 0xAA72,
	0x6306, 0x728F, 0x4014, 0x519D, 0x2522, 0x34AB, 0x0630, 0x17B9,
	0xEF4E, 0xFEC7, 0xCC5C, 0xDDD5, 0xA96A, 0xB8E3, 0x8A78, 0x9BF1,
	0x7387, 0x620E, 0x5095, 0x411C, 0x35A3, 0x242A, 0x16B1, 0x0738,
	0xFFCF, 0xEE46, 0xDCDD, 0xCD54, 0xB9EB, 0xA862, 0x9AF9, 0x8B70,
	0x8408, 0x9581, 0xA71A, 0xB693, 0xC22C, 0xD3A5, 0xE13E, 0xF0B7,
	0x0840, 0x19C9, 0x2B52, 0x3ADB, 0x4E64, 0x5FED, 0x6D76, 0x7CFF,
	0x9489, 0x8500, 0xB79B, 0xA612, 0xD2AD, 0xC324, 0xF1BF, 0xE036,
	0x18C1, 0x0948, 0x3BD3, 0x2A5A, 0x5EE5, 0x4F6C, 0x7DF7, 0x6C7E,
	0xA50A, 0xB483, 0x8618, 0x9791, 0xE32E, 0xF2A7, 0xC03C, 0xD1B5,
	0x2942, 0x38CB, 0x0A50, 0x1BD9, 0x6F66, 0x7EEF, 0x4C74, 0x5DFD,
	0xB58B, 0xA402, 0x9699, 0x8710, 0xF3AF, 0xE226, 0xD0BD, 0xC134,
	0x39C3, 0x284A, 0x1AD1, 0x0B58, 0x7FE7, 0x6E6E, 0x5CF5, 0x4D7C,
	0xC60C, 0xD785, 0xE51E, 0xF497, 0x8028, 0x91A1, 0xA33A, 0xB2B3,
	0x4A44, 0x5BCD, 0x6956, 0x78DF, 0x0C60, 0x1DE9, 0x2F72, 0x3EFB,
	0xD68D, 0xC704, 0xF59F, 0xE416, 0x90A9, 0x8120, 0xB3BB, 0xA232,
	0x5AC5, 0x4B4C, 0x79D7, 0x685E, 0x1CE1, 0x0D68, 0x3FF3, 0x2E7A,
	0xE70E, 0xF687, 0xC41C, 0xD595, 0xA12A, 0xB0A3, 0x8238, 0x93B1,
	0x6B46, 0x7ACF, 0x4854, 0x59DD, 0x2D62, 0x3CEB, 0x0E70, 0x1FF9,
	0xF78F, 0xE606, 0xD49D, 0xC514, 0xB1AB, 0xA022, 0x92B9, 0x8330,
	0x7BC7, 0x6A4E, 0x58D5, 0x495C, 0x3DE3, 0x2C6A, 0x1EF1, 0x0F78,
)


ELK_ENABLED = False
ACTION_SUCCESS = 	0x00
ACTION_FAILURE =	0x01
T301_LOGIN =		0x01
T301_LOCATION =		0x12
T301_STATUS =		0x13
T301_STRING =		0x15
T301_ALARM =		0x16
T301_GPS =			0x1A
T301_COMMAND =		0x80
T301_START_BIT =	0x7878
T301_STOP_BIT = 	0x0D0A

protocol_packed = [["protocol", 3, 4, 'str', None]]


load(t301_protocols)


class T301():
	def __init__(self, socket_fd):
		self.socket_fd = socket_fd
		self.hostname, self.port = socket_fd.getpeername()
		self.node_hash = self.make_hash(self.hostname, self.port)
		self.time = perf_counter()
		self.locked = True
		self.T301_DEVICE_ID = 0
		self.T301_SEC_NUMBER = 0

	def crc16(self, data):
		data_bytes = bytearray.fromhex(data)
		crc_tab = CRC_TAB
		fcs = 0xffff
		for b in iterbytes(data_bytes):
			index = (fcs ^ b) & 0xff
			fcs = (fcs >> 8) ^ crc_tab[index]
		checks = fcs ^ 0xffff

		ret = hex(checks)[2:]
		return ret


	def parse_msg_id(self, datain):

		self.T301_RESPONSE = datain
		#protocol_json = PacketParser(packed_protocol_terminal, self.T301_RESPONSE).parse_to_json_v2()

#if self.T301_PROTOCOL_ID == '12':
		self.T301_PROTOCOL_ID = self.T301_RESPONSE[6:8]
		#self.T301_CHECKSUM = self.T301_RESPONSE[len(self.T301_RESPONSE) - 8:len(self.T301_RESPONSE) - 4]
		#self.T301_BODY = self.T301_RESPONSE[4:len(self.T301_RESPONSE) - 8]

		#if not self.crc16(self.T301_BODY) == self.T301_CHECKSUM:
		#	print('CHECKSUM ERROR')
			#return 0
		#else:
		#	print('CHECKSUM OK')
		status_json = PacketParser(self.T301_RESPONSE).parse_to_json_v2()
		if status_json == 'error':
			return None
		print('PARSED:', status_json)
		print('Protocol ID:', status_json["protocol"] )
		#print('CHECKSUM ', self.T301_CHECKSUM )
		#print('BODY:', self.T301_BODY )
		#print('Verify CHECKSUM ', self.crc16(self.T301_BODY))


		#if self.T301_DEVICE_ID == 0:
			#print('Device ID', self.T301_RESPONSE[9:24])
		#	check_recon(self.T301_RESPONSE[9:24], self.node_hash)
		#	self.T301_DEVICE_ID = self.T301_RESPONSE[9:24]

		#	print('Device id asing', self.T301_DEVICE_ID)

		#print(int(self.T301_PROTOCOL_ID, base=16))


		#if status_json["protocol"] == '01':
		if T301_LOGIN == int(self.T301_PROTOCOL_ID, base=16):

			print('LOGINNNN')
			#options_packed = {
			#'name': 'login',
			#'check': {
			#	'target':'error_check', 
			#	'values':'length,protocol,terminal_id,information_serial_number'}
			#}
			#status_json = PacketParser(packed_1_terminal, self.T301_RESPONSE, options_packed).parse_to_json_v2()

			#self.T301_SNUMBER = self.T301_RESPONSE[len(self.T301_RESPONSE) - 12:len(self.T301_RESPONSE) - 8]
			print('S Number ', status_json["information_serial_number"] )
			response = '78780501'+status_json["information_serial_number"]+self.crc16('0501'+status_json["information_serial_number"])+'0D0A'
			
			#print(status_json)
			self.send_command(response)

			paquete = '78781680100001A967445758582C3030303030302300A0062D0D0A'
			#self.send_command(paquete.strip())
		elif T301_STATUS == int(self.T301_PROTOCOL_ID, base=16):
			print('T301_STATUS')
			options_packed = {
			'name': 'status',
			'check': {
				'target':'error_check', 
				'values':'length,protocol,terminal_information,voltage_level,gsm_signal_strength,alarm/language,serial_number'}
			}
			status_json = PacketParser(self.T301_RESPONSE).parse_to_json_v2()
			print(status_json)
			print('Protocol:', status_json["protocol"])
			print('Serial:', status_json["serial_number"])
			print('Verify CHECKSUM ', self.crc16('0513'+status_json["serial_number"]))
			self.send_command('78780513'+status_json["serial_number"]+self.crc16('0513'+status_json["serial_number"])+'0D0A')

		elif T301_LOCATION == int(self.T301_PROTOCOL_ID, base=16):
			print('T301_LOCATION')
			#protocol_json = PacketParser(protocol_packed, self.T301_RESPONSE).parse_to_json()

			#if protocol_json["protocol"] == '12':

			for packed in self.T301_RESPONSE.split('0d0a'):
				if len(packed) > 0:
					try:
						print('AA', packed)

						tmpjson = PacketParser(packed+'0d0a').parse_to_json_v2()
						#tmpjson["latitude_degree"] = tmpjson["latitude_degree"] / 1000000
						#tmpjson["longitude"] = tmpjson["longitude"] / 1000000
						print(tmpjson)
					except Exception as e:
						print('uu', e)
						continue
		elif T301_ALARM == int(self.T301_PROTOCOL_ID, base=16):
			print('T301_ALARM')
		#elif T301_STATUS == int(self.T301_PROTOCOL_ID, base=16):
		#	print('T301_STATUS')
		#	self.send_command('78781680100001A967445758582C3030303030302300A0062D0D0A')
			status_json = PacketParser(self.T301_RESPONSE).parse_to_json_v2()
			#print(status_json)
			#status_json["latitude"] = status_json["latitude"] / 1000000
			#status_json["longitude"] = status_json["longitude"] / 1000000
			print(status_json)
			#print('Protocol:', status_json["protocol"])

	def make_hash(self, host, port):
		data = host+':'+str(port)
		return hashlib.md5(data.encode('utf-8')).hexdigest()

	def recvall(self):
		data = ""
		size = 4096
		while True:
			r = self.socket_fd.recv(size)
			if not r:
				break
			data += hexlify(r).decode()
			if '7e0900' in data:
				break
			if len(r) < size:

				break
		if len(data) <= 3:
			data = 'Error s'
		return data



	def CmdToHex(self, instr):
		pass



	def mon_init(self):
		mon_init_thread = threading.Thread(target=self.recvall2)
		mon_init_thread.start()

	def send_command(self, command):
		try:
			print('SERVER SEND:', command )
			cmd = bytes.fromhex(command.lower())
			self.socket_fd.send(cmd)
			self.SERVER_MSG_SERIAL = int(self.T301_SEC_NUMBER) +1
			return True
		except Exception as e:
			print('error ', e)
			self.close()
			return False



	def close(self):
		try:
			self.socket_fd.shutdown(socket.SHUT_RDWR)
			self.socket_fd.close()
		except:
			print('baphomet')
			pass
		if self.node_hash in list(T301s.keys()):
			T301s.pop(self.node_hash)
			logging.info('Disconnected: '+self.node_hash)


	def check(self):
		time_check = perf_counter()
		return time_check-self.time
		#if time_check-self.time:

	def recvall2(self):
		data = ""
		size = 4096
		print('listen')
		while True:
			try:
				r = bytes(self.socket_fd.recv(size))
				if r:
					data += hexlify(r).decode()#r.decode()
					print('Device response: ',data)
					print('len response: ',len(data) / 2)
					self.parse_msg_id(data)
				if len(r) < size:
					data = ''
			except Exception as e:
				print('Error ', e)
				break
				#pass

def bits(f):
	bytes = (ord(b) for b in f)
	for b in bytes:
		for i in xrange(8):
			yield (b >> i) & 1

def bit_from_string(string, index):
	   i, j = divmod(index, 8)

	   # Uncomment this if you want the high-order bit first
	   # j = 8 - j

	   if ord(string[i]) & (1 << j):
			  return 1
	   else:
			  return 0


def check_node(key):
	"""caca"""
	return 0


def check_status():
	
	while True:
		aList = list()
		time.sleep(10)
		print('Checking: '+str(len(T301s)))
		for key in list(T301s.keys()):
			try:
				check_noder_return = func_timeout(15, check_node, args=(key,))
			except FunctionTimedOut:
				print('T301 Disconnected, removing node')
				T301s[key].close()
			except Exception as e:
				if e.args[0] == 107:
					print('T301 Disconnected, removing node')
					T301s[key].close()

def T301_SERVER(host, port):

	print("T301 server starting at %s:%d" % (host, port))
	logging.info("T301 server starting at %s:%d" % (host, port))
	master_fd = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
	master_fd.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
	master_fd.bind((host, port))
	master_fd.listen(5000)
	#status_thread = threading.Thread(target=check_status)
	#status_thread.start()
	while(True):
		t301_fd, t301_addr = master_fd.accept()
		print("\rT301 online : %s:%d" % (t301_addr[0], t301_addr[1]))
		logging.info("\rT301 online : %s:%d" % (t301_addr[0], t301_addr[1]))
		t301 = T301(t301_fd)
		T301s[t301.node_hash] = t301
		t301.mon_init()
	print("T301 server exiting...")
	logging.info('T301 server exiting...')
	master_fd.shutdown(socket.SHUT_RDWR)
	master_fd.close()



def cmd_conhost(host, command):
	aList = list()
	for key in list(T301s.keys()):
		if host == key:
			logging.info("Send command: "+command+" to "+key)
			cmd = T301s[key].CmdToHex(command)
			ret = T301s[key].send_command(cmd)
			reta = T301s[key].recvall()
			return '{"data": "'+reta+'"}'
	return "Error"

def cmd_con(device_id, command):
	aList = list()
	for key in list(T301s.keys()):
		if device_id == T301s[key].T301_DEVICE_ID:
			logging.info("Send command: "+command+" to "+key)
			cmd = T301s[key].CmdToHex(command)
			ret = T301s[key].send_command(cmd)
			try:
				reta = T301s[key].recvall()
			except:
				return '{"error": "Error en conexion con el dispositivo T301"}'
			return '{"data": "'+reta+'"}'
	return "Error"

def cmdhex_con(device_id, command):
	aList = list()
	for key in list(T301s.keys()):
		if device_id == T301s[key].T301_DEVICE_ID:
			logging.info("Send command hex: "+command+" to "+key)
			ret = T301s[key].send_command(command)
			try:
				reta = T301s[key].recvall()
			except:
				return '{"error": "Error en conexion con el dispositivo T301"}'

			return '{"data": "'+reta+'"}'
	return "Error"



def check_recon(device_id, node_hash):
	print('Check node_hash', node_hash)
	print('Check device_id', device_id)

	for key in list(T301s.keys()):
		#print(device_id)
		if T301s[key].T301_DEVICE_ID == device_id and T301s[key].node_hash != node_hash:
			#logging.info("Send command: "+command+" to "+key)
			#cmd = T301s[key].T301_DEVICE_ID
			T301s[key].close()
			print('REPETIDA')


def list_con():
	aList = list()
	for key in list(T301s.keys()):
		aList.append("{'host':'"+str(T301s[key].hostname)+"', 'hash':'"+str(T301s[key].node_hash)+"', 'device_id':'"+str(T301s[key].T301_DEVICE_ID)+"'}")
	jsonStr = json.dumps(aList)
	return jsonStr


#print(check_node.__doc__)

#print(T301_LOCATION)

#T301_SERVER('0.0.0.0', 9988)
