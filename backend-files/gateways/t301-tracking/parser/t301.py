
t301_protocols = []

protocol_login = {
	'name':'login',
	'protocol_number':'0x01',
	'testdata': '78780d010357784087437651000054420d0a',
	'template': [
		["start bit", 2, 'str', None],
		["length", 1, 'str', None],
		["protocol", 1, 'str', None],
		["Terminal ID", 8, 'str', None],
		["Information Serial Number", 2, 'str', None],
		["error check", 2, 'str', None],
		["stop bit", 2, 'str', None]],

	'check': {
		'target':'error_check',
		'start':'start_bit',
		'end':'error_check',
		}
}


packed_protocol_terminal = [
["Start Bit", 2, 'str', None],
["Length", 1, 'str', None],
["protocol", 1, 'str', None]]



protocol_location = {
	'name':'Location',
	'protocol_number':'0x12',
	'testdata': '78781F120B081D112E10CC027AC7EB0C46584900148F01CC00287D001FB8000380810D0A',
	'template': [
		["start bit", 2, 'str', None],
		["length", 1, 'str', None],
		["protocol", 1, 'str', None],
		["Date Time", 6, 'str', None],
		#GPS Information
		["Satellites count", 1, 'int', None],
		["Latitude degree", 4, 'geo', None],
		["longitude", 4, 'geo', None],
		["speed", 1, 'int', None],
		["course status", 2, 'bin', 16],
		#LBS
		["mcc", 2, 'str', None],
		["mnc", 1, 'str', None],
		["lac", 2, 'str', None],
		["cell id", 3, 'str', None],
		#
		#["aaaa", 2, 'str', None],
		["serial number", 2, 'str', None],
		["error check", 2, 'str', None],
		["stop bit", 2, 'str', None]],

	'check': {
		'target':'error_check',
		'start':'start_bit',
		'end':'error_check',
		}

}



### Heartbeat (18 Byte)
packed_13_terminal = {
	'name':'Heartbeat',
	'protocol_number':'0x13',
	'testdata': '787808134B040300010011061F0D0A',
	'template':	[
		["Start Bit", 2, 'str', None],
		["length", 1, 'str', None],
		["protocol", 1, 'str', None],
		#STATUS Information
		["Terminal Information", 1, 'str', None],
		["Voltage Level", 1, 'int', None],
		["GSM Signal Strength", 1, 'calc_str', None],
		["Alarm/Language", 2, 'str', None],
		#
		["Serial Number", 2, 'str', None],
		["Error Check", 2, 'str', None],
		["Stop Bit", 2, 'str', None]],

	'check': {
		'target':'error_check',
		'start':'start_bit',
		'end':'error_check',
		}
}




packed_server_terminal = {
	'name':'server',
	'protocol_number':'0x03',
	'testdata': '',
	'template':	[
		["Start Bit", 2, 'str', None],
		["Length", 1, 'str', None],
		["protocol", 1, 'str', None],
		["Length of Command", 1, 'str', None],
		["Server Flag Bit", 4, 'str', None],
		["Command Content", 3, 'calc_str', None],
		["Information Serial Number", 2, 'str', None],
		["Error Check", 2, 'str', None],
		["Stop Bit", 2, 'str', None]],

	'check': {
		'target':'error_check',
		'start':'start_bit',
		'end':'error_check',
		}
}



### (42 Byte)
packed_16_terminal = {
	'name':'packed 16',
	'protocol_number':'0x16',
	'testdata': '787825160B0B0F0E241DCF027AC8870C4657E60014020901CC00287D001F726506040101003656A40D0A',
	'template':	[
		["Start Bit", 2, 'str', None],
		["Length", 1, 'str', None],
		["protocol", 1, 'str', None],
		["Date Time", 6, 'str', None],
		["GPS count", 1, 'str', None],
		["Latitude", 4, 'geo', None],
		["Longitude", 4, 'geo', None],
		["Speed", 1, 'int', None],
		["Course status", 2, 'bin', 16],
		#LBS
		["LBS Length", 1, 'str', None],
		["MCC", 2, 'str', None],
		["MNC", 1, 'str', None],
		["LAC", 2, 'str', None],
		["Cell ID", 3, 'str', None],
		#STATUS Information
		["Terminal Information Content", 1, 'str', None],
		["Voltage Level", 1, 'int', None],
		["GSM Signal Strength", 1, 'str', None],
		["Alarm Language", 2, 'str', None],
		#
		["Serial No", 2, 'str', None],
		["Error Check", 2, 'str', None],
		["Stop Bit", 2, 'str', None]],

	'check': {
		'target':'error_check',
		'start':'start_bit',
		'end':'error_check',
		}
}


packed_17_terminal = {
	'name':'packed 17',
	'protocol_number':'0x17',
	'testdata': '787884177E00000001414444524553532626624059044F4D7F6E0028004C004200530029003A5E7F4E1C77015E7F5DDE5E0282B190FD533AFF17FF15FF144E6190530028004E00320033002E003300390035002C0045003100310032002E003900380038002996448FD126263133373130383139313335000000000000000000002323010638250D0A',
	'template':	[
		["Start Bit", 2, 'str', None],
		["Length", 1, 'str', None],
		["protocol", 1, 'str', None],
		["Length of Command", 1, 'int', None],
		["Server Flag Bit", 4, 'str', None],
		["Address", 7, 'str', None],
		#["ALARMSMS", 8, 'str', None],
		["Address content", 2626, 'split_str', None],
		["Phone Number", 21, 'str', None],
		
		["terminator of content", 2, 'str', None],
		["Serial No", 2, 'str', None],
		["error_check", 2, 'str', None],
		["Stop Bit", 2, 'str', None]],

	'check': {
		'target':'error_check',
		'start':'start_bit',
		'end':'error_check',
		}
}



packed_97_terminal = {
	'name':'packed 97',
	'protocol_number':'0x97',
	'testdata': '',
	'template':	[
		["Start Bit", 2, 'str', None],
		["Length", 1, 'str', None],
		["protocol", 1, 'str', None],
		["Length of Command", 1, 'int', None],
		["Server Flag Bit", 4, 'str', None],
		["ALARMSMS", 8, 'str', None],
		["Address", 2626, 'split_str', None],
		["Phone Number", 21, 'str', None],
		["##", 2, 'str', None],
		["terminator of content", 2, 'str', None],
		["Serial No", 2, 'str', None],
		["error_check", 2, 'str', None],
		["Stop Bit", 2, 'str', None]],

	'check': {
		'target':'error_check',
		'start':'start_bit',
		'end':'error_check',
		}
}





t301_protocols.append(protocol_login)
t301_protocols.append(protocol_location)
t301_protocols.append(packed_13_terminal)
t301_protocols.append(packed_server_terminal)
t301_protocols.append(packed_16_terminal)
t301_protocols.append(packed_17_terminal)
t301_protocols.append(packed_97_terminal)