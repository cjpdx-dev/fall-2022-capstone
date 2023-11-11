from flask import Blueprint, jsonify, request, current_app
from db_modules import db_experiences
import json

experience_bp = Blueprint('experience', __name__)

@experience_bp.route('/create', methods=["POST"])
def createExperience():
    # Authenticate User ----- TODO --------------

    # Store image in the cloud bucket ------TODO ---------
    imageFile = request.files['image']
    storage_client = current_app.config['storage']
    bucket = storage_client.bucket('fall-2023-capstone.appspot.com')
    name = imageFile.filename
    blob = bucket.blob(name)
    uploaded_file = blob.upload_from_file(imageFile)
    print(uploaded_file)

    # Convert string JSON to JSON
    experience = json.loads(request.form['experience'])

    # Add url for stored image --------- TODO -------------
    experience["imageUrl"] = 'randomImageURL'

    # Add URL to the experience
    db = current_app.config['db']
    # Add experience to the database
    db_experiences.create_experience(db, experience)
    print(imageFile)
    return experience


@experience_bp.route('/')
def get_experiences():
    # Get all experiences in the database to display  to the user
    return {"hello": "world"}



@experience_bp.route('/update/<int:id>')
def updateExperience():
    # Verify that current owner is the owner of the experience before updating it
    pass

@experience_bp.route('/delete/<int:id>')
def deleteExperience():
    # Verify that current owner is the owner of the experience before deleting it
    pass

