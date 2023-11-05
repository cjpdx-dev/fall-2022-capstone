//
//  SettingItem.swift
//  TravelApp
//
//  Created by Chris Jacobs on 10/30/23.
//

import Foundation

struct SettingItem: Identifiable {
    let id = UUID()
    let title: String
    var isOn: Bool
}
