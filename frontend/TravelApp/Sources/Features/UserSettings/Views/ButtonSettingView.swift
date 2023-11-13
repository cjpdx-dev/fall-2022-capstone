//
//  ButtonSettingView.swift
//  TravelApp
//
//  Created by Chris Jacobs on 10/30/23.
//

import SwiftUI

struct ButtonSettingView: View {
    var title: String

    var body: some View {
        Button(action: {}) {
            Text(title)
                .foregroundColor(Color.red)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
    }
}

