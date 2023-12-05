
# flask Imports
from flask          import Blueprint, jsonify, current_app, request

# python Imports
from jwt           import ExpiredSignatureError, InvalidTokenError

# project imports
from db_modules     import db_users
from app.services   import verify_token

user_bp = Blueprint('user', __name__)


@user_bp.route('/<string:id>/private', methods=['GET'])
def get_user_with_token(id):
    print("@user_bp.route('/<string:id>/private', methods=['GET'])")
    print(request.headers)
    try:
        auth_header = request.headers.get('Authorization')
        print(auth_header)
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
    

@user_bp.route('/<string:id>/public', methods=['GET'])
def get_public_user(id):
    db = current_app.config['db']
    found_user = db_users.get_public_user_by_uid(db, id)
    if found_user is None:
        return jsonify({"message": "User not found"}), 404
    else:
        return jsonify(found_user), 200


@user_bp.route('/<string:id>', methods=['PUT'])
def update_user(id):

    print(request.headers)
    try:
        auth_header = request.headers.get('Authorization')
        print(auth_header)
        user_id = verify_token(auth_header)

        if user_id is None:
            print("user_id is none")
            return jsonify({"message": "User not found"}), 404 

        if user_id != id:
            print("user_id != id")
            return jsonify({"message": "Unauthorized"}), 401

    except (ValueError, KeyError) as e:
        print(str(e))
        return jsonify({"message": str(e)}), 401
    except (ExpiredSignatureError, InvalidTokenError) as e:
        print(str(e))
        return jsonify({"message": str(e)}), 401

    required_fields =  {'displayName':           request.json.get('displayName'), 
                        'userBio':               request.json.get('userBio'), 
                        'homeCity':              request.json.get('homeCity'),
                        'homeState':             request.json.get('homeState'),
                        'profileIsPublic':       request.json.get('profileIsPublic'),
                        'locationIsPublic':      request.json.get('locationIsPublic'),
                        'experiencesArePublic':  request.json.get('experiencesArePublic'),
                        'tripsArePublic':        request.json.get('tripsArePublic')

    }

    db = current_app.config['db']
    updated_user = db_users.update_user(db, user_id, required_fields)
    if updated_user is None:
        print("updated_user is none")
        return jsonify({"message": "User not found"}), 404
    else: 
        updated_user.pop('creds_id', None)
        updated_user['token'] = auth_header.split(' ')[1]
        return jsonify(updated_user), 200


@user_bp.route('/<string:id>', methods=['DELETE'])
def delete_user(id):
    print("@user_bp.route('/<string:id>', methods=['DELETE'])")
    print(request.headers)
    try:
        auth_header = request.headers.get('Authorization')
        print(auth_header)
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
    userWasDeleted = db_users.delete_user(db, user_id)
    
    if userWasDeleted is None:
        return jsonify({"message": "User not found"}), 404
    elif userWasDeleted:
        return jsonify({}), 204
    else:
        return jsonify({"message": "User could not be deleted"}), 500
        
