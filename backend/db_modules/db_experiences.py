def create_experience(db, data):
    experiences_ref = db.collection('experiences').add(data)
    print(experiences_ref)
    
    pass