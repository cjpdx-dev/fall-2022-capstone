import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
import os

# Initialize Firebase
abs_cred_path = os.path.join(os.path.dirname(os.path.abspath(__file__)),
                             'firestore_sa.json')

cred = credentials.Certificate(abs_cred_path)
firebase_admin.initialize_app(cred)

# Initialize Firestore database
db = firestore.client()
