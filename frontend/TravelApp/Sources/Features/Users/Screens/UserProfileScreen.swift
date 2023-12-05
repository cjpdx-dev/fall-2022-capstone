import SwiftUI


struct UserProfileScreen: View {
    
    @EnvironmentObject var userViewModel: UserViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var profileIsPublic = false
    @State private var locationIsPublic = false
    @State private var experiencesArePublic = false
    @State private var tripsArePublic = false
    
    @State private var editableHomeState = ""
    @State private var editableHomeCity = ""
    @State private var editableBio = ""
    @State private var editableDisplayName = ""
    
    @State private var fieldsAreEditable = false
    @State private var fieldsHaveBeenEdited = false
    
    private var userData: UserModel? {
        userViewModel.getSessionData()?.userData
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                if let userData = userData {
                    userInfoHeader(userData: userData)
                    toggleFields(userData: userData)
                    signOutButton
                    deleteAccountButton
                }
            }
            .padding()
        }
        .navigationTitle("User Profile")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    @ViewBuilder
    private func userInfoHeader(userData: UserModel) -> some View {
        HStack {
            Image(systemName: "person.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 48, height: 48)
                .foregroundColor(.gray)
            
            VStack(alignment: .leading, spacing: 2) {
                Group {
                    if fieldsAreEditable {
                        TextField("Display Name", text: $editableDisplayName)
                            .onChange(of: editableHomeCity) {
                                if !fieldsHaveBeenEdited {
                                    fieldsHaveBeenEdited.toggle()
                                }
                            }
                        
                    } else {
                        Text(editableDisplayName.isEmpty ? userData.displayName : editableDisplayName)
                    }
                }
                .font(.headline)
                
                Group {
                    if fieldsAreEditable {
                        HStack {
                            TextField("City", text: $editableHomeCity)
                                .onChange(of: editableHomeCity) {
                                    
                                    if !fieldsHaveBeenEdited {
                                        fieldsHaveBeenEdited.toggle()
                                    }
                                }
                            
                            TextField("State", text: $editableHomeState)
                                .onChange(of: editableHomeState) {
                                    if !fieldsHaveBeenEdited {
                                        fieldsHaveBeenEdited.toggle()
                                    }
                                }
                        }
                        
                    } else {
                        Text(editableHomeCity.isEmpty ? (userData.homeCity ?? "Your Location") : editableHomeCity)
                    }
                }
                .font(.subheadline)
                
                Group {
                    if fieldsAreEditable {
                        TextField("Bio", text: $editableBio)
                            .onChange(of: editableBio) {
                                if !fieldsHaveBeenEdited {
                                    fieldsHaveBeenEdited.toggle()
                                }
                            }
                    } else {
                        Text(editableBio.isEmpty ? (userData.userBio ?? "No bio provided") : editableBio)
                    }
                }
                .font(.subheadline)
            }
            
            Spacer()
            
            Button(action: {
                withAnimation {
                    fieldsAreEditable.toggle()
                    if !fieldsAreEditable && fieldsHaveBeenEdited {
                        
                        userViewModel.updateUserProfile(
                            displayName: editableDisplayName,
                            bio: editableBio,
                            homeCity: editableHomeCity,
                            homeState: editableHomeState,
                            profileVisibility: profileIsPublic,
                            expVisibility: experiencesArePublic,
                            tripsVisibility: tripsArePublic,
                            locationVisibility: locationIsPublic
                            
                        ) { success in
                            if success {
                                fieldsHaveBeenEdited.toggle()
                            }
                            else {
                                print("Update Failed")
                            }
                        }
                    }
                }
            }) {
                Image(systemName: fieldsAreEditable ? "checkmark.square" : "pencil")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 28, height: 28)
            }
            .padding(.horizontal)
        }
    }
    
    @ViewBuilder
    private func toggleFields(userData: UserModel) -> some View {
        Group {
            toggleField(title: "Profile Is Public", isOn: $profileIsPublic, initialValue: userData.profileIsPublic)
                .onChange(of: profileIsPublic) {newValue in
                    if !fieldsHaveBeenEdited { fieldsHaveBeenEdited.toggle() }
                }
            toggleField(title: "Experiences Are Public", isOn: $experiencesArePublic, initialValue: userData.experiencesArePublic)
                .onChange(of: experiencesArePublic) {newValue in
                    if !fieldsHaveBeenEdited { fieldsHaveBeenEdited.toggle() }
                }
            toggleField(title: "Trips Are Public", isOn: $tripsArePublic, initialValue: userData.tripsArePublic)
                .onChange(of: tripsArePublic) {newValue in
                    if !fieldsHaveBeenEdited { fieldsHaveBeenEdited.toggle() }
                }
            toggleField(title: "Location Is Public", isOn: $locationIsPublic, initialValue: userData.locationIsPublic)
                .onChange(of: locationIsPublic) {newValue in
                    if !fieldsHaveBeenEdited { fieldsHaveBeenEdited.toggle() }
                }
        }
        .padding(.horizontal, 10)
        .disabled(!fieldsAreEditable)
    }
    
    private func toggleField(title: String, isOn: Binding<Bool>, initialValue: Bool) -> some View {
        Toggle(isOn: isOn) {
            Text(title)
                .font(.body)
        }
        .padding(.vertical, 8)
        .onAppear {
            isOn.wrappedValue = initialValue
        }
    }
    
    private var signOutButton: some View {
        Button(action: {
            userViewModel.clearSession()
            dismiss()
        }) {
            Text("Sign Out")
                .bold()
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
        }
        .padding(.top, 10)
    }
    
    private var deleteAccountButton: some View {
        Button(action: {
            userViewModel.clearSession()
            dismiss()
        }) {
            Text("Delete Account")
                .bold()
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(8)
        }
        .padding(.top, 10)
    }
}

struct UserProfileScreen_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileScreen().environmentObject(UserViewModel())
    }
}
