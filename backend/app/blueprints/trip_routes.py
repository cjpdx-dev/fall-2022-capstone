from firebase_admin import auth
from flask import Blueprint, jsonify, request, current_app
from backend.db_modules import db_trips
from backend.app.services.security import verify_token


trip_bp = Blueprint('trip', __name__)


def verify_user(request):
    """Verifies the user based on the 'Authorization' token in the
    request header."""
    auth_header = request.headers.get('Authorization')
    try:
        user_id = verify_token(auth_header)
        if not user_id:
            raise ValueError("User not found")
        return user_id
    except (auth.RevokedIdTokenError, auth.InvalidIdTokenError) as e:
        raise ValueError(str(e))


def verify_trip_ownership(user_id, trip_id, db):
    """Verifies that the user attempting to modify a trip is the owner
    of that trip."""
    trip = db_trips.get_trip_by_id(db, trip_id)
    if trip is None:
        raise ValueError("Trip not found")
    if trip.get('user') != user_id:
        raise ValueError("User is not authorized to modify this trip")


@trip_bp.route('/', methods=['GET'])
def get_trips():
    """Handle GET request to list all trips."""
    db = current_app.config['db']
    found_trips = db_trips.get_trips(db)
    if found_trips is None:
        return jsonify({"message": "No trips found"}), 404
    else:
        return jsonify(found_trips), 200


@trip_bp.route('/<id>', methods=['GET'])
def get_trip(id):
    """Handle GET request to retrieve details of trip with given id."""
    db = current_app.config['db']
    trip = db_trips.get_trip_by_id(db, id)
    if trip is None:
        return jsonify({"message": "Trip not found"}), 404
    else:
        return jsonify(trip), 200


@trip_bp.route('/', methods=['POST'])
def create_trip():
    """Handle POST request to create a new trip entry."""
    db = current_app.config['db']
    trip_data = request.json

    # Add user_id to 'user' property of trip
    try:
        user_id = verify_user(request)
        trip_data['user'] = user_id
    except ValueError as e:
        return jsonify({"message": str(e)}), 401

    if 'name' not in trip_data:
        return jsonify({"message": "Missing trip name"}), 400

    try:
        trip_id = db_trips.create_trip(db, trip_data)
        return jsonify({"id": trip_id}), 201
    except Exception as e:
        return jsonify({"message": str(e)}), 400


@trip_bp.route('/<id>', methods=['PATCH'])
def update_trip(id):
    """Handle PATCH request to update an existing trip with given id."""
    db = current_app.config['db']
    trip_data = request.json

    # Verify user
    try:
        user_id = verify_user(request)
        verify_trip_ownership(user_id, id, db)
    except ValueError as e:
        return jsonify({"message": str(e)}), 401

    # Update trip
    updated_trip = db_trips.update_trip(db, id, trip_data)
    if updated_trip is None:
        return jsonify({"message": "Trip not found"}), 404
    else:
        return jsonify(updated_trip), 200


@trip_bp.route('/<id>', methods=['DELETE'])
def delete_trip(id):
    """Handle DELETE request to remove a trip with given id."""
    db = current_app.config['db']

    # Verify user
    try:
        user_id = verify_user(request)
        verify_trip_ownership(user_id, id, db)
    except ValueError as e:
        return jsonify({"message": str(e)}), 401

    # Delete trip
    result = db_trips.delete_trip(db, id)
    if result:
        return jsonify({"message": "Trip deleted"}), 200
    else:
        return jsonify({"message": "Trip not found"}), 404
