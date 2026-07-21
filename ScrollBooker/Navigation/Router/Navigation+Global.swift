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
            
        case .userProfile(let params):
            UserProfileScreen(
                viewModel: container.userProfileModule.makeUserProfileViewModel(
                    userId: params.userId, username: params.username
                ),
                onNavigateToEditProfile: { router.push(.editProfile) },
                onNavigateToSettings: { router.push(.mySettings) },
                onNavigateToMyBusiness: { router.push(.myBusiness) },
                onNavigateToUserProfile: { router.push(.userProfile($0)) },
                onNavigateToUserSocial: { router.push(.userSocial($0)) },
                onNavigateToBooking: { router.push(.bookingServices($0)) },
                onBack: { router.pop() }
            )
            
        case .userSocial(let params):
            SocialScreen(
                viewModel: container.followModule.makeSocialViewModel(userId: params.userId),
                onBack: { router.pop() },
                username: params.username,
                isBusinessOrEmployee: params.isBusinessOrEmployee,
                followersCount: params.followersCount,
                followingsCount: params.followingsCount,
                selectedTab: params.initialTab,
                onNavigateToUserProfile: { router.push(.userProfile($0)) },
            )
            
        case .bookingServices(let params):
            let viewModel: BookingViewModel = {
                if let existingVM = router.activeBookingViewModel {
                    return existingVM
                } else {
                    let newVM = container.bookingFlowModule.makeBookingFlowViewModel(params: params)
                    router.activeBookingViewModel = newVM
                    return newVM
                }
            }()
            
            BookingServicesScreen(
                viewModel: viewModel,
                onBack: {
                    router.clearBookingSession()
                    router.pop()
                },
                onNext: {
                    if viewModel.shouldSelectSpecialist {
                        router.push(.bookingSpecialists)
                    } else {
                        router.push(.bookingDateTime)
                    }
                }
            )
            
        case .bookingSpecialists:
            if let viewModel = router.activeBookingViewModel {
                BookingSpecialistsScreen(
                    viewModel: viewModel,
                    onBack: { router.pop() },
                    onNavigateToDateTime: { router.push(.bookingDateTime) }
                )
            } else {
                fatalError("Sesiunea de booking a fost accesată fără o inițializare prealabilă.")
            }
            
        case .bookingDateTime:
            if let viewModel = router.activeBookingViewModel {
                BookingDateTimeScreen(
                    viewModel: viewModel,
                    onBack: { router.pop() },
                    onNavigateToConfirmation: { router.push(.bookingConfirmation) }
                )
            } else {
                fatalError("Sesiunea de booking a fost accesată fără o inițializare prealabilă.")
            }
            
        case .bookingConfirmation:
            if let viewModel = router.activeBookingViewModel {
                BookingConfirmationScreen(
                    viewModel: viewModel,
                    onBack: { router.pop() },
                    onFinishBooking: {
                        router.clearBookingSession()
                    }
                )
            } else {
                fatalError("Sesiunea de booking a fost accesată fără o inițializare prealabilă.")
            }
            
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
