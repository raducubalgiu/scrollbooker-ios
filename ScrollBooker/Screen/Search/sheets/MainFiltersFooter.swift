//
//  MainFiltersFooter.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 20.07.2026.
//

import SwiftUI

struct MainFiltersFooter: View {
    var isClearEnabled: Bool = true
    var isConfirmEnabled: Bool = true
    var onConfirm: () -> Void
    var onClear: () -> Void
    var onOpenDate: () -> Void
    var onClearDate: () -> Void
    var summary: String?
    var isActive: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            // HorizontalDivider din Compose
            Rectangle()
                .fill(Color(.systemGray4))
                .frame(height: 0.55)
                .padding(.bottom, 16) // BasePadding
            
            Spacer().frame(height: 16) // BasePadding
            
            // Butonul de selectare a datei
            DateTimeButton(
                title: summary ?? "",
                isActive: isActive,
                onClick: onOpenDate,
                onClearDate: onClearDate
            )
            
            Spacer().frame(height: 16) // BasePadding
            
            // Zona de acțiuni (butoanele de jos)
            SearchSheetActions(
                onClear: onClear,
                onConfirm: onConfirm,
                isClearEnabled: isClearEnabled,
                isConfirmEnabled: isConfirmEnabled
            )
        }
        .background(Color(.systemBackground)) // Se asigură că footer-ul are fundal opac peste conținut
    }
}

// MARK: - Sub-componente

struct DateTimeButton: View {
    let title: String
    var isActive: Bool = false
    var onClick: () -> Void
    var onClearDate: () -> Void
    
    var body: some View {
        Button(action: onClick) {
            HStack(spacing: 0) {
                // Iconița de ceas (ic_clock_outline)
                Image(systemName: "clock")
                    .foregroundColor(.gray)
                
                Spacer().frame(width: 24) // SpacingXL combinat cu BasePadding din Compose
                
                Text(title)
                    .font(.body)
                    .foregroundColor(.primary)
                
                Spacer()
                
                // Comportamentul condiționat pentru starea activă
                if isActive {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                        .font(.title3)
                        .onTapGesture {
                            // Interceptăm click-ul doar pentru ștergere fără a declanșa onClick-ul general
                            onClearDate()
                        }
                } else {
                    // Icons.Default.KeyboardArrowDown
                    Image(systemName: "chevron.down")
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal, 24) // SpacingXL
            .padding(.vertical, 16)   // BasePadding
            .frame(maxWidth: .infinity)
            // Schimbarea nuanței fundalului în funcție de starea activă
            .background(isActive ? Color(.systemGray5).opacity(0.8) : Color(.systemGray6))
            .cornerRadius(16) // ShapeDefaults.ExtraLarge
        }
        .padding(.horizontal, 16) // BasePadding extern
        .buttonStyle(.plain) // Elimină efectul nativ de opacitate la click pe tot containerul
    }
}

struct SearchSheetActions: View {
    var onClear: () -> Void
    var onConfirm: () -> Void
    var isClearEnabled: Bool = true
    var isConfirmEnabled: Bool = true
    var displayIcon: Bool = true
    var clearActionText: String = "Șterge" // R.string.delete
    var primaryActionText: String = "Caută" // R.string.search
    
    var body: some View {
        HStack {
            // Butonul secundar (TextButton)
            Button(action: onClear) {
                Text(clearActionText)
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(isClearEnabled ? .primary : .gray)
            }
            .disabled(!isClearEnabled)
            
            Spacer()
            
            // Butonul principal (Button / Filled Button)
            Button(action: onConfirm) {
                HStack(spacing: 4) { // SpacingXS
                    if displayIcon {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 16, weight: .bold))
                    }
                    
                    Text(primaryActionText)
                        .font(.system(size: 18, weight: .bold))
                }
                .padding(.vertical, 16)   // BasePadding
                .padding(.horizontal, 32) // SpacingXXL
                .foregroundColor(.white)
                .background(isConfirmEnabled ? Color.accentColor : Color.gray.opacity(0.5))
                .cornerRadius(100) // Pill shape standard pentru butoane mari
            }
            .disabled(!isConfirmEnabled)
        }
        .padding(16) // BasePadding general peste Row
        .frame(maxWidth: .infinity)
    }
}

