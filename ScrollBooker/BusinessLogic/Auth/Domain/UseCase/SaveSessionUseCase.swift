//
//  SaveSessionUseCase.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.09.2026.
//

/// Orchestrează salvarea unei sesiuni noi după un login/register reușit:
/// persistă token-urile, apoi încarcă profilul și permisiunile utilizatorului
/// și le scrie în cache-ul local (folosit ulterior pentru bootstrap offline).
final class SaveSessionUseCase {
    private let store: AuthStore
    private let getUserInfoUseCase: GetUserInfoUseCase
    private let getUserPermissionsUseCase: GetUserPermissionsUseCase

    init(
        store: AuthStore,
        getUserInfoUseCase: GetUserInfoUseCase,
        getUserPermissionsUseCase: GetUserPermissionsUseCase
    ) {
        self.store = store
        self.getUserInfoUseCase = getUserInfoUseCase
        self.getUserPermissionsUseCase = getUserPermissionsUseCase
    }

    @discardableResult
    func callAsFunction(authResponse: AuthResponse) async throws -> UserInfo {
        await store.refreshTokens(
            accessToken: authResponse.accessToken,
            refreshToken: authResponse.refreshToken
        )

        let userInfo = try await getUserInfoUseCase()
        let permissions = try await getUserPermissionsUseCase()

        await store.storeUserSession(
            accessToken: authResponse.accessToken,
            refreshToken: authResponse.refreshToken,
            userInfo: userInfo,
            permissions: permissions.map(\.code)
        )

        return userInfo
    }
}
