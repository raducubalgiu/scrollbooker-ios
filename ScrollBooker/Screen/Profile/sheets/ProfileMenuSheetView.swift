//
//  ProfileMenuSheet.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 31.08.2025.
//

import SwiftUI

struct ProfileMenuSheetView: View {
    @Binding var isPresented: Bool
    var onCreatePost: () -> Void
    var onNavigateToMyBusiness: () -> Void
    var onNavigateToSettings: () -> Void
    
    @State private var measuredHeight: CGFloat = 0
    
    var body: some View {
        VStack {
            ListItemView(
                title: "Creaza o postare",
                leadingIcon: "camera",
                onClick: {
                    isPresented = false
                    onCreatePost()
                },
                showTrailingIcon: false
            )
            .padding(.horizontal)
            
            ListItemView(
                title: "Afacerea mea",
                leadingIcon: "bag",
                onClick: {
                    isPresented = false
                    onNavigateToMyBusiness()
                },
                showTrailingIcon: false
            )
            .padding(.horizontal)
            
            ListItemView(
                title: "Setari",
                leadingIcon: "gearshape",
                onClick: {
                    isPresented = false
                    onNavigateToSettings()
                },
                showTrailingIcon: false
            )
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
}

//#Preview {
//    ProfileMenuSheet()
//}
