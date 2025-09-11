//
//  CollectUserLocationPermissionScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 13.08.2025.
//

import SwiftUI

struct CollectLocationPermissionScreen: View {
    @State var viewModel: CollectLocationPermissionViewModel
    
    func handleCollectLocation() {
        Task { await viewModel.collectLocationPermission() }
    }
    
    var body: some View {
        FormLayout(
            headline: String(localized: "locationPermission"),
            subHeadline: "",
            buttonTitle: String(localized: "save"),
            isDisabled: viewModel.isLoading,
            isLoading: viewModel.isLoading,
            onClick: handleCollectLocation
        ) {
            
        }
    }
}

//#Preview {
//    CollectUserLocationPermissionScreen()
//}
