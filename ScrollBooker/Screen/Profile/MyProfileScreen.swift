//
//  MyProfileScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.08.2025.
//

import SwiftUI

struct MyProfileScreen: View {
    @State private var showBottomSheet = false
    @State private var measuredHeight: CGFloat = 0
    
    var body: some View {
        VStack {
            ProfileHeaderView(
                onShowBottomSheet: { showBottomSheet.toggle() },
                username: "@radu_balgiu",
            )
            
            ProfileCountersView()
                .padding(.vertical, .xxl)
            
            ProfileUserInfoView()
            
            ProfileActionsView()
            
            HStack {
                Image(systemName: "repeat")
                AvatarView(
                    imageURL: URL(string: "https://media.scrollbooker.ro/avatar-male-9.jpeg"),
                    size: .s
                )
                Text("Frizeria Figaro")
                    .font(.headline)
            }
            .padding(.vertical, .xs)
            
            ProfileContactView()
            
            ProfileDescriptionView(description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been.")
            
            Spacer()
        }
        .sheet(isPresented: $showBottomSheet) {
            VStack {
                HStack {
                    Image(systemName: "camera")
                    Text("Creaza o postare")
                        .font(.headline)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top)
                .padding(.horizontal)
                
                HStack {
                    Image(systemName: "bag")
                    Text("Afacerea mea")
                        .font(.headline)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top)
                .padding(.horizontal)
                
                HStack {
                    Image(systemName: "gearshape")
                    Text("Setari")
                        .font(.headline)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top)
                .padding(.horizontal)
            }
            .padding(.top, .s)
            .padding(.bottom)
            .background(
                GeometryReader { geo in
                    Color.clear
                        .onAppear { measuredHeight = geo.size.height }
                        .onChange(of: geo.size.height) { _, new in
                            measuredHeight = new
                        }
                }
            )
            .presentationDetents([.height(max(100, measuredHeight + 16))])
            .presentationContentInteraction(.resizes)
            .presentationDragIndicator(.hidden)
            .presentationCornerRadius(25)
        }
        .padding()
    }
}

#Preview("Light") {
    MyProfileScreen()
}

#Preview("Dark") {
    MyProfileScreen()
        .preferredColorScheme(.dark)
}
