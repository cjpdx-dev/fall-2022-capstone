//
//  ExperienceScreen.swift
//  TravelApp
//
//  Created by Bryshon Sweeney on 10/25/23.
//

import SwiftUI

struct ExperienceScreen: View {
    var experiences: [Experience]
    @EnvironmentObject var userViewModel:  UserViewModel
    var body: some View {
        ExperienceListView(experiences: experiences)
            .environmentObject(userViewModel)
    }
}

#Preview {
    ExperienceScreen(experiences: experiences)
}
