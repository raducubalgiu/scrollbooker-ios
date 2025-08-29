//
//  SelectView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 28.08.2025.
//

import SwiftUI


struct SelectView: View {
    @State private var selectedOption = ""
    @State private var isExpanded = false
    let options = [""]

    var body: some View {
        VStack(alignment: .leading) {
            Button(action: {
                withAnimation {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    Text(selectedOption)
                        .foregroundColor(.onSurfaceSB)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                        .foregroundColor(.onSurfaceSB)
                }
                .padding()
                .background(Color.surfaceSB)
                .cornerRadius(8)
            }

            if isExpanded {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(options, id: \.self) { option in
                        Text(option)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(selectedOption == option ? Color.primarySB.opacity(0.2) : Color.clear)
                            .onTapGesture {
                                selectedOption = option
                                withAnimation {
                                    isExpanded = false
                                }
                            }
                            .foregroundColor(.onSurfaceSB)
                    }
                }
                .background(Color.surfaceSB)
                .cornerRadius(8)
            }
        }
        }
}

#Preview {
    SelectView()
}
