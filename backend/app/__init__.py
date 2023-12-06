
# flask imports
from    flask               import Flask

# gcs/firebase imports
from    google.cloud        import storage
from    firebase_admin      import firestore, credentials, initialize_app

# python imports
import  os
import  json

# project imports
from    .blueprints         import user_bp, trip_bp, experience_bp, auth_bp
from    .services           import generate_rsa_key_pair


def create_app():
    app = Flask(__name__)

    # Initialize Firebase
    abs_cred_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'firestore_sa.json')
    cred = credentials.Certificate(abs_cred_path)
    initialize_app(cred)

    # Initialize db client and GCS storage client
    db = firestore.client()
    storage_client = storage.Client()
    app.config['db'] = db
    app.config['storage'] = storage_client

    # Open the firetore_sa.json as a json object and set the app's secret key
    app_creds = json.load(open(abs_cred_path))
    os.environ['PRIVATE_KEY'] = app_creds['private_key']
    os.environ['PRIVATE_KEY_ID'] = app_creds['private_key_id']

    # private_key_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'private_key.pem')
    # with open(private_key_path, 'r')  as private_key_file:
    #     os.environ['JWT_PRIVATE_KEY'] = private_key_file.read()

    # public_key_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'public_key.pem')
    # with open(public_key_path, 'r') as public_key_file:
    #     os.environ['JWT_PUBLIC_KEY'] = public_key_file.read()

    # if os.environ.get('JWT_PRIVATE_KEY') is None or os.environ.get('JWT_PUBLIC_KEY') is None:
    #     exit(1)
    
    private_key_pem, public_key_pem = generate_rsa_key_pair()

    os.environ['JWT_PRIVATE_KEY'] = private_key_pem
    os.environ['JWT_PUBLIC_KEY'] = public_key_pem

    # Register blueprints
    app.register_blueprint(user_bp, url_prefix='/users')
    app.register_blueprint(trip_bp, url_prefix='/trips')
    app.register_blueprint(experience_bp, url_prefix='/experiences')
    app.register_blueprint(auth_bp, url_prefix='/auth')

    return app




