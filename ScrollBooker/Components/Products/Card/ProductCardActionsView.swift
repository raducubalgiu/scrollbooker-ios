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

    @Environment(SessionManager.self) private var session

    private var hasEditPermission: Bool { session.hasPermission(.productEdit) }
    private var hasDeletePermission: Bool { session.hasPermission(.productDelete) }

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
                .sensoryFeedback(.selection, trigger: isSelected)
            } else if showAddSingleButtonNotSelectable {
                Protected(permission: .bookButtonView) {
                    Button(action: { onNavigateToBooking?(product) }) {
                        Text(String(localized: "book"))
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 16)
                            .overlay(
                                RoundedRectangle(cornerRadius: 50)
                                    .stroke(Color.dividerSB, lineWidth: 1)
                            )
                    }
                }
            } else if showBuyPackButton {
                Protected(permission: .bookButtonView) {
                    Button(action: { onSelect?(product) }) {
                        Text(String(localized: "buy"))
                            .font(.body)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 16)
                            .background(Color.accentColor)
                            .cornerRadius(8)
                    }
                }
            } else if displayEditableActions && (hasEditPermission || hasDeletePermission) {
                Menu {
                    if hasEditPermission {
                        Button(action: { onNavigateToEdit?(product.id) }) {
                            Label(String(localized: "edit"), systemImage: "pencil")
                        }
                    }

                    if hasDeletePermission {
                        Button(role: .destructive, action: { onDeleteProduct?(product.id) }) {
                            if isLoadingDelete {
                                Text(String(localized: "deleting"))
                            } else {
                                Label(String(localized: "delete"), systemImage: "trash")
                            }
                        }
                        .disabled(isLoadingDelete)
                    }
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
