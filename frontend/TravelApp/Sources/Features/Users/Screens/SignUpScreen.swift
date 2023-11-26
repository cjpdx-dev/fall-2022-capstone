//
//  SignInScreen.swift
//  TravelApp
//
//  Created by Bryshon Sweeney on 10/26/23.
//

import SwiftUI

struct SignUpScreen: View {
    @Environment(\.dismiss) var dismiss
    @State private var isUserRegistered = false
    
    @ObservedObject var userViewModel = UserViewModel()

    @State      private var userEmail:                  String = ""
    @State      private var displayName:                String = ""
    @State      private var birthDate:                  String = ""
    @State      private var userPassword:               String = ""
    @State      private var confirmPassword:            String = ""
    
    @State      private var emailIsValid:               Bool = true
    @State      private var displayNameIsValid:         Bool = true
    @State      private var birthDateIsValid:           Bool = true
    @State      private var userIsValidAge:             Bool = true
    @State      private var passwordIsValid:            Bool = true
    @State      private var passwordsMatch:             Bool = true
    
    @FocusState private var emailIsFocused:             Bool
    @FocusState private var displayNameIsFocused:       Bool
    @FocusState private var birthDateIsFocused:         Bool
    @FocusState private var passwordIsFocused:          Bool
    @FocusState private var confirmPasswordIsFocused:   Bool
    
    
    var body: some View {
        VStack {
            Image(systemName: "map.circle")
                .resizable()
                .frame(width: 150, height: 150)
        }
        .padding(.vertical)
        
        VStack(spacing: 24) {
            
            // Email Address
            VStack(alignment: .leading, spacing: 12) {
                Text("Email Address")
                    .foregroundStyle(Color(.darkGray))
                    .fontWeight(.semibold)
                    .font(.subheadline)

                TextField("Email Address", text: $userEmail)
                    .keyboardType(.emailAddress)
                    .font(.system(size: 14))
                    .focused($emailIsFocused)
                    .onChange(of: emailIsFocused) { isFocused in
                        if !isFocused {
                            validateEmail()
                        }
                    }
                Group {
                    if !emailIsValid {
                        Text("Invalid Email Address")
                            .foregroundColor(.red)
                            .font(.system(size: 10))
                    }
                }
            }
            Divider()
            
            // Display Name
            VStack(alignment: .leading, spacing: 12) {
                Text("Display Name")
                    .foregroundStyle(Color(.darkGray))
                    .fontWeight(.semibold)
                    .font(.subheadline)

                TextField("Display Name", text: $displayName)
                    .keyboardType(.emailAddress)
                    .font(.system(size: 14))
                    .focused($displayNameIsFocused)
                    .onChange(of: displayNameIsFocused) { isFocused in
                        if !isFocused {
                            validateDisplayName()
                        }
                    }
                
                Group {
                    if !displayNameIsValid {
                        Text("Invalid Display Name: Maximum of eight characters. No symbols allowed.")
                            .foregroundColor(.red)
                            .font(.system(size:10))
                    }
                }
            }
            Divider()
            
            // Birth Month/Year (MM/YYYY)
            VStack(alignment: .leading, spacing: 12) {
                Text("Birth Date")
                    .foregroundStyle(Color(.darkGray))
                    .fontWeight(.semibold)
                    .font(.subheadline)
                
                TextField("MM/YYYY", text: $birthDate)
                    .keyboardType(.numberPad)
                    .font(.system(size:14))
                    .focused($birthDateIsFocused)
                    .onReceive(birthDate.publisher.collect()) {
                        self.birthDate = String($0.prefix(7))
                    }
                    .onChange(of: birthDateIsFocused) { isFocused in
                        if !isFocused {
                            validateBirthDate()
                        }
                    }
                
                Group {
                    if !birthDateIsValid {
                        Text("Invalid Date Format")
                            .foregroundColor(.red)
                            .font(.system(size:10))
                    }
                    if !userIsValidAge {
                        Text("Must Be 18 Or Older")
                            .foregroundColor(.red)
                            .font(.system(size:10))
                    }
                }
            }
            Divider()
            
            // Password
            VStack(alignment: .leading, spacing: 12) {
                Text("Password")
                    .foregroundStyle(Color(.darkGray))
                    .fontWeight(.semibold)
                    .font(.subheadline)

                SecureField("Password", text: $userPassword)
                    .focused($passwordIsFocused)
                    .font(.system(size:14))
                    .onChange(of: passwordIsFocused) { isFocused in
                        if !isFocused {
                            validatePassword()
                        }
                    }
                
                Group {
                    if !passwordIsValid {
                        Text("""
                             Password must be at least 13 characters and must include:\n
                             - One upper case letter and one number
                             - One special character [!@#&*]
                             """)
                            .foregroundColor(.red)
                            .font(.system(size:10))
                    }
                }
            }
            
            // Confirm Password
            VStack(alignment: .leading, spacing: 12) {
                Text("Confirm Password")
                    .foregroundStyle(Color(.darkGray))
                    .fontWeight(.semibold)
                    .font(.subheadline)

                SecureField("Confirm Password", text: $confirmPassword)
                    .font(.system(size:14))
                    .focused($confirmPasswordIsFocused)
                    .onChange(of: confirmPasswordIsFocused) { isFocused in
                        if !isFocused {
                            validateMatchingPassword()
                        }
                    }
                
                Group {
                    if !passwordsMatch {
                        Text("Passwords Do Not Match")
                            .foregroundColor(.red)
                            .font(.system(size:10))
                    }
                }
            }
            Divider()
            
            // Create Account Button
            Button {
                handleCreateAccount()
                UserProfileScreen()
            } label: {
                HStack {
                    Text("Create Account")
                        .fontWeight(.semibold)
                    Image(systemName: "arrow.right")
                }
                .foregroundColor(.white)
                .frame(width: UIScreen.main.bounds.width - 50, height: 48)
            }
            .background(Color(.blue))
            .cornerRadius(10)
        }
        .padding(.horizontal)
        .padding(.top, 12)
        
        Spacer()
        
        Button {
            dismiss()
        } label: {
            HStack(spacing: 3) {
                Text("Already Have An Account?")
                Text("Sign In")
                    .fontWeight(.bold)
            }
        }
    }
    
    func handleCreateAccount() {
        if validateAllFields() {
            DispatchQueue.main.async {
                userViewModel.createUser(userEmail:     userEmail,
                                         displayName:   displayName,
                                         birthDate:     birthDate,
                                         userPassword:  userPassword)
                
            }
        }
        
    }
    
    func validateAllFields() -> Bool {
        
        if !emailIsValid || userEmail == "" {
            return false
        }
        else if !displayNameIsValid || displayName == "" {
            return false
        }
        else if !birthDateIsValid || birthDate == "" {
            return false
        }
        else if !passwordIsValid || userPassword == "" {
            return false
        }
        else if !passwordsMatch || confirmPassword == "" {
            return false
        }
        else {
            return true
        }
    }
        
    // Account Data Validation
    func validateEmail() {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        emailIsValid = NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: userEmail)
    }

    func validateDisplayName() {
        let displayNameRegex = "^[\\p{L}0-9]{1,8}$"  // Allows letters and numbers, up to 8 characters
        displayNameIsValid = NSPredicate(format: "SELF MATCHES %@", displayNameRegex).evaluate(with: displayName)
    }
        
    func validateBirthDate() {
        if !isValidDateFormat(birthDate) {
            birthDateIsValid = false
        } else { birthDateIsValid = true }
        
        if !isValidAge(birthDate){
            userIsValidAge = false
        } else { userIsValidAge = true }
    }
        
    func isValidDateFormat(_ dateString: String) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/yyyy"
        return dateFormatter.date(from: dateString) != nil
    }

    func isValidAge(_ dateString: String) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/yyyy"
        guard let birthDate = dateFormatter.date(from: dateString) else { return false }

        let calendar = Calendar.current
        let now = Date()
        let ageComponents = calendar.dateComponents([.year], from: birthDate, to: now)
        let age = ageComponents.year ?? 0
        return age >= 18
    }
        
    func validatePassword() {
        let passwordRegex = "^(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#$&*]).{13,}$"
        passwordIsValid = NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: userPassword)
    }
        
    func validateMatchingPassword() {
        if userPassword == confirmPassword {
            passwordsMatch = true
        } else {
            passwordsMatch = false
        }
    }
}



#Preview {
    SignUpScreen()
}
