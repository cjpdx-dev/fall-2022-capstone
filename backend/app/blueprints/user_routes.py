
# flask Imports
from flask          import Blueprint, jsonify, current_app, request

# python Imports
from jwt           import ExpiredSignatureError, InvalidTokenError

# project imports
from db_modules     import db_users
from app.services   import verify_token

user_bp = Blueprint('user', __name__)


@user_bp.route('/<int:id>/private', methods=['GET'])
def get_user_with_token():

    try:
        auth_header = request.headers.get('Authorization')
        user_id = verify_token(auth_header)

        if user_id is None:
            return jsonify({"message": "User not found"}), 404 
        if user_id != id:
            return jsonify({"message": "Unauthorized"}), 401
        
    except (ValueError, KeyError) as e:
        return jsonify({"message": str(e)}), 401
    
    except (ExpiredSignatureError, InvalidTokenError) as e:
        return jsonify({"message": str(e)}), 401

    db = current_app.config['db']

    found_user = db_users.get_private_user_by_uid(db, user_id)
    if found_user is None:
        return jsonify({"message": "User not found"}), 404
    else:
        return jsonify(found_user), 200
    

@user_bp.route('/<id>/public', methods=['GET'])
def get_public_user(id):
    db = current_app.config['db']
    found_user = db_users.get_public_user_by_uid(db, id)
    if found_user is None:
        return jsonify({"message": "User not found"}), 404
    else:
        found_user["token"] = ""
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
