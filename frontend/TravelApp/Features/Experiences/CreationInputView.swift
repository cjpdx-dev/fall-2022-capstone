//
//  CreationInputView.swift
//  TravelApp
//
//  Created by Bryshon Sweeney on 10/30/23.
//

import SwiftUI

struct CreationInputView: View {
    @Binding var text: String
     var placeholder: String
     var title: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .foregroundStyle(Color(.darkGray))
                .fontWeight(.semibold)
                .font(.subheadline)
               
            
            TextField(placeholder, text: $text)
                .font(.system(size: 14))
            
        }
    }
}

#Preview {
    CreationInputView(text: .constant("My Experience"), placeholder: "Enter title for experience", title: "My Experience")
}
