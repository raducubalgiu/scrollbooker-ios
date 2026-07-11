//
//  MyEmployeesFlowContainer.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 11.07.2026.
//

import SwiftUI

struct EmployeesFlowContainer: View {
    let container: AppContainer
    let session: SessionManager

    @Environment(\.dismiss) private var dismissFlow

    @State private var viewModel: MyEmployeesViewModel
    @State private var steps: [EmploymentFlowStep] = [.list]

    private let iosNavigationAnimation = Animation.smooth(duration: 0.35, extraBounce: 0)

    init(container: AppContainer, session: SessionManager) {
        self.container = container
        self.session = session
        _viewModel = State(initialValue:
            container.employmentRequestModule.makeMyEmployeesViewModel(
                session: session,
                getEmployeesByOwnerUseCase: container.employeesModule.getEmployeesByOwner,
                searchUsersUseCase: container.searchModule.searchUsersUseCase,
                getProfessionsByBusinessTypeUseCase: container.professionModule.getProfessionsByBusinessTypeUseCase
            )
        )
    }

    private func push(_ step: EmploymentFlowStep) {
        withAnimation(iosNavigationAnimation) {
            steps.append(step)
        }
    }

    private func back() {
        withAnimation(iosNavigationAnimation) {
            if steps.count > 1 {
                steps.removeLast()
            } else {
                dismissFlow()
            }
        }
    }

    var body: some View {
        ZStack {
            ForEach(Array(steps.enumerated()), id: \.element) { index, step in
                let isTop = index == steps.count - 1

                stepView(for: step)
                    .zIndex(Double(index))
                    .offset(x: isTop ? 0 : -100)
                    .transition(.move(edge: .trailing))
                    .allowsHitTesting(isTop)
            }
        }
    }

    @ViewBuilder
    private func stepView(for step: EmploymentFlowStep) -> some View {
        switch step {
        case .list:
            MyEmployeesScreen(
                viewModel: viewModel,
                onBack: { dismissFlow() },
                onNavigateToSearchUser: { push(.selectEmployee) }
            )
        case .selectEmployee:
            EmploymentSelectEmployeeScreen(
                viewModel: viewModel,
                onBack: back,
                onNext: { push(.assignJob) }
            )
        case .assignJob:
            EmploymentAssignJobScreen(
                viewModel: viewModel,
                onBack: back,
                onNext: { push(.acceptTerms) }
            )
        case .acceptTerms:
            EmploymentAcceptTermsScreen(
                viewModel: viewModel,
                onBack: back,
                onNext: { dismissFlow() }
            )
        }
    }
}
