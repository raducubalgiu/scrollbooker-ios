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
            
            HStack {
                HStack {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 10, height: 10)
                    Text("Luni")
                        .font(.headline)
                }
                
                Spacer()
                
                Text("09:00 - 18:00")
                    .font(.headline)
            }
            .frame(maxWidth: .infinity)
            
            HStack {
                HStack {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 10, height: 10)
                    Text("Marti")
                        .font(.headline.weight(.heavy))
                }
                
                Spacer()
                
                Text("09:00 - 18:00")
                    .font(.headline.weight(.heavy))
            }
            .frame(maxWidth: .infinity)
            
            HStack {
                HStack {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 10, height: 10)
                    Text("Miercuri")
                        .font(.headline)
                }
                
                Spacer()
                
                Text("09:00 - 18:00")
                    .font(.headline)
            }
            .frame(maxWidth: .infinity)
            
            HStack {
                HStack {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 10, height: 10)
                    Text("Joi")
                        .font(.headline)
                }
                
                Spacer()
                
                Text("09:00 - 18:00")
                    .font(.headline)
            }
            .frame(maxWidth: .infinity)
            
            HStack {
                HStack {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 10, height: 10)
                    Text("Vineri")
                        .font(.headline)
                }
                
                Spacer()
                
                Text("09:00 - 18:00")
                    .font(.headline)
            }
            .frame(maxWidth: .infinity)
            
            HStack {
                HStack {
                    Circle()
                        .fill(Color.gray)
                        .frame(width: 10, height: 10)
                    Text("Sambata")
                        .font(.headline)
                }
                
                Spacer()
                
                Text("Inchis")
                    .font(.headline)
            }
            .frame(maxWidth: .infinity)
            
            HStack {
                HStack {
                    Circle()
                        .fill(Color.gray)
                        .frame(width: 10, height: 10)
                    Text("Duminica")
                        .font(.headline)
                }
                
                Spacer()
                
                Text("Inchis")
                    .font(.headline)
            }
            .frame(maxWidth: .infinity)
            
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
