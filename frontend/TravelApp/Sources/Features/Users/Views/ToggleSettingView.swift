//
//  ToggleSettingView.swift
//  TravelApp
//
//  Created by Chris Jacobs on 10/30/23.
//

import SwiftUI

struct ToggleSettingView: View {
    @Binding var setting: SettingItem

    var body: some View {
        HStack {
            Text(setting.title)
            Spacer()
            Toggle("", isOn: $setting.isOn).toggleStyle(SwitchToggleStyle())
        }
        .padding()
    }
}
