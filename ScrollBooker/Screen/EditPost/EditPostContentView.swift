//
//  EditPostContentView.swift
//  ScrollBooker
//

import SwiftUI

/// The editable-fields body shared by CreatePostScreen (a new, unpublished post) and
/// EditPostScreen (an already-published post's metadata) — mirrors Android's
/// `EditPostContent` composable. Owns its own linked-products picker sheet so neither
/// caller has to redeclare that state.
struct EditPostContentView: View {
    let isVideoReview: Bool

    let rating: Int
    let review: String
    var onRatingChange: (Int) -> Void
    var onReviewChange: (String) -> Void

    let serviceDomainOptions: [SelectOption]
    let selectedServiceDomainId: String
    var onSelectServiceDomain: (String) -> Void

    let linkedProducts: [Product]
    let userProductsViewState: FeatureState<UserProducts>
    var onConfirmLinkedProductsSelection: ([Product]) -> Void
    var onEditLinkedProduct: ((Product) -> Void)? = nil
    var onRemoveLinkedProduct: (Product) -> Void

    @State private var showLinkedProductsSheet = false

    var body: some View {
        Group {
            if isVideoReview {
                CreatePostReviewSectionView(
                    rating: rating,
                    review: review,
                    onRatingChange: onRatingChange,
                    onReviewChange: onReviewChange
                )
            } else {
                CreatePostCategorySectionView(
                    options: serviceDomainOptions,
                    selectedOptionId: selectedServiceDomainId,
                    onSelect: onSelectServiceDomain
                )

                CreatePostLinkedProductsSectionView(
                    linkedProducts: linkedProducts,
                    onChangeSelection: { showLinkedProductsSheet = true },
                    onEdit: onEditLinkedProduct,
                    onRemove: onRemoveLinkedProduct
                )
            }
        }
        .sheet(isPresented: $showLinkedProductsSheet) {
            UserProductsSheetView(
                linkedProducts: linkedProducts,
                userProductsViewState: userProductsViewState,
                onConfirmSelection: { onConfirmLinkedProductsSelection(Array($0)) },
                onClose: { showLinkedProductsSheet = false }
            )
        }
    }
}
