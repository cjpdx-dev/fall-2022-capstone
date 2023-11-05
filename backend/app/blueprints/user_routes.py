from flask import Blueprint, jsonify, current_app, request
from db_modules import db_users

from ..services.security import verify_token

user_bp = Blueprint('user', __name__)

from firebase_admin.auth import RevokedIdTokenError, InvalidIdTokenError

@user_bp.route('/', methods=['GET'])
# Gets all users - we likely won't need this, but may need a way to get all users for testing/admin purposes
# or if we want users to be able to search for other users (but filtering by username, city/state, etc)
# def get_users():
#     db = current_app.config['db']
#     found_users = db_users.get_users(db)
#     if found_users is None:
#         return jsonify({"message": "No users found"}), 404
#     else:
#         return jsonify(found_users), 200


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

# @user_bp.route('/<int:id>', methods=['PUT'])
# def replace_user(id):
#     pass

@user_bp.route('/<int:id>', methods=['DELETE'])
def delete_user(id):
    pass
