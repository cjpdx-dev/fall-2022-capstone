from flask import Blueprint, jsonify
from ..db import db

trip_bp = Blueprint('trip', __name__)


@trip_bp.route('/')
def get_trips():
    pass
