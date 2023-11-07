

def get_users(db):
    users_ref = db.collection('users')
    docs = users_ref.stream()
    users = [{**doc.to_dict(), "id": doc.id} for doc in docs] # returns a list of dictionaries
    return users


def get_user_by_id(db, id):
    user_ref = db.collection('users').document(id)
    user = user_ref.get()
    if user.exists:
        return {**user.to_dict(), "id": user.id}
    else:
        return None
    

def get_user_profile_by_id(db, id):
    user_ref = db.collection('users').document(id)
    user = user_ref.get()
    if user.exists:
        return {**user.to_dict(), "id": user.id}
    else:
        return None
    

def update_user(db, id, user_data):
    user_ref = db.collection('users').document(id)
    user = user_ref.get()
    if user.exists:
        user_ref.update(user_data)
        return {**user.to_dict(), "id": user.id}
    else:
        return None


def delete_user(db, id):
    user_ref = db.collection('users').document(id)
    user = user_ref.get()
    if user.exists:
        user_ref.delete()
        return True
    else:
        return False
    
    