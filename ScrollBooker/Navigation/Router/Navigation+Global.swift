//
//  GlobalRouters.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 12.07.2026.
//

import SwiftUI

enum DestinationResult<V: View> {
    case handled(V)
    case unhandled
}

import SwiftUI

struct GlobalNavigationModifier: ViewModifier {
    @EnvironmentObject private var container: AppContainer
    @EnvironmentObject private var session: SessionManager
    @Environment(Router.self) private var router

    let localDestination: (Route) -> (any View)?
    
    func body(content: Content) -> some View {
        content
            .navigationDestination(for: Route.self) { route in
                Group {
                    if let localView = localDestination(route) {
                        AnyView(localView)
                    } else {
                        globalScreen(for: route)
                    }
                }
                .toolbar(.hidden, for: .navigationBar)
            }
    }
    
    @ViewBuilder
    private func globalScreen(for route: Route) -> some View {
        switch route {
        case .appointmentDetails(let id):
            AppointmentDetailsScreen(
                viewModel: container.appointmentModule.makeAppointmentDetailsViewModel(
                    appointmentId: id,
                    session: session,
                    createReviewUseCase: container.reviewModule.createReviewUseCase,
                    updateReviewUseCase: container.reviewModule.updateReviewUseCase
                ),
                onBack: { router.pop() }
            )
            
        case .userProfile(let userId, let username):
            UserProfileScreen(
                viewModel: container.userProfileModule.makeUserProfileViewModel(userId: userId, username: username),
                onNavigateToEditProfile: { router.push(.editProfile) },
                onNavigateToSettings: { router.push(.mySettings) },
                onNavigateToMyBusiness: { router.push(.myBusiness) },
                onNavigateToUserProfile: { },
                onNavigateToUserSocial: {},
                onBack: { router.pop() }
            )
            
        case .userSocial(let userId, let username, let initialTab, let isBusinessOrEmployee, let followers, let followings):
            SocialScreen(
                viewModel: container.followModule.makeSocialViewModel(userId: userId),
                onBack: { router.pop() },
                username: username,
                initialTab: initialTab,
                isBusinessOrEmployee: isBusinessOrEmployee,
                initialFollowersCount: followers,
                initialFollowingsCount: followings
            )
        default:
            Text("Route \(String(describing: route)) not implemented globally")
        }
    }
}


extension View {
    func withNavigation(localDestination: @escaping (Route) -> (any View)?) -> some View {
        self.modifier(GlobalNavigationModifier(localDestination: localDestination))
    }
    
    func withGlobalNavigation() -> some View {
        self.modifier(GlobalNavigationModifier(localDestination: { _ in nil }))
    }
}
