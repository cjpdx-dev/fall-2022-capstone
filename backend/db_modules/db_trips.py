def get_trips(db):
    """Get a list of all trips from the database."""
    trips_ref = db.collection('trips')
    docs = trips_ref.stream()
    trips = [{**doc.to_dict(), "id": doc.id} for doc in docs]
    return trips


def get_trip_by_id(db, id):
    """Get a single trip from the database by its ID."""
    trip_ref = db.collection('trips').document(id)
    trip = trip_ref.get()
    if trip.exists:
        return {**trip.to_dict(), "id": trip.id}
    else:
        return None


def create_trip(db, trip_data):
    """Create a new trip with the provided trip data."""
    if 'name' not in trip_data:
        raise ValueError("Missing required field: 'name'")
    trip_ref = db.collection('trips').document()
    trip_ref.set(trip_data)
    return trip_ref.id


def update_trip(db, id, trip_data):
    """Update an existing trip's information identified by its ID."""
    if 'name' not in trip_data:
        raise ValueError("Missing required field: 'name'")
    trip_ref = db.collection('trips').document(id)
    trip = trip_ref.get()
    if trip.exists:
        if 'name' in trip_data and not trip_data['name'].strip():
            raise ValueError("Trip name cannot be empty.")
        trip_ref.update(trip_data)
        return {**trip.to_dict(), "id": trip.id}
    else:
        return None


def delete_trip(db, id):
    """Delete a trip from the database by its ID."""
    trip_ref = db.collection('trips').document(id)
    trip = trip_ref.get()
    if trip.exists:
        trip_ref.delete()
        return True
    else:
        return False
