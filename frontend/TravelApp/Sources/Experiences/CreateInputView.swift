//
//  CreationInputView.swift
//  TravelApp
//
//  Created by Bryshon Sweeney on 10/30/23.
//

import SwiftUI

struct CreateInputView: View {
    @Binding var text: String
    var placeholder: String
    var label: String
    var isLongText = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 7) {
            Text(label)
                .foregroundStyle(Color(.black))
                .fontWeight(.semibold)
                .font(.subheadline)
               
            if (isLongText) {
                TextEditor(text: $text)
                    .font(.system(size: 14))
                    .frame(maxHeight: 100)
                    .border(Color(.darkGray))
            } else {
                TextField(placeholder, text: $text)
                    .padding(.horizontal, 4)
                    .padding(.vertical, 7)
                    .font(.system(size: 14))
                    .border(Color(.darkGray))
            }
        }
    }
}

#Preview {
    CreateInputView(text: .constant("My Experience"), placeholder: "Enter title for experience", label: "My Experience")
}
