from flask import Flask, jsonify
import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore

app = Flask(__name__)

cred = credentials.Certificate('firestore_sa.json')
firebase_admin.initialize_app(cred)

db = firestore.client()


@app.route('/')
def index():
    # Testing database
    user_ref = db.collection('Users').document('chozen1')
    user_ref.set({
        'first_name': 'Harry',
        'last_name': 'Potter',
    })

    user = user_ref.get().to_dict()

    return jsonify(user)
