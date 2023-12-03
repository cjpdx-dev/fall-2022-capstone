

def register_user(db, required_fields):
    
    # Create new user document, init user fields, then store the user
    user_ref = db.collection('users').document()
    new_user = {
        'id':                   user_ref.id,    
        'creds_id':             None,
        'userEmail':            required_fields['userEmail'],
        'profileIsPublic':      True,
        'displayName':          required_fields['displayName'],
        'userBio':              None,
        'profileImageURL':      None,

        'locationIsPublic':     False,
        'homeState':            None,
        'homeCity':             None,

        'experiencesArePublic': True,
        'experienceIDs':        [],

        'tripsArePublic':       True,
        'tripIDs':              []
    }

    creds_id = store_user_creds(db, required_fields['hash'], required_fields['birthDate']) 
    if creds_id is None:
        return None
    else:
        new_user['creds_id'] = creds_id
        user_ref.set(new_user)

    # Confirm user creation. If failed: delete the credentials that were created
    created_user = user_ref.get()
    if not created_user.exists:
        delete_user_creds(db, creds_id)                                 
        return None
    else:
        created_user = created_user.to_dict()
        created_user.pop('creds_id', None)
        return created_user
           

def store_user_creds(db, hash, user_birthdate):
    credentials_ref = db.collection('credentials').document()
    
    cred_data = {'hash': hash, 'birthdate': user_birthdate}
    credentials_ref.set(cred_data)

    created_creds = credentials_ref.get()
    if not created_creds.exists:
        return None
    else:
        print("Credentials ID: " + str(credentials_ref.id))
        return credentials_ref.id
    

def get_user_creds(db, creds_id):
    creds_ref = db.collection('credentials').document(creds_id).get()
    if not creds_ref.exists:
        return None
    else:
        user_creds = creds_ref.to_dict()
        return user_creds


def delete_user_creds(db, creds_id):
    creds_ref = db.collection('credentials').document(creds_id)
    creds_ref.delete()
    
    deleted_creds = creds_ref.get()
    if deleted_creds.exists:
        return None
    else:
        return True
    

def get_private_user_by_email(db, user_email, include_creds_id=False):
    user_ref = db.collection('users').where('userEmail', '==', user_email).get()
    if len(user_ref) == 0:
        return None
    else:
        found_user = user_ref[0].to_dict()

        if not include_creds_id:
            found_user.pop('creds_id', None)

        return found_user
    

def get_private_user_by_uid(db, uid, include_creds_id=False):
    user_ref = db.collection('users').document(uid).get()
    if user_ref is None:
        return None
    else:
        user = user_ref.to_dict()
        if not include_creds_id:
            user.pop('creds_id', None)
        return user


def get_public_user_by_uid(db, uid):
    user_ref = db.collection('users').document(uid).get()
    if user_ref is None:
        return None
    else:
        user = user_ref.to_dict()

        if user['profileIsPublic'] == False:
            return None
        
        if user['locationsArePublic'] == False:
            user.pop('homeState', None)
            user.pop('homeCity', None)
            
        if user['experiencesArePublic'] == False:
            user.pop('experienceIDs', None)
        
        if user['tripsArePublic'] == False:
            user.pop('tripIDs', None)

        return user