//
//  Header.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 25.08.2025.
//

import SwiftUI

struct HeaderView: View {
    var title: String = ""
    var enableBack: Bool = true
    //var onBack: (() -> Void)? = nil
    var onBack: () -> Void

    var body: some View {
        HStack {
            VStack {
                if enableBack {
                    Button {
                        onBack()
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
            Text(title)
                .font(.headline)
                .foregroundColor(.onBackgroundSB)
            Spacer()
            VStack { }.frame(width: 44, height: 44)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
