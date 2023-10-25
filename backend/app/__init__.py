from flask import Flask, jsonify
import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
import os

app = Flask(__name__)

abs_cred_path = os.path.join(os.path.dirname(os.path.abspath(__file__)),
                             'firestore_sa.json')

cred = credentials.Certificate(abs_cred_path)
firebase_admin.initialize_app(cred)

db = firestore.client()


@app.route('/')
def index():
    # Testing database again
    user_ref = db.collection('Users').document('chozen1')
    user_ref.set({
        'first_name': 'Harry',
        'last_name': 'Potter',
    })

    user = user_ref.get().to_dict()

    return jsonify(user)
