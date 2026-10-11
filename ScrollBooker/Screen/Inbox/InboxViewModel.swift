//
//  InboxViewModel.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 05.09.2025.
//

import Foundation
import Observation
import OSLog

@Observable
@MainActor
final class InboxViewModel {
    private(set) var viewState: FeatureState<[Notification]> = .idle
    private(set) var isPaging: Bool = false
    var isRefreshing: Bool = false

    private(set) var employmentRequestState: FeatureState<EmploymentRequest> = .idle
    private(set) var consentState: FeatureState<Consent> = .idle
    var agreedTerms: Bool = false
    var isSaving: Bool = false
    private var employmentRequestId: Int?

    private let session: SessionManager
    private let getUserNotifications: GetUserNotificationsUseCase
    private let getEmploymentRequestByIdUseCase: GetEmploymentRequestByIdUseCase
    private let respondEmploymentRequestUseCase: RespondEmploymentRequestUseCase
    private let getConsentByNameUseCase: GetConsentByNameUseCase
    private let refreshSessionUseCase: RefreshSessionUseCase
    private let saveSessionUseCase: SaveSessionUseCase
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "App", category: "Inbox")

    private var page = 1
    private let limit = 20
    private var totalCount = 0

    var hasMore: Bool {
        let currentCount = viewState.data?.count ?? 0
        return currentCount < totalCount
    }

    init(
        session: SessionManager,
        getUserNotifications: GetUserNotificationsUseCase,
        getEmploymentRequestByIdUseCase: GetEmploymentRequestByIdUseCase,
        respondEmploymentRequestUseCase: RespondEmploymentRequestUseCase,
        getConsentByNameUseCase: GetConsentByNameUseCase,
        refreshSessionUseCase: RefreshSessionUseCase,
        saveSessionUseCase: SaveSessionUseCase
    ) {
        self.session = session
        self.getUserNotifications = getUserNotifications
        self.getEmploymentRequestByIdUseCase = getEmploymentRequestByIdUseCase
        self.respondEmploymentRequestUseCase = respondEmploymentRequestUseCase
        self.getConsentByNameUseCase = getConsentByNameUseCase
        self.refreshSessionUseCase = refreshSessionUseCase
        self.saveSessionUseCase = saveSessionUseCase
    }

    func initialLoadIfNeeded() async {
        guard viewState.data == nil else { return }
        await load(isFirstPage: true)
    }

    func refresh() async {
        guard !isRefreshing else { return }
        isRefreshing = true
        page = 1

        await load(isFirstPage: true)

        isRefreshing = false
    }

    func loadMoreIfNeeded(currentNotification: Notification?) async {
        let currentData = viewState.data ?? []

        guard hasMore, !isPaging, !isRefreshing, viewState != .loading else { return }

        guard let current = currentNotification,
              current.id == currentData.last?.id
        else { return }

        isPaging = true
        await load(isFirstPage: false)
        isPaging = false
    }

    private func load(isFirstPage: Bool) async {
        if isFirstPage && !isRefreshing {
            viewState = .loading
        }

        do {
            let response = try await getUserNotifications(page: page, limit: limit)
            let existingData = viewState.data ?? []
            let newData: [Notification]

            if isFirstPage {
                newData = response.results
            } else {
                let existingIds = Set(existingData.map(\.id))
                let uniqueItems = response.results.filter { !existingIds.contains($0.id) }
                newData = existingData + uniqueItems
            }

            totalCount = response.count
            page += 1

            viewState = .success(newData)

        } catch {
            let message = logger.userMessage(for: error, context: "Loading Inbox (FirstPage: \(isFirstPage))")

            if isFirstPage {
                viewState = .error(message)
            }
        }
    }

    func setEmploymentId(_ employmentId: Int) {
        guard self.employmentRequestId != employmentId else { return }
        self.employmentRequestId = employmentId
        self.employmentRequestState = .idle
    }

    func loadEmploymentRequest() async {
        guard let employmentId = employmentRequestId else {
            logger.error("ERROR: Employment Id is not defined")
            return
        }

        guard employmentRequestState.data == nil else { return }
        guard employmentRequestState != .loading else { return }

        employmentRequestState = .loading

        do {
            let request = try await withLoading {
                try await self.getEmploymentRequestByIdUseCase(employmentId: employmentId)
            }
            employmentRequestState = .success(request)
        } catch {
            employmentRequestState = .error(logger.userMessage(for: error, context: "Fetching Employment Request"))
        }
    }

    func loadConsent() async {
        guard consentState.data == nil else { return }
        guard consentState != .loading else { return }

        consentState = .loading

        do {
            let consent = try await withLoading {
                try await self.getConsentByNameUseCase(consentName: .employmentRequestsAcceptance)
            }
            consentState = .success(consent)
        } catch {
            consentState = .error(logger.userMessage(for: error, context: "Fetching Consent"))
        }
    }

    func setAgreed() {
        agreedTerms.toggle()
    }

    func respondToRequest(status: EmploymentRequestStatusEnum) async -> Result<Void, Error> {
        guard let employmentId = employmentRequestId else {
            return .failure(EmploymentRespondError.missingEmploymentId)
        }

        isSaving = true

        do {
            _ = try await withLoading {
                try await self.respondEmploymentRequestUseCase(status: status, employmentId: employmentId)
            }
        } catch {
            logger.error("ERROR: on Responding Employment Request: \(error.localizedDescription, privacy: .public)")
            isSaving = false
            return .failure(error)
        }

        if status == .accepted {
            do {
                guard let refreshToken = session.auth.refreshToken, !refreshToken.isEmpty else {
                    throw APIError.unauthorized
                }

                let authResponse = try await withLoading {
                    try await self.refreshSessionUseCase(refreshToken: refreshToken)
                }
                let freshUserInfo = try await self.saveSessionUseCase(authResponse: authResponse)
                session.setAuthenticated(freshUserInfo)
            } catch {
                logger.error("ERROR: Session could not be refreshed after accepting employment: \(error.localizedDescription, privacy: .public)")
                isSaving = false
                return .failure(error)
            }
        }

        await refresh()
        isSaving = false

        return .success(())
    }
}

enum EmploymentRespondError: LocalizedError {
    case missingEmploymentId

    var errorDescription: String? {
        switch self {
        case .missingEmploymentId: return "Employment Id is not defined"
        }
    }
}
