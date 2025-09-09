//
//  AuthRouter.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.08.2025.
//

import SwiftUI

struct AuthRouter: View {
    @EnvironmentObject private var container: AppContainer
    @EnvironmentObject private var session: SessionManager
    let startStep: RegistrationStepEnum?
    
    @State private var path: [AuthRoute] = []
    
    private var startDestination: AuthRoute {
        if let step = startStep {
            return AuthRoute(step: step)
        } else {
            return .login
        }
    }
    
    var body: some View {
        NavigationStack(path: $path) {
            startView
                .navigationDestination(for: AuthRoute.self) { route in
                    screen(for: route)
                }
                .onAppear {
                    if startStep != nil && path.isEmpty {
                        path = [startDestination]
                    }
                }
        }
    }
    
    @ViewBuilder
    private var startView: some View {
        switch startDestination {
        case .login:
            LoginScreen()
        default:
            screen(for: startDestination)
        }
    }
        
    @ViewBuilder
    private func screen(for route: AuthRoute) -> some View {
        switch route {
        case .login:
            LoginScreen()
            
        case .registerClient:
            RegisterScreen()
            
        case .registerBusiness:
            RegisterBusinessScreen()
            
        case .collectEmailValidation:
            CollectEmailVerification()
                .navigationBarHidden(true)
            
        case .collectUserUsername:
            CollectUsernameScreen(
                viewModel: container.makeCollectUsernameViewModel()
            )
                .navigationBarHidden(true)
            
        case .collectClientBirthdate:
            CollectClientBirthdateScreen()
            
        case .collectClientGender:
            CollectClientGenderScreen()
            
        case .collectClientLocationPermission:
            CollectUserLocationPermissionScreen()
            
        case .collectBusiness:
            CollectBusinessTypeScreen()

        case .collectBusinessDetails:
            CollectBusinessDetailsScreen()
            
        case .collectBusinessLocation:
            CollectBusinessAdressScreen()
            
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
        }
    }
}
