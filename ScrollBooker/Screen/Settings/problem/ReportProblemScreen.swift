//
//  ReportProblemScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 26.08.2025.
//

import SwiftUI

struct ReportProblemScreen: View {
    let viewModel: ReportProblemViewModel
    @Environment(\.dismiss) private var dismiss
        
    var body: some View {
        @Bindable var vm = viewModel
        
        VStack {
                Header(title: "Raportează o problemă")
                
                VStack {
                    Textarea(
                        text: $vm.text,
                        label: "",
                        placeholder: "Descrie problema aici...",
                        height: 150
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
                        title: "Trimite",
                        onClick: {
                            Task { await viewModel.submitProblem() }
                        },
                        isDisabled: !viewModel.isInputValid || viewModel.isLoading,
                        isLoading: viewModel.isLoading
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
                if success { dismiss() }
            }
    }
}
//
//#Preview("Light") {
//    ReportProblemScreen()
//}
//
//#Preview("Dark") {
//    ReportProblemScreen()
//        .preferredColorScheme(.dark)
//}
