//
//  BusinessAboutTabView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 02.09.2025.
//

import SwiftUI

struct BusinessAboutTabView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("about")
                .font(.title2.weight(.heavy))
                .padding(.bottom)
            
            Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.")
            
            Text("schedule")
                .font(.title2.weight(.heavy))
                .padding(.vertical)
            
            Text("Lu–Vi 09:00–20:00\nSâ 10:00–18:00\nDu închis")
            
            Text("address")
                .font(.title2.weight(.heavy))
                .padding(.vertical)
            
            Text("Calea Victoriei 10, București")
            
            
            MapView(businessCoordinates: BusinessCoordinates(lat: 45.2345, lng: 25.2345))
            
            Spacer(minLength: 12)
        }
        .padding(16)
        .background(Color(.systemBackground))
    }
}

#Preview("Light") {
    BusinessAboutTabView()
}

#Preview("Dark") {
    BusinessAboutTabView()
        .preferredColorScheme(.dark)
}
