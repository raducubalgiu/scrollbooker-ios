//
//  EmployeeSelectDropdownView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 21.07.2026.
//

import SwiftUI

struct EmployeeSelectDropdown: View {
    let selectedEmployeeId: Int?
    let employees: [BookingFlowUser]
    var onEmployeeSelected: (Int) -> Void
    
    @State private var isExpanded: Bool = false
    
    private var currentSelected: BookingFlowUser? {
        employees.first(where: { $0.id == selectedEmployeeId })
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            selectorHeaderRow
            
            if isExpanded {
                dropdownMenuContent
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    @ViewBuilder
    private var selectorHeaderRow: some View {
        HStack(spacing: 16) {
            Group {
                if let selected = currentSelected {
                    SpecialistItemView(
                        isSelected: false,
                        specialist: selected,
                        withBadge: false
                    )
                } else {
                    placeholderView
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Image(systemName: "chevron.down")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.secondary)
                .rotationEffect(.degrees(isExpanded ? 180 : 0))
        }
        .padding(.horizontal, .s)
        .padding(.vertical, .s)
        .background(Color.backgroundSB)
        .clipShape(Capsule())
        .overlay(
            Capsule().stroke(Color.dividerSB, lineWidth: 1)
        )
        .contentShape(Capsule())
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.25)) {
                isExpanded.toggle()
            }
        }
    }
    
    private var placeholderView: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color.accentColor)
                    .frame(width: 40, height: 40)
                
                Image(systemName: "person.fill")
                    .foregroundColor(.white)
            }
            
            Text("Alege Specialistul")
                .foregroundColor(.secondary)
        }
    }
    
    @ViewBuilder
    private var dropdownMenuContent: some View {
        VStack(spacing: 4) {
            ScrollView {
                VStack(spacing: 4) {
                    ForEach(employees) { specialist in
                        specialistRow(for: specialist)
                    }
                }
                .padding(.vertical, 8)
            }
            .frame(maxHeight: 250)
        }
        .background(Color.surfaceSB)
        .cornerRadius(12)
        .padding(.horizontal, 8)
        .transition(.opacity.combined(with: .scale(scale: 0.95, anchor: .top)))
    }
    
    @ViewBuilder
    private func specialistRow(for specialist: BookingFlowUser) -> some View {
        let isRowSelected = selectedEmployeeId == specialist.id
        
        Button(action: {
            onEmployeeSelected(specialist.id)
            withAnimation(.easeInOut(duration: 0.2)) {
                isExpanded = false
            }
        }) {
            SpecialistItemView(
                isSelected: isRowSelected,
                specialist: specialist,
                withBadge: true,
                size: .l
            )
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}
