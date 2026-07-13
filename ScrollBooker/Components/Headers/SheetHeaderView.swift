//
//  SheetHeaderView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 10.07.2026.
//

import SwiftUI

struct SheetHeaderView: View {
    var onDismiss: () -> Void
    
    var title: String = ""
    var showDivider: Bool = true
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .center) {
                if !title.isEmpty {
                    Text(title)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 44)
                }
                
                HStack {
                    Spacer()
                    
                    Button {
                        onDismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 14, weight: .bold))
                            .padding(8)
                            .clipShape(Circle())
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, .base)
            .padding(.vertical, .s)
            
            if showDivider {
                Divider()
            }
        }
    }
}
