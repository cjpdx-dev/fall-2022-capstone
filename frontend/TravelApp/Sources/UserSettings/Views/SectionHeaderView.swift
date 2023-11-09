//
//  SectionHeaderView.swift
//  TravelApp
//
//  Created by Chris Jacobs on 10/30/23.
//

import SwiftUI

struct SectionHeaderView: View {
    var title: String

    var body: some View {
        Text(title)
            .font(.headline)
            .padding(.vertical)
    }
}

