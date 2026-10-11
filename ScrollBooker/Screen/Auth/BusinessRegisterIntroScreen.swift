//
//  BusinessRegisterIntroScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 11.10.2026.
//

import SwiftUI

struct BusinessRegisterIntroScreen: View {
    let authViewModel: AuthViewModel

    @Environment(\.dismiss) private var dismiss
    @State private var showRegisterBusiness = false

    private let valueProps = [
        String(localized: "auth_business_intro_value_1"),
        String(localized: "auth_business_intro_value_2"),
        String(localized: "auth_business_intro_value_3"),
    ]

    private let categories = [
        String(localized: "auth_business_intro_category_1"),
        String(localized: "auth_business_intro_category_2"),
        String(localized: "auth_business_intro_category_3"),
        String(localized: "auth_business_intro_category_4"),
        String(localized: "auth_business_intro_category_5"),
        String(localized: "auth_business_intro_category_6"),
    ]

    private let steps: [OnboardingStep] = [
        OnboardingStep(
            title: String(localized: "auth_business_intro_step_1_title"),
            description: String(localized: "auth_business_intro_step_1_description")
        ),
        OnboardingStep(
            title: String(localized: "auth_business_intro_step_2_title"),
            description: String(localized: "auth_business_intro_step_2_description")
        ),
        OnboardingStep(
            title: String(localized: "auth_business_intro_step_3_title"),
            description: String(localized: "auth_business_intro_step_3_description")
        ),
        OnboardingStep(
            title: String(localized: "auth_business_intro_step_4_title"),
            description: String(localized: "auth_business_intro_step_4_description")
        ),
    ]

    var body: some View {
        VStack(spacing: 0) {
            HeaderView(enableBack: true, onBack: { dismiss() })
                .padding(.horizontal, AppSize.base.rawValue)
                .padding(.top, AppSize.xs.rawValue)

            ScrollView {
                VStack(alignment: .leading, spacing: AppSize.xl.rawValue) {
                    Image("business_intro_hero")
                        .resizable()
                        .aspectRatio(1, contentMode: .fit)
                        .frame(maxWidth: .infinity)
                        .clipShape(RoundedRectangle(cornerRadius: 20))

                    VStack(alignment: .leading, spacing: AppSize.xs.rawValue) {
                        Text(String(localized: "auth_business_intro_title"))
                            .font(.largeTitle.bold())

                        Text(String(localized: "auth_business_intro_subtitle"))
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }

                    VStack(alignment: .leading, spacing: AppSize.s.rawValue) {
                        ForEach(valueProps, id: \.self) { item in
                            HStack(alignment: .top, spacing: AppSize.s.rawValue) {
                                ZStack {
                                    Circle()
                                        .fill(Color.primarySB)
                                        .frame(width: 20, height: 20)

                                    Image(systemName: "checkmark")
                                        .font(.system(size: 10, weight: .bold))
                                        .foregroundColor(.white)
                                }
                                .padding(.top, 2)

                                Text(item)
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                            }
                        }
                    }

                    Divider()

                    VStack(alignment: .leading, spacing: AppSize.base.rawValue) {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(String(localized: "auth_business_intro_categories_title"))
                                .font(.title3.bold())

                            Text(String(localized: "auth_business_intro_categories_subtitle"))
                                .font(.footnote)
                                .foregroundColor(.gray)
                        }

                        ServiceCategoryChipsView(categories: categories)
                    }

                    Divider()

                    VStack(alignment: .leading, spacing: AppSize.base.rawValue) {
                        Text(String(localized: "auth_business_intro_steps_title"))
                            .font(.title3.bold())

                        OnboardingStepsView(steps: steps)
                    }
                }
                .padding(.horizontal, AppSize.xl.rawValue)
                .padding(.top, AppSize.base.rawValue)
                .padding(.bottom, AppSize.xl.rawValue)
            }
            .safeAreaInset(edge: .bottom, spacing: 0) {
                VStack(spacing: 0) {
                    MainButton(
                        title: String(localized: "auth_business_intro_cta"),
                        onClick: { showRegisterBusiness = true }
                    )
                }
                .padding(.horizontal, AppSize.xl.rawValue)
                .padding(.top, 12)
                .padding(.bottom, 8)
                .background(
                    Color.backgroundSB.ignoresSafeArea(edges: .bottom)
                )
            }
        }
        .background(Color.backgroundSB)
        .navigationDestination(isPresented: $showRegisterBusiness) {
            RegisterBusinessScreen(authViewModel: authViewModel)
                .toolbar(.hidden, for: .navigationBar)
        }
    }
}
