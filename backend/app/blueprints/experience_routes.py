from flask import Blueprint, jsonify
from db_modules import db_experiences

experience_bp = Blueprint('experience', __name__)

@experience_bp.route('/')
def get_experiences():
    pass

