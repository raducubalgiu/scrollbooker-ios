//
//  SectionMapView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 10.07.2026.
//

import SwiftUI

struct SectionMap: View {
    var mapUrl: String
    var coordinates: BusinessCoordinates
    var fullName: String
    var displayDirectionsButton: Bool = true
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack {
                AsyncImage(url: URL(string: mapUrl)) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                            
                    case .failure:
                        Color.surfaceSB
                            .overlay(
                                Image(systemName: "map")
                                    .foregroundColor(.secondary)
                            )
                    case .empty:
                        ProgressView()
                    @unknown default:
                        EmptyView()
                    }
                }
            }
            .frame(height: 220)
            .cornerRadius(16)
            .clipped()
            .contentShape(Rectangle())
            .onTapGesture {
                redirectToMaps()
            }
            
            if displayDirectionsButton {
                MainButton(
                    title: String(localized: "navigationDirections"),
                    bgColor: .surfaceSB,
                    color: .primary,
                    onClick: { redirectToMaps()},
                )
            }
        }
    }
    
    private func redirectToMaps() {
        let latitude = coordinates.lat
        let longitude = coordinates.lng

        let allowedCharacters = CharacterSet.urlQueryAllowed
        let encodedName = fullName.addingPercentEncoding(withAllowedCharacters: allowedCharacters) ?? ""

        let urlString = "http://apple.com\(latitude),\(longitude)&q=\(encodedName)"
        
        if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
