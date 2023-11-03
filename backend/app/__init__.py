from flask import Flask
from .blueprints import user_bp, trip_bp, experience_bp


def create_app():
    app = Flask(__name__)

    # Register blueprints
    app.register_blueprint(user_bp, url_prefix='/users')
    app.register_blueprint(trip_bp, url_prefix='/trips')
    app.register_blueprint(experience_bp, url_prefix='/experiences')

    return app
