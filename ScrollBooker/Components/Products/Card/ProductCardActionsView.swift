//
//  ProductCardActionsView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 21.07.2026.
//

import SwiftUI

struct ProductCardActionsView: View {
    let product: Product
    let isSelected: Bool
    let isSelectable: Bool
    let displayEditableActions: Bool
    let isLoadingDelete: Bool

    var onSelect: ((Product) -> Void)? = nil
    var onNavigateToEdit: ((Int) -> Void)? = nil
    var onDeleteProduct: ((Int) -> Void)? = nil
    var onNavigateToBooking: ((Product) -> Void)? = nil

    var body: some View {
        let isSingle = product.type == .single
        let canBook = product.canBeBooked

        let showAddSingleButtonSelectable = !displayEditableActions && canBook && isSingle && isSelectable
        let showAddSingleButtonNotSelectable = !displayEditableActions && canBook && isSingle && !isSelectable
        let showBuyPackButton = !displayEditableActions && canBook && !isSingle

        Group {
            if showAddSingleButtonSelectable {
                Button(action: { onSelect?(product) }) {
                    Image(systemName: isSelected ? "checkmark" : "plus")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(isSelected ? .white : .onBackgroundSB)
                        .frame(width: 40, height: 40)
                        .background(isSelected ? Color.primarySB : Color(uiColor: .systemBackground))
                        .clipShape(Circle())
                        .shadow(
                            color: Color.black.opacity(0.15),
                            radius: isSelected ? 1 : 4,
                            x: 0,
                            y: isSelected ? 1 : 2
                        )
                }
            } else if showAddSingleButtonNotSelectable {
                Button(action: { onNavigateToBooking?(product) }) {
                    Text(String(localized: "book"))
                        .font(.body)
                        .fontWeight(.semibold)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 50)
                                .stroke(Color.dividerSB, lineWidth: 1)
                        )
                }
            } else if showBuyPackButton {
                Button(action: { onSelect?(product) }) {
                    Text("Cumpără")
                        .font(.body)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                        .background(Color.accentColor)
                        .cornerRadius(8)
                }
            } else if displayEditableActions {
                Menu {
                    Button(action: { onNavigateToEdit?(product.id) }) {
                        Label("Editează", systemImage: "pencil")
                    }
                    
                    Button(role: .destructive, action: { onDeleteProduct?(product.id) }) {
                        if isLoadingDelete {
                            Text("Se șterge...")
                        } else {
                            Label("Șterge", systemImage: "trash")
                        }
                    }
                    .disabled(isLoadingDelete)
                    
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.title3)
                        .foregroundColor(.secondary)
                        .frame(width: 32, height: 32)
                }
            }
        }
    }
}
