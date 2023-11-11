from flask import Flask, jsonify

from google.cloud import firestore, storage

from .blueprints import user_bp, trip_bp, experience_bp, auth_bp

from firebase_admin import firestore, credentials, initialize_app

import os

def create_app():
    app = Flask(__name__)
    app.secret_key = 'super secret key'

    # Initialize Firebase
    abs_cred_path = os.path.join(os.path.dirname(os.path.abspath(__file__)),
                             'firestore_sa.json')
    
    abs_cred_path = os.path.join(os.path.dirname(os.path.abspath(__file__)),
                                    'firestore_sa.json')
    
    cred = credentials.Certificate(abs_cred_path)
    initialize_app(cred)

    db = firestore.client()
    storage_client = storage.Client()
    app.config['db'] = db
    app.config['storage'] = storage_client

    # Register blueprints
    app.register_blueprint(user_bp, url_prefix='/users')
    app.register_blueprint(trip_bp, url_prefix='/trips')
    app.register_blueprint(experience_bp, url_prefix='/experiences')
    app.register_blueprint(auth_bp, url_prefix='/auth')

    return app
