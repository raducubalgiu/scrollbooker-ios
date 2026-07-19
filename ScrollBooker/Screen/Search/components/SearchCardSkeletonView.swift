//
//  SearchCardSkeletons.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 17.07.2026.
//

import SwiftUI

struct SearchCardSkeletonView: View {
    let isAnimating: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.primary.opacity(0.06))
                .frame(height: 230)
            
            Spacer().frame(height: 12)
            
            businessInfoSection
                .padding(.horizontal, .base)
            
            Spacer().frame(height: 12)
            
            VStack(spacing: 12) {
                productRowSection
                productRowSection
            }
            .padding(.vertical, 8)
            .padding(.horizontal, .base)
            
            Spacer().frame(height: 16)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .opacity(isAnimating ? 0.45 : 1.0)
        .padding(.horizontal, .base)
    }
    
    @ViewBuilder
    private var businessInfoSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .center) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.primary.opacity(0.08))
                    .frame(width: 180, height: 18)
                
                Spacer()
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.primary.opacity(0.06))
                    .frame(width: 60, height: 16)
            }
            .frame(maxWidth: .infinity)
            
            Spacer().frame(height: 6)
            
            RoundedRectangle(cornerRadius: 4)
                .fill(Color.primary.opacity(0.05))
                .frame(width: 120, height: 14)
            
            Spacer().frame(height: 8)
            
            HStack(alignment: .center, spacing: 8) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.primary.opacity(0.05))
                    .frame(width: 45, height: 12)
                
                Circle()
                    .fill(Color.primary.opacity(0.05))
                    .frame(width: 3, height: 3)
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.primary.opacity(0.05))
                    .frame(width: 140, height: 12)
            }
        }
    }
    
    @ViewBuilder
    private var productRowSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(alignment: .top, spacing: 0) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.primary.opacity(0.08))
                    .frame(width: 140, height: 16)
                
                Spacer(minLength: 16)

                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.primary.opacity(0.08))
                    .frame(width: 75, height: 16)
            }
            
            Spacer().frame(height: 6)

            HStack(alignment: .center, spacing: 8) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.primary.opacity(0.05))
                    .frame(width: 60, height: 12)
                
                Circle()
                    .fill(Color.primary.opacity(0.05))
                    .frame(width: 3, height: 3)
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.primary.opacity(0.05))
                    .frame(width: 80, height: 12)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.m)
        .background(Color.surfaceSB)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
