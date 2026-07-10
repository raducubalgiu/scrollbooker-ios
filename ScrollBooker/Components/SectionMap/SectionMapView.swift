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
            // Containerul hărții statice (FĂRĂ frame maxWidth: .infinity extern)
            ZStack {
                AsyncImage(url: URL(string: mapUrl)) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            // SOLUȚIA ENTERPRISE: Forțăm doar imaginea descărcată cu succes
                            // să ocupe exact spațiul oferit de padding-ul ecranului părinte, fără overflow
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
            // Fixăm doar înălțimea brută pe container. Lățimea va fi dictată 100% natural de padding-ul ecranului tău!
            .frame(height: 220)
            .cornerRadius(16)
            .clipped() // FOARTE IMPORTANT: Decupează orice pixel din imagine care tinde să iasă din colțurile rotunjite
            .contentShape(Rectangle())
            .onTapGesture {
                redirectToMaps()
            }
            
            if displayDirectionsButton {
                            Spacer().frame(height: 16) // SpacingM din tema ta
                            
                            MainButton(
                                title: String(localized: "navigationDirections"),
                                onClick: {
                                    redirectToMaps()
                                },
                                bgColor: .surfaceSB,       // Culorile din SurfaceBG / OnSurfaceBG
                                color: .primary            // Culoarea textului de pe hărți
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
