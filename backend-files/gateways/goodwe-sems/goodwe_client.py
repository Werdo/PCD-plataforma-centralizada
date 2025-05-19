# goodwe_client.py
import requests
import os
import logging
from dotenv import load_dotenv

load_dotenv()

SEMS_BASE = "https://eu.semsportal.com/api/v2/"

class GoodWeClient:
    def __init__(self):
        self.username = os.getenv("SEMS_USER")
        self.password = os.getenv("SEMS_PASS")
        self.plant_id = os.getenv("PLANT_ID")
        self.token = None
        self.headers = {
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Token": "",
            "Language": "en"
        }
        self.login()

    def login(self):
        url = SEMS_BASE + "Common/CrossLogin"
        payload = {"account": self.username, "pwd": self.password}
        response = requests.post(url, json=payload, headers=self.headers)
        if response.ok:
            self.token = response.json()["data"]["token"]
            self.headers["Token"] = self.token
        else:
            raise Exception("❌ Error de autenticación SEMS")

    def get_plant_data(self):
        if not self.plant_id:
            raise Exception("PLANT_ID no definido")
        url = SEMS_BASE + "PowerStation/GetMonitorDetailByPowerstationId"
        response = requests.post(url, json={"powerStationId": self.plant_id}, headers=self.headers)
        if response.ok:
            return response.json()["data"]
        else:
            raise Exception(f"Error HTTP {response.status_code}: {response.text}")
