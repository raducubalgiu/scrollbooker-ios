//
//  AuthRouter.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.08.2025.
//

import SwiftUI

struct AuthRouter: View {
    let startStep: RegistrationStepEnum?
    let container: AppContainer
    let session: SessionManager
    let authViewModel: AuthViewModel
    let collectBusinessViewModel: CollectBusinessViewModel

    @State private var path: [AuthRoute]

    init(startStep: RegistrationStepEnum?, container: AppContainer, session: SessionManager) {
        self.startStep = startStep
        self.container = container
        self.session = session
        self.authViewModel = container.authModule.makeAuthViewModel(session: session)
        self.collectBusinessViewModel = container.onboardingModule.makeCollectBusinessViewModel(session: session)
        _path = State(initialValue: startStep.map { [AuthRoute(step: $0)] } ?? [])
    }

    var body: some View {
        NavigationStack(path: $path) {
            LoginScreen(authViewModel: authViewModel)
                .toolbar(.hidden, for: .navigationBar)
                .navigationDestination(for: AuthRoute.self) { route in
                    screen(for: route, authViewModel: authViewModel)
                        .toolbar(.hidden, for: .navigationBar)
                }
        }
        .onChange(of: session.userInfo?.registrationStep) { _, newStep in
            if let newStep {
                path.append(AuthRoute(step: newStep))
            }
        }
    }

    @ViewBuilder
    private func screen(for route: AuthRoute, authViewModel: AuthViewModel) -> some View {
        switch route {
        case .login:
            LoginScreen(authViewModel: authViewModel)
            
        case .registerClient:
            RegisterScreen(authViewModel: authViewModel)
            
        case .registerBusiness:
            RegisterBusinessScreen(authViewModel: authViewModel)
            
        case .collectEmailValidation:
            CollectEmailVerification(authViewModel: authViewModel)
            
        case .collectUserUsername:
            CollectUsernameScreen(viewModel: container.onboardingModule.makeCollectUsernameViewModel(session: session))
            
        case .collectUserPhoneNumber:
            CollectPhoneNumberScreen()
            
        case .collectClientBirthdate:
            CollectBirthdateScreen()
            
        case .collectClientGender:
            CollectGenderScreen()
            
        case .collectClientLocationPermission:
            CollectLocationPermissionScreen()
            
        case .collectBusiness:
            CollectBusinessTypeScreen(
                viewModel: collectBusinessViewModel,
                onNext: { path.append(.collectBusinessDetails) }
            )
            
        case .collectBusinessDetails:
            CollectBusinessDetailsScreen(
                viewModel: collectBusinessViewModel,
                onBack: { path.removeLast() },
                onNext: { path.append(.collectBusinessLocation) }
            )
            
        case .collectBusinessLocation:
            CollectBusinessLocationScreen(
                viewModel: collectBusinessViewModel,
                onBack: { path.removeLast() }
            )
            
        case .collectBusinessGallery:
            CollectBusinessGalleryScreen()
            
        case .collectBusinessServices:
            CollectBusinessServicesScreen()
            
        case .collectBusinessSchedules:
            CollectBusinessSchedulesScreen()
            
        case .collectBusinessHasEmployees:
            CollectBusinessHasEmployeesScreen()
            
        case .collectBusinessValidation:
            CollectBusinessValidationScreen()
            
        case .collectBusinessCurrencies:
            EmptyView()
        }
    }
}


