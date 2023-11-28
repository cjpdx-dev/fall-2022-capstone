from flask import Blueprint, jsonify, current_app, request
from db_modules import db_users

from app.services import verify_token

user_bp = Blueprint('user', __name__)

from firebase_admin.auth import RevokedIdTokenError, InvalidIdTokenError


@user_bp.route('/', methods=['GET'])
def get_user():
    auth_header = request.headers.get('Authorization')

    try:
        user_id = verify_token(auth_header)
        if user_id is None:
            return jsonify({"message": "User not found"}), 404 
        
    except ValueError as e:
        return jsonify({"message": str(e)}), 401
    
    except RevokedIdTokenError as e:
        return jsonify({"message": str(e)}), 401
    
    except InvalidIdTokenError as e:
        return jsonify({"message": str(e)}), 401

    db = current_app.config['db']

    found_user = db_users.get_user_by_id(db, id)
    if found_user is None:
        return jsonify({"message": "User not found"}), 404
    else:
        return jsonify(found_user), 200
    

@user_bp.route('/<int:id>/profile', methods=['GET'])
def get_user_profile_by_id(id):
    db = current_app.config['db']
    found_user = db_users.get_user_by_id(db, id)
    if found_user is None:
        return jsonify({"message": "User not found"}), 404
    else:
        return jsonify(found_user), 200


@user_bp.route('/<int:id>', methods=['PATCH'])
def update_user(id):
    user_data = request.json.get('userData')
    db = current_app.config['db']
    
    updated_user = db_users.update_user(db, id, user_data)
    if updated_user is None:
        return jsonify({"message": "User not found"}), 404
    else: 
        return jsonify(updated_user), 200

@user_bp.route('/<int:id>', methods=['DELETE'])
def delete_user(id):
    pass
