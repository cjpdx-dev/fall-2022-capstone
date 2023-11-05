from flask              import Blueprint, jsonify, current_app, request

import jwt
from   jwt              import PyJWKClient
from   jwt.exceptions   import InvalidTokenError
import requests

from   datetime         import datetime, timedelta
from   firebase_admin   import firestore, auth as firebase_auth

auth_bp = Blueprint('auth', __name__)

@auth_bp.route('/auth/apple', methods=['POST'])
def auth_with_apple():

    apple_ident_token   = request.json.get('appleIdToken')
    apple_user_ident    = request.json.get('userIdentifier')

    user_birth_year     = request.json.get('birthYear')
    user_nickname       = request.json.get('nickname')

    decoded_token = verify_apple_identity_token(apple_ident_token)

    if decoded_token is None:
        return jsonify({'error': 'Invalid token'}), 401

    user = find_user(apple_user_ident)
    if not user:
        user = create_user(apple_user_ident, user_birth_year, user_nickname)

    user_session_token = generate_jwt(apple_user_ident)
    return jsonify({'session_token': user_session_token}), 200

# Helper Functions

def find_user(user_identifier):

    with current_app.app_context():
        db = current_app.config['db']

        user_ref = db.collection('users').where('apple_user_id', '==', user_identifier).get()
        if len(user_ref) == 0:
            return None
        return user_ref[0]
    

def create_user(apple_user_ident, birth_year, nickname):
    with current_app.app_context():
        db = current_app.config['db']
        user_ref = db.collection(u'users').document(apple_user_ident)

        user_ref.set({
            'apple_user_id': apple_user_ident,
            'birth_year': birth_year,
            'nickname': nickname,
            'created_at': firestore.SERVER_TIMESTAMP,
            'updated_at': firestore.SERVER_TIMESTAMP
        })

        return user_ref.get()
    

def generate_jwt(apple_user_ident):
    payload = {
        'sub': apple_user_ident,
        'iat': datetime.utcnow(),
        'exp': datetime.utcnow() + timedelta(days=30) 
    } 
    user_session_token = jwt.enode(payload, current_app.config['SECRET_KEY'], algorithm='HS256')
    return user_session_token


def verify_apple_identity_token(apple_ident_token):
    apple_public_keys_url = 'https://appleid.apple.com/auth/keys'


    jwks_client = PyJWKClient(apple_public_keys_url)

    signing_key = jwks_client.get_signing_key_from_jwt(apple_ident_token)

    try:
        decoded_token = jwt.decode(
            apple_ident_token,
            signing_key.key,
            algorithms=['RS256'],
            audience='sweenbean333.TravelApp',
            issuer='https://appleid.apple.com',
        )
        return decoded_token
    except jwt.PyJWTError as e:
        print(f"Error decoding token: {e}")
        return None


# For logout, we do this on the client side by deleting the stored session_token that 