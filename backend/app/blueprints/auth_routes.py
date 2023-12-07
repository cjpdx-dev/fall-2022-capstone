
# flask imports
from flask              import Blueprint, jsonify, current_app, request

# python imports
import os
import jwt
import bcrypt
from   datetime         import datetime, timedelta

# project imports
from   db_modules       import db_users


# init blueprint
auth_bp = Blueprint('auth', __name__)


@auth_bp.route('/register', methods=['POST'])
def register_user():

    required_fields = {'userEmail':     request.json.get('userEmail'), 
                       'displayName':   request.json.get('displayName'), 
                       'birthDate':     request.json.get('birthDate'), 
                       'hash':          request.json.get('userPassword') 
    }

    # Confirm all required fields are present
    for field in required_fields.keys():
        if required_fields[field] is None:
            return jsonify({"message": f"{field} is required"}), 400

    # TODO: Add additional validation for email/password format, request format/size, etc

    # Confirm user does not already exist
    db = current_app.config['db']
    found_user = db_users.get_private_user_by_email(db, required_fields['userEmail'])
    if found_user is not None:
        return jsonify({"message": "User email already exists"}), 400

    # Hash and salt the password
    required_fields['hash'] = hash_password(required_fields['hash'])

    # Register the user
    created_user = db_users.register_user(db, required_fields)

    # Generate a JWT to establish a session for the user
    session_token = generate_jwt(created_user['id'])
    
    # Confirm a session token was generated, then return the user object with the session token
    if session_token is None:
        return jsonify({"message": "User Session Token Could Not Be Created - Login Failed"}), 401
    else:
        created_user['token'] = session_token
        return jsonify(created_user), 201


@auth_bp.route('/login', methods=["POST"])
def login():

    # Define required fields
    required_fields = {'userEmail':     request.json.get('userEmail'), 
                       'userPassword':  request.json.get('userPassword') 
    }

    # Confirm all required fields are present
    for field in required_fields.keys():
        if required_fields[field] is None:
            return jsonify({"message": f"{field} is required"}), 400

    # TODO: Add additional validation for email/password format, request format/size, etc

    # Validate user email and get user object
    db = current_app.config['db']
    user = db_users.get_private_user_by_email(db, required_fields['userEmail'], include_creds_id=True)
    if user is None:
        return jsonify({"message": "Invalid Credentials"}), 404
    
    # Get hashed credentials
    user_creds = db_users.get_user_creds(db, user['creds_id'])

    # Confirm password is correct
    if not check_password(required_fields['userPassword'], user_creds['hash']):
        return jsonify({"message": "Invalid credentials"}), 404
    else:
        user.pop('creds_id', None)

    # Generate a JWT to establish a session for the user,
    session_token = generate_jwt(user['id'])
    if session_token is None:
        return jsonify({"message": "login failed. session token could not be generated"}), 401
    
    # Attach session token to user and return user object
    user['token'] = session_token
    return jsonify(user), 200


def generate_jwt(uid):

    payload = {
        'sub': uid,
        'iat': datetime.utcnow(),
        'exp': datetime.utcnow() + timedelta(days=7)
    }

    private_key = os.environ.get('JWT_PRIVATE_KEY')
    session_token = jwt.encode(payload, private_key, algorithm='RS256')
    return session_token


def hash_password(password):
    return bcrypt.hashpw(password.encode('utf-8'), bcrypt.gensalt())


def check_password(password, hashed_password):
    return  bcrypt.checkpw(password.encode('utf-8'), hashed_password)


    

    