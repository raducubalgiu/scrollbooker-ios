//
//  ReportProblemScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 26.08.2025.
//

import SwiftUI

struct ReportProblemScreen: View {
    let viewModel: ReportProblemViewModel
    var onBack: () -> Void
        
    var body: some View {
        @Bindable var vm = viewModel
        
        VStack {
            HeaderView(
                title: String(localized: "reportProblem"),
                onBack: onBack
            )
            
            VStack {
                Textarea(
                    text: $vm.text,
                    placeholder: String(localized: "describeTheProblem"),
                    label: "",
                )
                
                if let error = viewModel.errorMessage {
                    Text(error)
                        .font(.caption)
                        .foregroundColor(.errorSB)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 4)
                }
                
                Spacer()
                
                MainButton(
                    title: String(localized: "send"),
                    isDisabled: !viewModel.isInputValid || viewModel.isLoading,
                    isLoading: viewModel.isLoading,
                    onClick: {
                        Task { await viewModel.submitProblem() }
                    },
                )
            }
            .padding(.horizontal)
        }
        .navigationBarHidden(true)
        .background(Color.backgroundSB)
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        .onChange(of: viewModel.isSuccess) { _, success in
            if success {
                onBack()
            }
        }
    }
}
