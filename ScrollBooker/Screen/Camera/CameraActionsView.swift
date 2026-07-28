//
//  CameraActionsView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 27.07.2026.
//

import SwiftUI

struct CameraActionsView: View {
    var mediaThumbnail: UIImage?
    var onMediaThumbClick: () -> Void
    var onSwitchCamera: () -> Void
    var onRecord: () -> Void
    
    var body: some View {
        VStack {
            Spacer()
            
            HStack(alignment: .center) {
                Button(action: onMediaThumbClick) {
                    Group {
                        if let image = mediaThumbnail {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                        } else {
                            Color.black
                        }
                    }
                    .frame(width: 50, height: 50)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 2)
                    )
                }
                .buttonStyle(.plain)
                
                Spacer()
                
                RecordButtonView(onTap: onRecord)
                
                Spacer()
                
                Button(action: onSwitchCamera) {
                    Image(systemName: "arrow.triangle.2.circlepath")
                        .font(.system(size: 26))
                        .foregroundColor(Color(uiColor: .systemGray4))
                        .frame(width: 44, height: 44)
                }
                .disabled(true)
                .opacity(0.5)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
        }
    }
}
