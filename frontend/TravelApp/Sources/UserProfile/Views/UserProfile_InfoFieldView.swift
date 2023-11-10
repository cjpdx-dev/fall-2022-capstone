//
//  PrivateUserInfoFieldView.swift
//  TravelApp
//
//  Created by Chris Jacobs on 10/30/23.
//

import SwiftUI

struct UserProfile_InfoFieldView: View {
    var title: String
    var placeholder: String
    var userValue: String?
    @Binding var updatedValue: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            TextField(placeholder, text: $updatedValue)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }
}
