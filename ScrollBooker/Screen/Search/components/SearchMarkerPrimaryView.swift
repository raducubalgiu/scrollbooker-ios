//
//  SearchMarkerPrimaryView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 17.07.2026.
//

import SwiftUI

struct SearchMarkerPrimary: View {
    let imageUrl: String?
    let domainColor: Color
    var baseAvatarSize: CGFloat = 50
    
    // Constrângeri de dimensiuni geometrice calculate exact ca în Android-ul tău
    private let ringWidth: CGFloat = 3
    private let whiteRingWidth: CGFloat = 2
    
    var body: some View {
        let innerSize = baseAvatarSize - ringWidth - whiteRingWidth - 4
        let pointerWidth = baseAvatarSize * 0.42
        let pointerHeight: CGFloat = 8
        let pointerOffsetY: CGFloat = -2
        
        VStack(spacing: 0) {
            // CONTAINERUL AVATARULUI ROTUND
            ZStack {
                // Stratul A: Cercul exterior animat cu Sweep/Angular Gradient
                Circle()
                    .stroke(
                        AngularGradient(
                            colors: [
                                domainColor.opacity(0.9),
                                domainColor.opacity(0.6),
                                domainColor.opacity(0.9)
                            ],
                            center: .center
                        ),
                        lineWidth: ringWidth
                    )
                
                // Stratul B: Inelul alb interior
                Circle()
                    .stroke(Color.white, lineWidth: whiteRingWidth)
                    .padding(ringWidth)
                
                // Stratul C: Imaginea Avatar decupată rotund
                Group {
                    if let urlString = imageUrl, let url = URL(string: urlString) {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            defaultUserIcon
                        }
                    } else {
                        defaultUserIcon
                    }
                }
                .frame(width: innerSize, height: innerSize)
                .clipShape(Circle())
            }
            .frame(width: baseAvatarSize, height: baseAvatarSize)
            
            // INDICATORUL TRIUNGHIULAR DE SUB CERC (Echivalentul Canvas-ului de Path din Kotlin)
            MarkerPointerShape()
                .fill(domainColor)
                .frame(width: pointerWidth, height: pointerHeight)
                .offset(y: pointerOffsetY)
        }
        // Padding superior identic cu cel din Android (padding(top = 10.dp))
        .padding(.top, 10)
    }
    
    // Iconița implicită de tip user (Placeholder & Error state din Android)
    @ViewBuilder
    private var defaultUserIcon: some View {
        ZStack {
            Color(.systemGray5)
            Image(systemName: "person.fill")
                .font(.system(size: baseAvatarSize * 0.4, weight: .semibold))
                .foregroundColor(.gray)
        }
    }
}

// Structură custom Shape pentru a desena triunghiul-indicator geometric exact ca în Canvas-ul din Android
struct MarkerPointerShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: w, y: 0))
        path.addLine(to: CGPoint(x: w / 2, y: h))
        path.closeSubpath()
        
        return path
    }
}
