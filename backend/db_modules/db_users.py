


def get_user_id_by_email(db, user_email):
    print("Called db_users.get_user_id_by_email")
    user_ref = db.collection('users').where('userEmail', '==', user_email).get()
    if len(user_ref) == 0:
        return None
    else:
        return user_ref[0].to_dict()['id']

def get_user_by_email(db, user_email, include_password_hash=False):
    print("Called db_users.find_user_by_email")
    user_ref = db.collection('users').where('userEmail', '==', user_email).get()
    if len(user_ref) == 0:
        return None
    else:
        user = user_ref[0].to_dict()
        if not include_password_hash:
            user.pop('passwordHash', None)
        return user

def register_user(db, required_fields):
    print("Called db_users.register_user")
    user_ref = db.collection('users').document()

    new_user = {
        'id':                   user_ref.id,
        'userEmail':            required_fields['userEmail'],
        'passwordHash':         required_fields['userPassword'],

        'profileIsPublic':      True,
        'displayName':          required_fields['displayName'],
        'birthDate':            required_fields['birthDate'],
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

    user_ref.set(new_user)
    created_user = user_ref.get()
    if not created_user.exists:
        return None
    else:
        # return the created user's id
        return created_user.to_dict()['id']

def get_user_by_id(db, uid, include_private=False):
    print("Called db_users.get_user_by_id")
    user_doc = db.collection('users').document(uid).get()
    if user_doc is None:
        return None
    else:
        user = user_doc.to_dict()
        if not include_private:
            user.pop('passwordHash', None)
            
        return user
