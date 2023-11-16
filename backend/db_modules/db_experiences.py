def create_experience(db, data):
    experiences_ref = db.collection('experiences').add(data)
    return experiences_ref

def get_experiences(db):
    experiences_ref = db.collection('experiences')
    docs = experiences_ref.stream()
    experiences = [{**doc.to_dict(), "id": doc.id} for doc in docs]  # returns a list of dictionaries
    return experiences

def get_experience_by_id(db, id):
    experience_ref = db.collection('experiences').document(id)
    experience = experience_ref.get()
    if experience.exists:
        return {**experience.to_dict(), "id": experience.id}

def experience_exists(db, id):
    experience_ref = db.collection('experiences').document(id)
    experience = experience_ref.get()
    if experience.exists():
        return True
    else:
        return False

def update_experience(db, id, data):
    experience_ref = db.collection('experiences').document(id)
    experience = experience_ref.get()
    if experience.exists:
        experience_ref.update(data)
        return {**experience.to_dict(), "id": experience.id}
    else:
        return None

def delete_experience(db, id):
    experience_ref = db.collection('experiences').document(id)
    experience = experience_ref.get()
    if experience.exists:
        experience_ref.delete()
        return True
    else:
        return False