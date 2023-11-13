from flask import Blueprint, jsonify, request, current_app
from db_modules import db_experiences
import json
from ..services.security import verify_token
from firebase_admin.auth import RevokedIdTokenError, InvalidIdTokenError

experience_bp = Blueprint('experience', __name__)

@experience_bp.route('/create', methods=["POST"])
def createExperience():
    # Authenticate User ----- TODO --------------

    # Store image in the cloud bucket
    imageFile = request.files['image']
    storage_client = current_app.config['storage']
    bucket = storage_client.bucket('fall-2023-capstone.appspot.com')
    name = imageFile.filename
    blob = bucket.blob(name)
    blob.upload_from_file(imageFile)
    

    # Convert string JSON to JSON
    experience = json.loads(request.form['experience'])

    # Add url for stored image to experience object 
    image_url = blob.self_link
    experience["imageUrl"] = image_url

    
    # Add experience to the database
    db = current_app.config['db']
    createdExperience = db_experiences.create_experience(db, experience)
    print(createdExperience)
    return experience


@experience_bp.route('/')
def get_experiences():
    # Authenticate User ----- TODO --------------
    auth_header = request.headers.get('Authorization')

    try:
        user_id = verify_token(auth_header)
        if user_id is None:
            return jsonify({"message": "User not found"}), 404 
        
    except ValueError as e:
        return jsonify({"message": str(e)}), 401
    
    except RevokedIdTokenError as e:
        return jsonify({"message": str(e)}), 401
    
    except InvalidIdTokenError as e:
        return jsonify({"message": str(e)}), 401

    db = current_app.config['db']
    experiences = db_experiences.get_experiences(db)
    if experiences is None:
        return jsonify({"message": "No users found"}), 404
    else:
        print(experiences)
        return jsonify(experiences), 200

    # Convert Image? 
    # Get all experiences in the database to display  to the user
    return {"hello": "world"}



@experience_bp.route('/update/<int:id>', methods=["PATCH", "POST"])
def updateExperience(id):
     # Authenticate User ----- TODO --------------

    db = current_app.config['db']

    # Verify that Experience exists
    if not db_experiences.experience_exists(db, id):
        return jsonify({"message": "Experience not found"}), 404

    # Verify that current owner is the owner of the experience before updating it
    
    # If this experience is included in Trips, update it
   

@experience_bp.route('/delete/<int:id>')
def deleteExperience(id):

    db = current_app.config['db']
    # Verify that the Experience exists
    if not db_experiences.experience_exists(db, id):
        return jsonify({"message": "Experience not found"}), 404
    

    # Verify that current owner is the owner of the experience before deleting it

    # If this experience is included in Trips delete it from Trips
    pass

