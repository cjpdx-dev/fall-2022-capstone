//
//  SettingsScreen.swift
//  TravelApp
//
//  Created by Chris Jacobs on 10/30/23.
//

import SwiftUI

struct SettingsScreen: View {
    @State private var notifications = [
        SettingItem(title: "Push Notifications", isOn: true),
        SettingItem(title: "Email Notifications", isOn: false)
    ]

    @State private var appearance = [
        SettingItem(title: "Dark Mode", isOn: false),
        SettingItem(title: "High Contrast", isOn: false)
    ]

    @State private var privacy = [
        SettingItem(title: "Public Profile", isOn: true),
        SettingItem(title: "Share Location", isOn: true)
    ]

    var body: some View {
        NavigationView {
            List {
                Section(header: SectionHeaderView(title: "Notifications")) {
                    ForEach(notifications.indices) { index in
                        ToggleSettingView(setting: $notifications[index])
                    }
                }

                Section(header: SectionHeaderView(title: "Appearance")) {
                    ForEach(appearance.indices) { index in
                        ToggleSettingView(setting: $appearance[index])
                    }
                }

                Section(header: SectionHeaderView(title: "Privacy")) {
                    ForEach(privacy.indices) { index in
                        ToggleSettingView(setting: $privacy[index])
                    }
                }

                ButtonSettingView(title: "Delete Account")
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("User Settings", displayMode: .inline)
        }
    }
}

struct SettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        SettingsScreen()
    }
}

