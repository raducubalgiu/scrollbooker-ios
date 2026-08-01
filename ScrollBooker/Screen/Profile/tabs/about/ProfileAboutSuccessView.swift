//
//  ProfileAboutSuccessView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 01.08.2026.
//

import SwiftUI

struct ProfileAboutSuccessView: View {
    let about: UserProfileAbout
    let isEmployee: Bool
    let onNavigateToUserProfile: (Int, String) -> Void
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSize.xl.rawValue) {
                if isEmployee {
                    ProfileAboutOwnerSectionView(
                        owner: about.owner,
                        onNavigateToUserProfile: onNavigateToUserProfile
                    )
                }
                
                VStack(alignment: .leading, spacing: AppSize.base.rawValue) {
                    Text(String(localized: "address"))
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    HStack(spacing: 8) {
                        Image(systemName: "mappin.circle")
                            .font(.title3)
                            .foregroundColor(.secondary)
                        
                        Text(about.location.address)
                            .font(.body)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                VStack(alignment: .leading, spacing: AppSize.base.rawValue) {
                    Text(String(localized: "description"))
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    if let description = about.description {
                        Text(description)
                            .font(.body)
                            .foregroundColor(.primary)
                    }
                    
                    if let mapUrl = about.location.mapUrl {
                        SectionMap(
                            mapUrl: mapUrl,
                            coordinates: about.location.coordinates,
                            fullName: about.owner.fullName,
                            displayDirectionsButton: false
                        )
                    }
                }
                
                VStack(alignment: .leading, spacing: AppSize.base.rawValue) {
                    Text(String(localized: "schedule"))
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    SchedulesSection(schedules: about.schedules)
                }
                
                VStack(alignment: .leading, spacing: AppSize.base.rawValue) {
                    Text(String(localized: "photoGallery"))
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    BusinessMediaGalleryView(mediaFiles: about.businessMedia)
                }
            }
            .padding()
        }
    }
}
