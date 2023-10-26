from flask import Blueprint, jsonify
from ..db import db

user_bp = Blueprint('user', __name__)


@user_bp.route('/')
def get_users():
    pass
