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
    var router: Router
    @State private var viewModel: MyProfileViewModel?
    
    var body: some View {
        @Bindable var bindableRouter = router
        
        NavigationStack(path: $bindableRouter.profilePath) {
            Group {
                if let stableViewModel = viewModel {
                    MyProfileScreen(
                        viewModel: stableViewModel,
                        onNavigateToEditProfile: { router.push(.editProfile) },
                        onNavigateToSettings: { router.push(.mySettings) },
                        onNavigateToMyBusiness: { router.push(.myBusiness) },
                        onNavigateToUserProfile: { router.push(.userProfile($0)) },
                        onNavigateToUserSocial: { router.push(.userSocial($0)) },
                        onNavigateToMyCalendar: { router.push(.myCalendar) },
                        onNavigateToCamera: { router.push(.camera) },
                    )
                    .safeAreaInset(edge: .bottom, spacing: 0) {
                        CustomTabBar(backgroundColor: .backgroundSB)
                    }
                } else {
                    ProgressView()
                }
            }
            .withNavigation { route in
                switch route {
                    case .mySettings:
                        return SettingsScreen(
                            onNavigate: { r in router.push(r) },
                            onBack: { router.pop() }
                        )
                        
                    case .display:
                        return DisplayScreen(onBack: { router.pop() })
                        
                    case .reportProblem:
                        return ReportProblemScreen(
                            viewModel: container.problemModule.makeProblemViewModel(userId: session.userInfo?.id ?? 0),
                            onBack: { router.pop() }
                        )
                        
                    case .editProfile:
                        if let viewModel = viewModel {
                            return EditProfileScreen(
                                viewModel: viewModel,
                                onNavigate: { r in router.push(r) },
                                onBack: { router.pop() }
                            )
                        }
                        return nil
                    
                    case .editFullName:
                        if let viewModel = viewModel {
                            return EditNameScreen(viewModel: viewModel, onBack: { router.pop() })
                        }
                        return nil
                        
                    case .editUsername:
                        if let viewModel = viewModel {
                            return EditUsernameScreen(viewModel: viewModel, onBack: { router.pop() })
                        }
                        return nil
                        
                    case .editBio:
                        if let viewModel = viewModel {
                            return EditBioScreen(viewModel: viewModel, onBack: { router.pop() })
                        }
                        return nil
                        
                    case .editGender:
                        if let viewModel = viewModel {
                            return EditGenderScreen(viewModel: viewModel, onBack: { router.pop() })
                        }
                        return nil
                        
                    case .editBirthdate:
                        if let viewModel = viewModel {
                            return EditBirthdateScreen(viewModel: viewModel, onBack: { router.pop() })
                        }
                        return nil
                        
                    // MARK: - My Business Flow
                    case .myBusiness:
                        return MyBusinessScreen(
                            onNavigate: { r in router.push(r) },
                            onBack: { router.pop() }
                        )
                        
                    case .myBusinessDetails:
                        return MyBusinessDetailsScreen()
                    
                    case .mySchedules:
                        return MySchedulesScreen(
                            viewModel: container.scheduleModule.makeMySchedulesViewModel(session: session),
                            onBack: { router.pop() }
                        )
                    
                    case .myProducts:
                        return MyProductsScreen(
                            viewModel: container.productModule.makeMyProductsViewModel(session: session),
                            onBack: { router.pop() },
                            onNavigateAddProduct: {},
                            onNavigateEditProduct: { _, _ in }
                        )
                    
                    case .myServices:
                        return MyServicesScreen(
                            viewModel: container.servieDomainModule.makeMyServicesViewModel(session: session),
                            onBack: { router.pop() }
                        )
                        
                    case .myCalendar:
                        return MyCalendarScreen(onBack: { router.pop() })
                        
                    case .myEmployees:
                        return EmployeesFlowContainer(
                            container: container,
                            onBack: { router.pop() },
                            session: session
                        )
            
                    default:
                        return nil
                    }
            }
        }
        .onChange(of: router.selectedTab, initial: true) { _, newTab in
            if newTab == .profile && viewModel == nil {
                setupViewModel()
            }
        }
    }
    
    private func setupViewModel() {
        viewModel = container.userProfileModule.makeMyProfileViewModel(
            session: session,
            getUserPostsUseCase: container.postModule.getUserPostsUseCase,
            getUserBookmarkedPostsUseCase: container.postModule.getUserBookmarkedPostsUseCase,
            getProductsByBusinessAndEmployeeUseCase: container.productModule.getProductsByBusinessAndEmployeeUseCase
        )
    }
}
