
import jwt
from flask import current_app

def verify_token(auth_header):

    print("Called verify_token")

    if not auth_header:
        raise ValueError("Authorization header is expected")
    
    try:
        token = auth_header.headers.get('Authorization')
        payload = jwt.decode(token, current_app.config['SECRET_KEY'], algorithms=["RS256"])
        return payload['sub']
    
    except jwt.ExpiredSignatureError:
        raise jwt.ExpiredSignatureError("Token expired. Please log in again.")
    
    except jwt.InvalidTokenError:
        raise jwt.InvalidTokenError("Invalid token. Could not decode token.")
    
    except ValueError:
        raise ValueError("Invalid token. Could not decode token.")
    
    except KeyError:
        raise KeyError("Invalid token. Could not decode token.")
    
    except Exception as e:
        print("FATAL: Uncaught Exception in services.verify_token(auth_header) \n \n " + str(e) + "\n Exiting.")
        exit(1)

    