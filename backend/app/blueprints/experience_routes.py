from flask import Blueprint, jsonify, request, current_app
from db_modules import db_experiences
import json
from app.services import verify_token
from firebase_admin.auth import RevokedIdTokenError, InvalidIdTokenError

experience_bp = Blueprint('experience', __name__)

@experience_bp.route('/', methods=["POST"])
def createExperience():
    # Authenticate User ----- TODO --------------

    # Store image in the cloud bucket
    imageFile = request.files['image']
    storage_client = current_app.config['storage']
    bucket = storage_client.bucket('fall-2023-capstone.appspot.com')
    name = imageFile.filename
    blob = bucket.blob(name)
    blob.upload_from_file(imageFile)
    blob.make_public()
    

    # Convert string JSON to JSON
    experience = json.loads(request.form['experience'])

    # Add url for stored image to experience object 
    image_url = blob.public_url
    experience["imageUrl"] = image_url

    
    # Add experience to the database
    db = current_app.config['db']
    createdExperience = db_experiences.create_experience(db, experience)
    print(createdExperience)
    return experience


@experience_bp.route('/', methods=["GET"])
def get_experiences():
    # Authenticate User ----- TODO --------------
    # auth_header = request.headers.get('Authorization')

    # try:
    #     user_id = verify_token(auth_header)
    #     if user_id is None:
    #         return jsonify({"message": "User not found"}), 404 
        
    # except ValueError as e:
    #     return jsonify({"message": str(e)}), 401
    
    # except RevokedIdTokenError as e:
    #     return jsonify({"message": str(e)}), 401
    
    # except InvalidIdTokenError as e:
    #     return jsonify({"message": str(e)}), 401

    db = current_app.config['db']
    experiences = db_experiences.get_experiences(db)
    if experiences is None:
        return jsonify({"message": "No users found"}), 404
    else:
        return jsonify(experiences), 200

    # Convert Image? 
    # Get all experiences in the database to display  to the user
    return {"hello": "world"}



@experience_bp.route('/<id>', methods=["POST"])
def updateExperience(id):
     # Authenticate User ----- TODO --------------
    db = current_app.config['db']
    # Make sure that the Experience exists
    old_experience = db_experiences.get_experience_by_id(db, id)
    if  not old_experience:
        return jsonify({"message": "Experience not found"}), 404

    # Make sure that the user is the owner of the experience

    # Convert string JSON to JSON
    updated_experience = json.loads(request.form['experience'])

    # Check a file was sent, then a new image was chosen
    new_image_file = request.files.get('image')
    
    
    
    # Check if image changed - if so, delete the old image and store the new one
    if new_image_file:
        # Delete the old image
        # Optional: set a generation-match precondition to avoid potential race conditions
        # and data corruptions. The request to delete is aborted if the object's
        # generation number does not match your precondition.
        storage_client = current_app.config['storage']
        bucket = storage_client.bucket('fall-2023-capstone.appspot.com')
        
        old_image_file_name = old_experience["imageUrl"].split('/')[-1]
        blob = bucket.get_blob(old_image_file_name)
        generation_match_precondition = None
        blob.reload()  # Fetch blob metadata to use in generation_match_precondition.
        generation_match_precondition = blob.generation
        blob.delete(if_generation_match=generation_match_precondition)

        # Create new blob
        new_image_file_name = new_image_file.filename
        blob = bucket.blob(new_image_file_name)
        blob.upload_from_file(new_image_file)
        blob.make_public()
        updated_experience["imageUrl"] = blob.public_url

    
    # Update Experience in the the database
    db = current_app.config['db']
    temp_id = updated_experience["id"]
    del updated_experience["id"]
    updated_experience = db_experiences.update_experience(db, temp_id, updated_experience)
    if updated_experience:
        print(updated_experience)
        return updated_experience, 200
    else:
        print("Failed to update the experience")
        return jsonify({"message": "Experience not found"})
   

@experience_bp.route('/<id>', methods=["DELETE"])
def deleteExperience(id):
    db = current_app.config['db']
    
    # Verify that the Experience exists
    experience = db_experiences.get_experience_by_id(db, id)
    print(experience)
    if  not experience:
        return jsonify({"message": "Experience not found"}), 404

    
    # Verify that current owner is the owner of the experience before deleting it

    # Delete image associated with Experience
    blob_name = experience['imageUrl'].split('/')[-1]
    storage_client = current_app.config['storage']
    bucket = storage_client.bucket('fall-2023-capstone.appspot.com')
    blob = bucket.blob(blob_name)
    generation_match_precondition = None

    # Optional: set a generation-match precondition to avoid potential race conditions
    # and data corruptions. The request to delete is aborted if the object's
    # generation number does not match your precondition.
    blob.reload()  # Fetch blob metadata to use in generation_match_precondition.
    generation_match_precondition = blob.generation
    blob.delete(if_generation_match=generation_match_precondition)

    # Delete the Experience
    if db_experiences.delete_experience(db, id):
        print('Experience Deleted')
        return jsonify({"message": "Experience deleted"}), 204
    else:
        print('Experience could not be deleted')
        jsonify({"message": "Experience could not be deleted"}), 404
   

