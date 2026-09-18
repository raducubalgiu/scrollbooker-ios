//
//  EditProfileScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 26.08.2025.
//

import SwiftUI

private struct EditProfileAction: Identifiable {
    let id = UUID()
    let title: String
    let value: String
    var permission: PermissionEnum = .noProtection
    let onClick: () -> Void
}

struct EditProfileScreen: View {
    let viewModel: MyProfileViewModel
    var onNavigate: (Route) -> Void
    var onBack: () -> Void

    @Environment(SessionManager.self) private var session
    @State private var showChoosePhotoSheet = false

    private var formattedBirthdate: String {
        guard let raw = viewModel.profileController.profile?.dateOfBirth, !raw.isEmpty else { return "" }

        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withFullDate]
        guard let date = isoFormatter.date(from: raw) else { return raw }

        return date.asFormattedString(format: "d MMMM yyyy")
    }

    private var aboutActions: [EditProfileAction] {
        [
            EditProfileAction(
                title: String(localized: "name"),
                value: viewModel.profileController.profile?.fullName ?? "",
                onClick: { onNavigate(.editFullName) }
            ),
            EditProfileAction(
                title: String(localized: "username"),
                value: viewModel.profileController.profile?.username ?? "",
                onClick: { onNavigate(.editUsername) }
            ),
            EditProfileAction(
                title: String(localized: "biography"),
                value: viewModel.profileController.profile?.bio ?? "",
                onClick: { onNavigate(.editBio) }
            ),
            EditProfileAction(
                title: String(localized: "gender"),
                value: GenderTypeEnum.fromKey(viewModel.profileController.profile?.gender ?? "")?.label ?? "",
                permission: .genderEdit,
                onClick: { onNavigate(.editGender) }
            ),
            EditProfileAction(
                title: String(localized: "dateOfBirth"),
                value: formattedBirthdate,
                permission: .birthdateEdit,
                onClick: { onNavigate(.editBirthdate) }
            )
        ]
    }

    private var visibleAboutActions: [EditProfileAction] {
        aboutActions.filter { $0.permission == .noProtection || session.hasPermission($0.permission) }
    }

    var body: some View {
        VStack {
            HeaderView(
                title: String(localized: "editProfile"),
                onBack: onBack
            )

            EditProfileAvatarView(
                avatarURL: viewModel.profileController.profile?.avatarURL,
                onClick: { showChoosePhotoSheet = true }
            )

            VStack(alignment: .leading) {
                Text(String(localized: "aboutYou"))
                    .font(.subheadline.bold())
                    .foregroundColor(.gray)
                    .padding(.top, .base)

                ForEach(visibleAboutActions) { action in
                    Button {
                        action.onClick()
                    } label: {
                        HStack {
                            Text(action.title)
                                .font(.subheadline.bold())
                                .foregroundColor(.onBackgroundSB)

                            Spacer()

                            HStack {
                                Text(action.value)
                                    .font(.subheadline.bold())
                                    .foregroundColor(.gray)
                                    .lineLimit(1)
                                    .truncationMode(.tail)

                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.vertical, .m)
                    }
                }

                Spacer()
            }
            .padding(.horizontal)
        }
        .sheet(isPresented: $showChoosePhotoSheet) {
            ChoosePhotoSheetView(onPickImage: { data in
                showChoosePhotoSheet = false
                viewModel.pickedAvatarData = data
                onNavigate(.editAvatarCrop)
            })
        }
    }
}
