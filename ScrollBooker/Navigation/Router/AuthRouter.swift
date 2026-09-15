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
            CollectUsernameDestination(container: container, session: session)

        case .collectUserPhoneNumber:
            CollectPhoneNumberScreen()

        case .collectClientBirthdate:
            CollectBirthdateDestination(
                container: container,
                session: session,
                onBack: { path.removeLast() }
            )

        case .collectClientGender:
            CollectGenderDestination(
                container: container,
                session: session,
                onBack: { path.removeLast() }
            )

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
            CollectBusinessGalleryDestination(
                container: container,
                session: session,
                onBack: { path.removeLast() }
            )

        case .collectBusinessServices:
            CollectBusinessServicesDestination(
                container: container,
                session: session,
                onBack: { path.removeLast() }
            )

        case .collectBusinessSchedules:
            CollectBusinessSchedulesDestination(
                container: container,
                session: session,
                onBack: { path.removeLast() }
            )

        case .collectBusinessHasEmployees:
            CollectBusinessHasEmployeesDestination(
                container: container,
                session: session,
                onBack: { path.removeLast() }
            )

        case .collectBusinessValidation:
            CollectBusinessValidationScreen()

        case .collectBusinessCurrencies:
            EmptyView()
        }
    }
}

private struct CollectUsernameDestination: View {
    let container: AppContainer
    let session: SessionManager

    @State private var viewModel: CollectUsernameViewModel?

    var body: some View {
        Group {
            if let viewModel {
                CollectUsernameScreen(viewModel: viewModel)
            } else {
                ProgressView()
            }
        }
        .onAppear {
            if viewModel == nil {
                viewModel = container.onboardingModule.makeCollectUsernameViewModel(session: session)
            }
        }
    }
}

private struct CollectBirthdateDestination: View {
    let container: AppContainer
    let session: SessionManager
    let onBack: () -> Void

    @State private var viewModel: CollectBirthdateViewModel?

    var body: some View {
        Group {
            if let viewModel {
                CollectBirthdateScreen(viewModel: viewModel, onBack: onBack)
            } else {
                ProgressView()
            }
        }
        .onAppear {
            if viewModel == nil {
                viewModel = container.onboardingModule.makeCollectBirthdateViewModel(session: session)
            }
        }
    }
}

private struct CollectGenderDestination: View {
    let container: AppContainer
    let session: SessionManager
    let onBack: () -> Void

    @State private var viewModel: CollectGenderViewModel?

    var body: some View {
        Group {
            if let viewModel {
                CollectGenderScreen(viewModel: viewModel, onBack: onBack)
            } else {
                ProgressView()
            }
        }
        .onAppear {
            if viewModel == nil {
                viewModel = container.onboardingModule.makeCollectGenderViewModel(session: session)
            }
        }
    }
}

private struct CollectBusinessGalleryDestination: View {
    let container: AppContainer
    let session: SessionManager
    let onBack: () -> Void

    @State private var viewModel: CollectBusinessGalleryViewModel?

    var body: some View {
        Group {
            if let viewModel {
                CollectBusinessGalleryScreen(viewModel: viewModel, onBack: onBack)
            } else {
                ProgressView()
            }
        }
        .onAppear {
            if viewModel == nil {
                viewModel = container.onboardingModule.makeCollectBusinessGalleryViewModel(session: session)
            }
        }
    }
}

private struct CollectBusinessServicesDestination: View {
    let container: AppContainer
    let session: SessionManager
    let onBack: () -> Void

    @State private var viewModel: CollectBusinessServicesViewModel?

    var body: some View {
        Group {
            if let viewModel {
                CollectBusinessServicesScreen(viewModel: viewModel, onBack: onBack)
            } else {
                ProgressView()
            }
        }
        .onAppear {
            if viewModel == nil {
                viewModel = container.onboardingModule.makeCollectBusinessServicesViewModel(session: session)
            }
        }
    }
}

private struct CollectBusinessSchedulesDestination: View {
    let container: AppContainer
    let session: SessionManager
    let onBack: () -> Void

    @State private var viewModel: CollectBusinessSchedulesViewModel?

    var body: some View {
        Group {
            if let viewModel {
                CollectBusinessSchedulesScreen(viewModel: viewModel, onBack: onBack)
            } else {
                ProgressView()
            }
        }
        .onAppear {
            if viewModel == nil {
                viewModel = container.onboardingModule.makeCollectBusinessSchedulesViewModel(session: session)
            }
        }
    }
}

private struct CollectBusinessHasEmployeesDestination: View {
    let container: AppContainer
    let session: SessionManager
    let onBack: () -> Void

    @State private var viewModel: CollectBusinessHasEmployeesViewModel?

    var body: some View {
        Group {
            if let viewModel {
                CollectBusinessHasEmployeesScreen(viewModel: viewModel, onBack: onBack)
            } else {
                ProgressView()
            }
        }
        .onAppear {
            if viewModel == nil {
                viewModel = container.onboardingModule.makeCollectBusinessHasEmployeesViewModel(session: session)
            }
        }
    }
}
