


def find_user_by_email(db, user_email):
    print("1")
    user_ref = db.collection('users').where('userEmail', '==', user_email).get()
    if len(user_ref) == 0:
        print("2")
        return 0
    else:
        print("3")
        return user_ref[0]

def register_user(db, required_fields):

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

def get_user_by_id(db, uid):
    user_doc = db.collection('users').document(uid).get()
    if user_doc is None:
        return None
    else:
        user = user_doc.to_dict()
        user.pop('passwordHash', None)
        if user['homeState'] is None:
            user.pop('homeState', None)
        if user['homeCity'] is None:
            user.pop('homeCity', None)
        if user['userBio'] is None:
            user.pop('userBio', None)
        if user['profileImageURL'] is None:
            user.pop('profileImageURL', None)
        
        return user
