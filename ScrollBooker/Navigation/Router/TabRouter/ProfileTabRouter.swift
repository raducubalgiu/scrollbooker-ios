//
//  §TabRouter.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 15.08.2025.
//

import SwiftUI

struct ProfileTabRouter: View {
    @EnvironmentObject private var container: AppContainer
    @EnvironmentObject private var session: SessionManager
    @ObservedObject var router: Router
    @State private var viewModel: ProfileViewModel?
    
    var body: some View {
        NavigationStack(path: $router.profilePath) {
            Group {
                if let stableViewModel = viewModel {
                    ProfileScreen(
                        viewModel: stableViewModel,
                        onNavigateToEditProfile: { router.push(.editProfile) },
                        onNavigateToSettings: { router.push(.mySettings) },
                        onNavigateToMyBusiness: { router.push(.myBusiness) },
                        onNavigateToUserProfile: { },
                        onNavigateToUserSocial: {
                            router.push(.userSocial(userId: 13, username: "radu_ion", initialTab: .followers, isBusinessOrEmployee: true, initialFollowersCount: 100, initialFollowingsCount: 200))
                        }
                    )
                } else {
                    ProgressView()
                }
            }
            .withNavigation { route in
                switch route {
                // MARK: - Settings Flow
                case .mySettings:
                    SettingsScreen { r in router.push(r) }
                        .toolbar(.hidden, for: .navigationBar)
                case .display:
                    DisplayScreen()
                case .reportProblem:
                    ReportProblemScreen(viewModel: container.problemModule.makeProblemViewModel(userId: session.userInfo?.id ?? 0))
                        .toolbar(.hidden, for: .navigationBar)
                    
                // MARK: - Edit Profile Flow
                case .editProfile:
                    EditProfileScreen { r in router.push(r) }
                        .toolbar(.hidden, for: .navigationBar)
                case .editFullName:
                    EditNameScreen().toolbar(.hidden, for: .navigationBar)
                case .editUsername:
                    EditUsernameScreen().toolbar(.hidden, for: .navigationBar)
                case .editBio:
                    EditBioScreen().toolbar(.hidden, for: .navigationBar)
                case .editGender:
                    EditGenderScreen().toolbar(.hidden, for: .navigationBar)
                case .editBirthdate:
                    EditBirthdateScreen().toolbar(.hidden, for: .navigationBar)
                    
                // MARK: - My Business Flow
                case .myBusiness:
                    MyBusinessScreen { r in router.push(r) }
                        .toolbar(.hidden, for: .navigationBar)
                case .myBusinessDetails:
                    MyBusinessDetailsScreen().toolbar(.hidden, for: .navigationBar)
                case .myCalendar:
                    MyCalendarScreen().toolbar(.hidden, for: .navigationBar)
                case .myProducts:
                    MyProductsScreen().toolbar(.hidden, for: .navigationBar)
                case .mySchedules:
                    MySchedulesScreen(viewModel: container.scheduleModule.makeMySchedulesViewModel(session: session))
                        .toolbar(.hidden, for: .navigationBar)
                case .myServices:
                    MyServicesScreen(viewModel: container.servieDomainModule.makeMyServicesViewModel(session: session))
                        .toolbar(.hidden, for: .navigationBar)
                case .myEmployees:
                    EmployeesFlowContainer(container: container, session: session)
                        .toolbar(.hidden, for: .navigationBar)
                    
                // Pentru orice altă rută (care este globală), returnăm nil
                default:
                    nil
                }
            }
        }
        .onAppear {
            if viewModel == nil {
                viewModel = container.userProfileModule.makeProfileViewModel(session: session)
            }
        }
        .toolbar(router.profilePath.isEmpty ? .visible : .hidden, for: .tabBar)
    }
}
