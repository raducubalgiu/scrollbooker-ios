//
//  EmploymentAsignJobScreen\.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 30.08.2025.
//

import SwiftUI

struct EmploymentAssignJobScreen: View {
    @Bindable var viewModel: MyEmployeesViewModel
    
    let onBack: () -> Void
    let onNext: () -> Void
    
    private var isButtonDisabled: Bool {
        viewModel.isSaving || viewModel.selectedProfessionForEmployment == nil
    }
    
    var body: some View {
        FormLayout(
            headline: String(localized: "assignJob"),
            subHeadline: String(localized: "chooseProfessionsFromTheList"),
            enableBottomButton: true,
            enableBack: true,
            buttonTitle: String(localized: "next"),
            isDisabled: isButtonDisabled,
            isLoading: viewModel.isSaving,
            onBack: onBack,
            onClick: {
                onNext()
            }
        ) {
            VStack {
                switch viewModel.professionsState {
                case .idle, .loading:
                    LoadingView()
                    
                case .error(let message):
                    Spacer()
                    ErrorView(message: message) {
                        Task { await viewModel.getProfessions() }
                    }
                    Spacer()
                    
                case .empty:
                    Spacer()
                    NoDataView(
                        title: String(localized: "professions"),
                        message: String(localized: "notFoundProfessions"),
                        systemImage: "briefcase.slash"
                    )
                    Spacer()
                    
                case .success(let professions):
                    ScrollView {
                        LazyVStack(spacing: 0) {
                            ForEach(Array(professions.enumerated()), id: \.element.id) { index, profession in
                                InputRadio(
                                    title: profession.name,
                                    isSelected: viewModel.selectedProfessionForEmployment?.id == profession.id,
                                    onClick: {
                                        if viewModel.selectedProfessionForEmployment?.id == profession.id {
                                            viewModel.selectedProfessionForEmployment = nil
                                        } else {
                                            viewModel.selectedProfessionForEmployment = profession
                                        }
                                    }
                                )
                                
                                if index < professions.count - 1 {
                                    Divider()
                                        .background(Color(.separator))
                                        .padding(.vertical, 8)
                                }
                            }
                        }
                        .padding(.top, 8)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .task {
            await viewModel.getProfessions()
        }
    }
}
