from firebase_admin import auth
from flask import Blueprint, jsonify, request, current_app
from db_modules import db_trips
from app.services import verify_token
from datetime import datetime, timedelta, timezone


trip_bp = Blueprint('trip', __name__)


def verify_user(request):
    """Verifies the user based on the 'Authorization' token in the
    request header."""
    auth_header = request.headers.get('Authorization')
    try:
        user_id = verify_token.verify_token(auth_header)
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


def validate_trip_name(name):
    """Verifies that provided trip name has valid length and characters."""
    if len(name) > 50:
        return "Trip name must be 50 characters or less"
    if not name.strip():
        return "Name cannot be empty or whitespace only"
    return None


def validate_trip_dates(start_date_str, end_date_str):
    """Verifies that startDate and endDate of trip are valid."""
    # Replace 'Z' with '+00:00' for UTC
    start_date_str = start_date_str.replace('Z', '+00:00')
    end_date_str = end_date_str.replace('Z', '+00:00')

    try:
        start_date = datetime.fromisoformat(start_date_str)
        end_date = datetime.fromisoformat(end_date_str)
    except ValueError:
        return "Invalid date format"

    # Check that trip is not longer than a year
    max_duration = timedelta(days=365)
    if end_date - start_date > max_duration:
        return "Trip duration cannot exceed 1 year"

    # Check that dates are not more than 50 years in past or future
    past_limit = datetime.now(timezone.utc) - timedelta(days=365 * 50)
    future_limit = datetime.now(timezone.utc) + timedelta(days=365 * 50)
    if start_date < past_limit or end_date < past_limit:
        return "Dates cannot be more than 50 years in the past"
    if start_date > future_limit or end_date > future_limit:
        return "Dates cannot be more than 50 years in the future"

    # Check that start date is not after end date
    if start_date > end_date:
        return "Start date cannot be after end date"
    return None


def validate_trip_description(description):
    """Verifies that trip description has valid length."""
    if len(description) > 200:
        return "Trip description must be 200 characters or less"


@trip_bp.route('', methods=['GET'])
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


@trip_bp.route('', methods=['POST'])
@trip_bp.route('/', methods=['POST'])
def create_trip():
    """Handle POST request to create a new trip entry."""
    db = current_app.config['db']
    trip_data = request.json

    # # Add user_id to 'user' property of trip
    # try:
    #     user_id = verify_user(request)
    #     trip_data['user'] = user_id
    # except ValueError as e:
    #     return jsonify({"message": str(e)}), 401
    trip_data['user'] = "fakeUserId"

    # Check that required attributes are provided
    if 'name' not in trip_data or 'startDate' not in trip_data \
            or 'endDate' not in trip_data:
        return jsonify({"message": "Missing required trip fields: "
                                   "name, startDate, and endDate"}), 400

    # Validate trip name
    error_message = validate_trip_name(trip_data['name'])
    if error_message:
        return jsonify({"message": error_message}), 400

    # Validate trip dates
    error_message = validate_trip_dates(trip_data['startDate'],
                                        trip_data['endDate'])
    if error_message:
        return jsonify({"message": error_message}), 400

    # Set description to empty string if not provided
    if 'description' not in trip_data:
        trip_data['description'] = ""
    else:
        error_message = validate_trip_description(trip_data['description'])
        if error_message:
            return jsonify({"message": error_message}), 400

    # Create trip
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

    # # Verify user
    # try:
    #     user_id = verify_user(request)
    #     verify_trip_ownership(user_id, id, db)
    # except ValueError as e:
    #     return jsonify({"message": str(e)}), 401

    # Retrieve existing trip data and initialize dates for validation
    existing_trip = db_trips.get_trip_by_id(db, id)
    if existing_trip is None:
        return jsonify({"message": "Trip not found"}), 404
    start_date = trip_data.get('startDate') or existing_trip.get('startDate')
    end_date = trip_data.get('endDate') or existing_trip.get('endDate')

    # Validate trip dates if provided:
    if 'startDate' in trip_data or 'endDate' in trip_data:
        error_message = validate_trip_dates(start_date, end_date)
        if error_message:
            return jsonify({"message": error_message}), 400

    # Validate trip name if provided
    if 'name' in trip_data:
        if not trip_data['name'].strip():
            return jsonify({"message": "Name cannot be empty"}), 400
        error_message = validate_trip_name(trip_data['name'])
        if error_message:
            return jsonify({"message": error_message}), 400

    # Validate trip description if provided
    if 'description' in trip_data:
        error_message = validate_trip_description(trip_data['description'])
        if error_message:
            return jsonify({"message": error_message}), 400

    # Update trip
    db_trips.update_trip(db, id, trip_data)
    updated_trip = db_trips.get_trip_by_id(db, id)
    if updated_trip is None:
        return jsonify({"message": "Trip not found"}), 404
    else:
        return jsonify(updated_trip), 200


@trip_bp.route('/<id>', methods=['DELETE'])
def delete_trip(id):
    """Handle DELETE request to remove a trip with given id."""
    db = current_app.config['db']

    # # Verify user
    # try:
    #     user_id = verify_user(request)
    #     verify_trip_ownership(user_id, id, db)
    # except ValueError as e:
    #     return jsonify({"message": str(e)}), 401

    # Delete trip
    result = db_trips.delete_trip(db, id)
    if result:
        return jsonify({"message": "Trip deleted"}), 200
    else:
        return jsonify({"message": "Trip not found"}), 404
