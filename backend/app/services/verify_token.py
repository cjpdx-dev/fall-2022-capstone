
import jwt
from flask import current_app
import os

def verify_token(auth_header):

    print("Called verify_token")

    if auth_header and auth_header.startswith('Bearer '):
        auth_token = auth_header.split(' ')[1]
    else:
        raise ValueError("Missing token or invalid token header")
    
    try:
        public_key = os.environ.get('JWT_PUBLIC_KEY')
        payload = jwt.decode(auth_token, public_key, algorithms=["RS256"])
        return payload['sub']
    
    except jwt.ExpiredSignatureError:
        raise jwt.ExpiredSignatureError("Token expired. Please log in again.")
    
    except jwt.InvalidTokenError:
        raise jwt.InvalidTokenError("InvalidTokenError")
    
    except ValueError:
        raise ValueError("Could not decode token (value error)")
    
    except KeyError:
        raise KeyError("Could not decode token (key error)")
    
    except Exception as e:
        print("FATAL: Uncaught Exception in services.verify_token(auth_header) \n \n " + str(e) + "\n Exiting.")
        exit(1)

    