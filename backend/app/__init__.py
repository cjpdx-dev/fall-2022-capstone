from flask import Flask

from google.cloud import storage

from .blueprints import user_bp, trip_bp, experience_bp, auth_bp

from firebase_admin import firestore, credentials, initialize_app

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

    # Register blueprints
    app.register_blueprint(user_bp, url_prefix='/users')
    app.register_blueprint(trip_bp, url_prefix='/trips')
    app.register_blueprint(experience_bp, url_prefix='/experiences')
    app.register_blueprint(auth_bp, url_prefix='/auth')

    return app
