//
//  Header.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 25.08.2025.
//

import SwiftUI

struct HeaderView<CustomAction: View>: View {
    var title: String = ""
    var enableBack: Bool = true
    var onBack: () -> Void
    var customAction: (() -> CustomAction)? = nil

    var body: some View {
        ZStack {
            Text(title)
                .font(.headline)
                .foregroundColor(.onBackgroundSB)
                .lineLimit(1)
                .truncationMode(.tail)
                .padding(.horizontal, 80)
            
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
                
                VStack(alignment: .trailing) {
                    if let actionView = customAction {
                        actionView()
                    }
                }
                .frame(minHeight: 44)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 4)
    }
}

extension HeaderView where CustomAction == EmptyView {
    init(title: String = "", enableBack: Bool = true, onBack: @escaping () -> Void) {
        self.title = title
        self.enableBack = enableBack
        self.onBack = onBack
        self.customAction = nil
    }
}


