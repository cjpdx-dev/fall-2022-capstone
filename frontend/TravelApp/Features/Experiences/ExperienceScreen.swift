//
//  ExperienceScreen.swift
//  TravelApp
//
//  Created by Bryshon Sweeney on 10/25/23.
//

import SwiftUI

struct ExperienceScreen: View {
    var experiences: [Experience]
    var body: some View {
        ExperienceListView(experiences: experiences)
    }
}

#Preview {
    ExperienceScreen(experiences: experiences)
}
