//
//  TripScreen.swift
//  TravelApp
//
//  Created by Rachel Pratt on 11/2/23.
//

import SwiftUI

struct TripScreen: View {
    
    // This is the user session
    @EnvironmentObject var userViewModel:  UserViewModel
    
    var body: some View {
        NavigationView{
            TripListView()
                .environmentObject(userViewModel)
        }
    }
}

//#Preview {
//    TripScreen()
//        .environmentObject(UserViewModel())
//}
