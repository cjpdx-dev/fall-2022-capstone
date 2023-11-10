from flask import Blueprint, jsonify, request, current_app
from db_modules import db_experiences
import json

experience_bp = Blueprint('experience', __name__)

@experience_bp.route('/create', methods=["POST"])
def createExperience():
    experience = json.loads(request.form['experience'])
    imageFile = request.files['image']

    print(type(experience))
    # Add URL to the experience
    experience["imageUrl"] = 'randomImageURL'
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

