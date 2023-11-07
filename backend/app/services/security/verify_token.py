from flask import request
from firebase_admin import auth


def verify_token(auth_header):
    if not auth_header:
        return None
    
    parts = auth_header.split()

    if parts[0].lower() != 'bearer':
        raise ValueError("Invalid token header. Must start with Bearer")
    
    elif len(parts) == 1:
        raise ValueError("Token not found")
    
    elif len(parts) > 2:
        raise ValueError("Auth header must be Bearer <token>")
    
    token = parts[1]

    try:
        decoded_token = auth.verify_id_token(token, check_revoked=True)
        return decoded_token['uid']
    
    except auth.RevokedIdTokenError:
        raise auth.RevokedIdTokenError("Revoked Token")
    
    except auth.InvalidIdTokenError:
        raise auth.InvalidIdTokenError("Invalid Token")
    
