from flask import Flask

from google.cloud import storage

from .blueprints import user_bp, trip_bp, experience_bp, auth_bp

from firebase_admin import firestore, credentials, initialize_app

from cryptography.hazmat.backends import default_backend
from cryptography.hazmat.primitives import serialization
from cryptography.hazmat.primitives.asymmetric import rsa

import os
import json


def create_app():
    app = Flask(__name__)

    # Initialize Firebase
    abs_cred_path = os.path.join(os.path.dirname(os.path.abspath(__file__)),
                                 'firestore_sa.json')
    
    cred = credentials.Certificate(abs_cred_path)
    initialize_app(cred)

    db = firestore.client()
    storage_client = storage.Client()
    app.config['db'] = db
    app.config['storage'] = storage_client

    # Open the firetore_sa.json as a json object and set the SECRET_KEY
    app_creds = json.load(open(abs_cred_path))
    os.environ['PRIVATE_KEY'] = app_creds['private_key']
    os.environ['PRIVATE_KEY_ID'] = app_creds['private_key_id']

    public_key_path = os.path.join(os.path.dirname(os.path.abspath(__file__)),
                                 'public_key.pem')
    
    private_key_path = os.path.join(os.path.dirname(os.path.abspath(__file__)),
                                'private_key.pem')
    
    with open(private_key_path, 'r')  as private_key_file:
        os.environ['JWT_PRIVATE_KEY'] = private_key_file.read()
    print(os.environ.get('JWT_PRIVATE_KEY'))
   
    with open(public_key_path, 'r') as public_key_file:
        os.environ['JWT_PUBLIC_KEY'] = public_key_file.read()
    print(os.environ.get('JWT_PUBLIC_KEY'))
    


    # private_key_pem, public_key_pem = generate_rsa_key_pair()
    # os.environ['JWT_PRIVATE_KEY'] = private_key_pem
    # os.environ['JWT_PUBLIC_KEY'] = public_key_pem

    



    # Register blueprints
    app.register_blueprint(user_bp, url_prefix='/users')
    app.register_blueprint(trip_bp, url_prefix='/trips')
    app.register_blueprint(experience_bp, url_prefix='/experiences')
    app.register_blueprint(auth_bp, url_prefix='/auth')

    return app

# def generate_rsa_key_pair():
#     private_key = rsa.generate_private_key(
#         public_exponent=65537,
#         key_size=2048,
#         backend=default_backend()
#     )

#     private_pem = private_key.private_bytes(
#         encoding=serialization.Encoding.PEM,
#         format=serialization.PrivateFormat.PKCS8,
#         encryption_algoritym=serialization.NoEncryption()
#     )

#     public_key = private_key.public_key()

#     public_pem = public_pem = public_key.public_bytes(
#         encoding=serialization.Encoding.PEM,
#         format=serialization.PublicFormat.SubjectPublicKeyInfo
#     )

#     return private_pem, public_pem


