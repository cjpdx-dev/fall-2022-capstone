from flask              import Blueprint, jsonify, current_app, request

import jwt
from   datetime         import datetime, timedelta

from   db_modules       import db_users
from   app.services     import hash_password, check_password

import os

auth_bp = Blueprint('auth', __name__)

@auth_bp.route('/register', methods=['POST'])
def register_user():
    print("Called auth_routes.register_user")

    print("Register User Request:")
    print(request.json)

    required_fields = {'userEmail':     request.json.get('userEmail'), 
                       'displayName':   request.json.get('displayName'), 
                       'birthDate':     request.json.get('birthDate'), 
                       'userPassword':  request.json.get('userPassword') }

    for field in required_fields.keys():
        if required_fields[field] is None:
            print("Missing required field: " + str(field))
            return jsonify({"message": f"{field} is required"}), 400

    db = current_app.config['db']

    # Confirm user does not already exist
    found_user = db_users.get_user_by_email(db, required_fields['userEmail'])
    if found_user is not None:
        print("User already exists")
        return jsonify({"message": "User already exists"}), 400

    # Hand and salt the password
    hashed_password = hash_password(required_fields['userPassword'])
    required_fields['userPassword'] = hashed_password

    # Register the user
    new_user_id = db_users.register_user(db, required_fields)

    # Generate a JWT to establish a session for the user
    session_token = generate_jwt(new_user_id)
    if session_token is None:
        return jsonify({"message": "User Session Token Could Not Be Created - Login Failed"}), 401
    else:
        user = db_users.get_user_by_id(db, new_user_id)
        user['token'] = session_token
        print(user)
        return jsonify(user), 201


@auth_bp.route('/login', methods=["POST"])
def login():
    print("Called auth_routes.login")

    required_fields = {'userEmail':     request.json.get('userEmail'), 
                       'userPassword':  request.json.get('userPassword') }

    for field in required_fields.keys():
        if required_fields[field] is None:
            return jsonify({"message": f"{field} is required"}), 400
    
    db = current_app.config['db']
        
    # Confirm user exists
    user = db_users.get_user_by_email(db, required_fields['userEmail'], include_password_hash=True)
    if user is None:
        print("user not found")
        return jsonify({"message": "Invalid Credentials"}), 404
    
    # Confirm password is correct
    if not check_password(required_fields['userPassword'], user['passwordHash']):
        print("password incorrect")
        return jsonify({"message": "Invalid credentials"}), 404
    else:
        user.pop('passwordHash')

    # Generate a JWT to establish a session for the user
    session_token = generate_jwt(user['id'])
    if session_token is None:
        return jsonify({"message": "login failed. session token could not be generated"}), 401
    else:
        user['token'] = session_token
        print("Returning user: " + str(user))
        return jsonify(user), 200

def generate_jwt(uid):

    payload = {
        'sub': uid,
        'iat': datetime.utcnow(),
        'exp': datetime.utcnow() + timedelta(days=30)
    }
    print("hello")
    session_token = jwt.encode(payload, os.environ.get('PRIVATE_KEY'), algorithm='RS256')
    print("goodbye")
    return session_token
    

    