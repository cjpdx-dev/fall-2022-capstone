from flask import Flask
from flask import Blueprint
from flask import send_file
from db_modules import db_trips

import urllib.request

trip_bp = Blueprint('trip', __name__)

@trip_bp.route('/')
def get_trips():
    pass
