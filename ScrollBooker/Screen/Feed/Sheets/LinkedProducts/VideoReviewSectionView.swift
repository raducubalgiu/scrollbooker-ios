//
//  VideoReviewSectionView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 17.09.2026.
//

import SwiftUI

/// Shown instead of the regular product list when the post being viewed is a video review —
/// who was reviewed, what was said, the services from that booking, and two next actions
/// (book the same services, or browse everything this business/employee offers). Mirrors
/// Android's VideoReviewSection.kt.
struct VideoReviewSectionView: View {
    let viewModel: LinkedProductsViewModel
    let post: Post
    var onNavigateToUserProfile: (ProfileNavigationParams) -> Void
    let onNavigateToBooking: (BookingNavigationParams) -> Void
    let bookingSource: BookingSourceEnum

    private var provider: ReviewedProvider {
        post.employee.map(ReviewedProvider.init(employee:)) ?? ReviewedProvider(businessOwner: post.businessOwner)
    }

    var body: some View {
        switch viewModel.reviewAppointmentState {
        case .idle, .loading:
            LoadingView()

        case .error(let message):
            ErrorView(message: message) {
                Task { await viewModel.loadReviewAppointment() }
            }

        case .success(let appointment):
            if let review = post.review {
                VStack(spacing: 0) {
                    ScrollView {
                        VStack(alignment: .leading, spacing: AppSize.xl.rawValue) {
                            ProviderCardView(
                                provider: provider,
                                address: post.businessLocation?.formattedAddress,
                                distanceKm: viewModel.reviewDistanceKm,
                                onNavigateToUserProfile: onNavigateToUserProfile
                            )
                            PostReviewCardView(review: review, reviewer: post.user)
                            ServicesCardView(products: appointment.products)
                        }
                        .padding(.horizontal)
                        .padding(.bottom)
                    }

                    VideoReviewActionsView(
                        providerFullName: provider.fullName,
                        onBook: {
                            onNavigateToBooking(
                                BookingNavigationParams(
                                    businessId: appointment.business.id,
                                    userId: appointment.user.id ?? appointment.business.businessOwnerId,
                                    businessOwnerId: appointment.business.businessOwnerId,
                                    source: bookingSource,
                                    selectedProductId: nil
                                )
                            )
                        },
                        onExploreServices: {
                            guard let businessId = post.businessId else { return }
                            onNavigateToBooking(
                                BookingNavigationParams(
                                    businessId: businessId,
                                    userId: provider.id,
                                    businessOwnerId: appointment.business.businessOwnerId,
                                    source: bookingSource,
                                    selectedProductId: nil
                                )
                            )
                        }
                    )
                }
            } else {
                ErrorView(message: String(localized: "message_error_something_went_wrong")) {
                    Task { await viewModel.loadReviewAppointment() }
                }
            }
        }
    }
}

private struct ReviewedProvider {
    let id: Int
    let fullName: String
    let avatar: String?
    let profession: String
    let username: String
    let ratingsAverage: Float
    let ratingsCount: Int

    var avatarURL: URL? { avatar.flatMap(URL.init(string:)) }

    init(employee: PostEmployee) {
        id = employee.id
        fullName = employee.fullName
        avatar = employee.avatar
        profession = employee.profession
        username = employee.username
        ratingsAverage = employee.ratingsAverage
        ratingsCount = employee.ratingsCount
    }

    init(businessOwner: PostBusinessOwner) {
        id = businessOwner.id
        fullName = businessOwner.fullName
        avatar = businessOwner.avatar
        profession = businessOwner.profession
        username = businessOwner.username
        ratingsAverage = businessOwner.ratingsAverage
        ratingsCount = businessOwner.ratingsCount
    }
}

private struct ProviderCardView: View {
    let provider: ReviewedProvider
    let address: String?
    let distanceKm: Double?
    let onNavigateToUserProfile: (ProfileNavigationParams) -> Void

    private var locationText: String? {
        guard let address, !address.isEmpty else { return nil }
        guard let distanceKm else { return address }
        return "\(String(format: "%.1f", distanceKm))km • \(address)"
    }

    var body: some View {
        SectionCardView {
            Text(String(localized: "reviewFor"))
                .font(.footnote)
                .foregroundColor(.gray)

            HStack(spacing: AppSize.m.rawValue) {
                AvatarWithRatingView(
                    url: provider.avatarURL,
                    rating: provider.ratingsAverage,
                    size: .l,
                    onClick: {
                        onNavigateToUserProfile(
                            ProfileNavigationParams(userId: provider.id, username: provider.username)
                        )
                    }
                )

                VStack(alignment: .leading, spacing: 2) {
                    Text(provider.fullName)
                        .font(.subheadline.bold())
                        .lineLimit(1)

                    Text("\(provider.profession) • \(provider.ratingsCount) \(String(localized: "reviews"))")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .lineLimit(1)
                }
            }

            if let locationText {
                Divider()

                HStack(spacing: AppSize.s.rawValue) {
                    Image(systemName: "location")
                        .foregroundColor(.gray)

                    Text(locationText)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .lineLimit(2)
                }
            }
        }
    }
}

private struct PostReviewCardView: View {
    let review: PostReview
    let reviewer: PostUser

    var body: some View {
        SectionCardView {
            Text(String(localized: "review"))
                .font(.subheadline.bold())

            HStack(spacing: AppSize.s.rawValue) {
                AvatarView(imageURL: reviewer.avatarURL, size: .xs)

                Text(reviewer.fullName)
                    .font(.subheadline.bold())
                    .lineLimit(1)
            }

            HStack(spacing: AppSize.s.rawValue) {
                StarRatingView(rating: Double(review.rating), imageScale: .small)

                Text("\(Float(review.rating).formatRating()) \(String(localized: "from5"))")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            if let text = review.review, !text.isEmpty {
                Text(text)
                    .font(.subheadline)
            }
        }
    }
}

private struct ServicesCardView: View {
    let products: [AppointmentProduct]

    var body: some View {
        SectionCardView {
            Text(String(localized: "bookedServices"))
                .font(.subheadline.bold())

            ForEach(Array(products.enumerated()), id: \.offset) { index, product in
                AppointmentProductPrice(
                    name: product.name,
                    price: product.price,
                    priceWithDiscount: product.priceWithDiscount,
                    discount: product.discount,
                    currencyName: product.currency.name
                )

                if index < products.count - 1 {
                    Divider()
                }
            }
        }
    }
}

private struct SectionCardView<Content: View>: View {
    @ViewBuilder var content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: AppSize.m.rawValue) {
            content()
        }
        .padding(.base)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.surfaceSB)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

// Pinned below the scrollable content: the two things a viewer can actually do here — book the
// same services, or browse everything this business/employee offers. No price/total here, this
// isn't a checkout screen.
private struct VideoReviewActionsView: View {
    let providerFullName: String
    let onBook: () -> Void
    let onExploreServices: () -> Void

    var body: some View {
        VStack(spacing: AppSize.s.rawValue) {
            Divider()

            MainButton(title: String(localized: "bookSameServices"), onClick: onBook)

            Button(action: onExploreServices) {
                Text(String(format: String(localized: "seeAllServicesFrom"), providerFullName))
                    .font(.subheadline.bold())
                    .foregroundColor(.primarySB)
            }
            .buttonStyle(.plain)
            .padding(.bottom, .s)
        }
        .padding(.horizontal, .base)
    }
}
