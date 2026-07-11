//
//  Header.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 25.08.2025.
//

import SwiftUI

struct Header: View {
    var title: String = ""
    var enableBack: Bool = true
    var onBack: (() -> Void)? = nil

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        HStack {
            VStack {
                if enableBack {
                    Button {
                        if let onBack {
                            onBack()
                        } else {
                            dismiss()
                        }
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 22.5))
                            .fontWeight(.semibold)
                            .foregroundColor(.onBackgroundSB)
                    }
                }
            }
            .frame(width: 44, height: 44)

            Spacer()
            Text(title).font(.headline).foregroundColor(.onBackgroundSB)
            Spacer()
            VStack { }.frame(width: 44, height: 44)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview("Light") {
    Header(
        title: "Header"
    )
    
    Spacer()
}

#Preview("Dark") {
    Header(
        title: "Header"
    )
    .preferredColorScheme(.dark)
    
    Spacer()
}
