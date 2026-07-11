//
//  InputSelectView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 11.07.2026.
//

import SwiftUI

struct TimeOption: Hashable {
    let value: String
    let name: String
}

struct InputSelectView: View {
    let placeholder: String
    let options: [TimeOption]
    let selectedOption: String
    let onValueChange: (String) -> Void
    
    var body: some View {
        Menu {
            ForEach(options, id: \.value) { option in
                Button(action: {
                    onValueChange(option.value)
                }) {
                    Text(option.name)
                }
            }
        } label: {
            HStack {
                let currentName = options.first(where: { $0.value == selectedOption })?.name ?? placeholder
                
                Text(currentName)
                    .foregroundColor(selectedOption == "null" ? .gray : .primary)
                Spacer()
                
                Image(systemName: "chevron.down")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding()
            .background(Color.surfaceSB)
            .cornerRadius(8)
        }
    }
}
