//
//  InputView.swift
//  TravelApp
//
//  Created by Bryshon Sweeney on 10/26/23.
//

import SwiftUI

struct LoginInputView: View {
    @Binding var text: String
    let title: String
    let placeholder: String
    var isSecureField = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .foregroundStyle(Color(.darkGray))
                .fontWeight(.semibold)
                .font(.subheadline)
                
            if isSecureField {
                SecureField(placeholder, text: $text)
                    .font(.system(size: 14))
            } else {
                TextField(placeholder, text: $text)
                    .font(.system(size: 14))
            }
            Divider()
        }
    }
}

#Preview {
    LoginInputView(text: .constant(""), title: "Email Address", placeholder: "name@example.com")
}
