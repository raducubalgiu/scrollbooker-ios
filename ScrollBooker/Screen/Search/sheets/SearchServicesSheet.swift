//
//  SearchServicesSheet.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 19.07.2026.
//

import SwiftUI

struct SearchServicesSheet: View {
    var viewModel: SearchViewModel
    var onClose: () -> Void
    var onFilter: (SearchFilters) -> Void

    @State private var localFilters: SearchFilters
    @State private var step: ServicesSheetStep

    private var selectedServiceDomain: ServiceDomain? {
        guard let serviceDomainId = localFilters.serviceDomainId else { return nil }
        return viewModel.businessDomains
            .flatMap { $0.serviceDomains }
            .first { $0.id == serviceDomainId }
    }

    init(
        viewModel: SearchViewModel,
        onClose: @escaping () -> Void,
        onFilter: @escaping (SearchFilters) -> Void
    ) {
        self.viewModel = viewModel
        self.onClose = onClose
        self.onFilter = onFilter

        self._localFilters = State(initialValue: viewModel.filters)
        self._step = State(initialValue: .mainFilters)
    }

    private var serviceSelectionSummary: String {
        guard let domain = selectedServiceDomain else {
            return String(localized: "chooseAService")
        }

        if let serviceId = localFilters.serviceId,
           let serviceName = viewModel.servicesState.data?.first(where: { $0.id == serviceId })?.name {
            return "\(domain.name) – \(serviceName)"
        }

        return domain.name
    }

    private var isMainFiltersClearEnabled: Bool {
        localFilters != SearchFilters()
    }

    private var isMainFiltersConfirmEnabled: Bool {
        localFilters != viewModel.filters
    }

    private var isServiceClearEnabled: Bool {
        localFilters.serviceDomainId != nil
    }

    private var isServiceConfirmEnabled: Bool {
        localFilters.serviceDomainId != viewModel.filters.serviceDomainId ||
        localFilters.serviceId != viewModel.filters.serviceId ||
        localFilters.subFilterIds != viewModel.filters.subFilterIds
    }

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                switch step {
                    case .mainFilters:
                        MainFiltersStep(
                            businessDomains: viewModel.businessDomains,
                            recentSearchesState: viewModel.recentSearchesState,
                            onSetServiceDomain: { domain in
                                localFilters.serviceDomainId = domain.id
                                localFilters.serviceId = nil
                                localFilters.subFilterIds = nil

                                withAnimation(.easeInOut(duration: 0.3)) { step = .service }

                                Task {
                                    await viewModel.loadServices(serviceDomainId: domain.id)
                                }
                            },
                            onSelectRecentSearch: { recentSearch in
                                var updatedFilters = localFilters
                                updatedFilters.businessDomainId = recentSearch.businessDomainId
                                updatedFilters.serviceDomainId = recentSearch.serviceDomain.id
                                updatedFilters.serviceId = recentSearch.services.first?.id

                                let subFilterIds = recentSearch.services.first?.filters
                                    .flatMap { $0.subFilters }
                                    .map { $0.id }
                                updatedFilters.subFilterIds = (subFilterIds?.isEmpty ?? true) ? nil : subFilterIds

                                onFilter(updatedFilters)
                            },
                            onClose: onClose
                        )
                        .background(Color(.systemBackground))
                        .transition(.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .leading)))

                    case .service:
                        ServiceStep(
                            selectedServiceDomain: selectedServiceDomain,
                            selectedServiceId: localFilters.serviceId,
                            services: viewModel.servicesState.data,
                            isLoadingServices: viewModel.servicesState == .loading,
                            selectedSubFilterIds: localFilters.subFilterIds,
                            onChangeFilter: { subFilterId in
                                var currentFilters = localFilters.subFilterIds ?? []
                                if currentFilters.contains(subFilterId) {
                                    currentFilters.removeAll(where: { $0 == subFilterId })
                                } else {
                                    currentFilters.append(subFilterId)
                                }
                                localFilters.subFilterIds = currentFilters.isEmpty ? nil : currentFilters
                            },
                            onChangeService: { newServiceId in
                                localFilters.serviceId = newServiceId
                                localFilters.subFilterIds = nil
                            },
                            onBack: {
                                withAnimation(.easeInOut(duration: 0.3)) { step = .mainFilters }
                            }
                        )
                        .background(Color(.systemBackground))
                        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .trailing)))

                    case .dateTime:
                        DateTimeStep(
                            state: DateTimeState(
                                startDate: localFilters.startDate,
                                startTime: localFilters.startTime,
                                endTime: localFilters.endTime,
                            ),
                            onBack: {
                                withAnimation(.easeInOut(duration: 0.3)) { step = .mainFilters }
                            },
                            onConfirm: { updatedState in
                                localFilters.startDate = updatedState.startDate
                                localFilters.startTime = updatedState.startTime
                                localFilters.endTime = updatedState.endTime

                                withAnimation(.easeInOut(duration: 0.3)) { step = .mainFilters }
                            }
                        )
                        .background(Color(.systemBackground))
                        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .trailing)))
                    }
            }
            .frame(maxHeight: .infinity)

            switch step {
                case .mainFilters:
                    MainFiltersFooter(
                        isClearEnabled: isMainFiltersClearEnabled,
                        isConfirmEnabled: isMainFiltersConfirmEnabled,
                        onConfirm: { onFilter(localFilters) },
                        onClear: {
                            localFilters.clear()
                            viewModel.resetServicesState()
                            withAnimation(.easeInOut(duration: 0.3)) { step = .mainFilters }
                        },
                        serviceSummary: serviceSelectionSummary,
                        isServiceActive: selectedServiceDomain != nil,
                        onOpenService: {
                            withAnimation(.easeInOut(duration: 0.3)) { step = .service }

                            if let domainId = localFilters.serviceDomainId, viewModel.servicesState == .idle {
                                Task { await viewModel.loadServices(serviceDomainId: domainId) }
                            }
                        },
                        onClearService: {
                            localFilters.serviceDomainId = nil
                            localFilters.serviceId = nil
                            localFilters.subFilterIds = nil
                            viewModel.resetServicesState()
                        },
                        dateTimeSummary: localFilters.dateTimeSummary,
                        isDateTimeActive: localFilters.startDate != nil,
                        onOpenDateTime: {
                            withAnimation(.easeInOut(duration: 0.3)) { step = .dateTime }
                        },
                        onClearDateTime: {
                            localFilters.startDate = nil
                            localFilters.startTime = nil
                            localFilters.endTime = nil
                        }
                    )
                case .service:
                    ServiceStepFooter(
                        isClearEnabled: isServiceClearEnabled,
                        isConfirmEnabled: isServiceConfirmEnabled,
                        onClear: {
                            localFilters.serviceDomainId = nil
                            localFilters.serviceId = nil
                            localFilters.subFilterIds = nil
                            viewModel.resetServicesState()
                            withAnimation(.easeInOut(duration: 0.3)) { step = .mainFilters }
                        },
                        onConfirm: {
                            withAnimation(.easeInOut(duration: 0.3)) { step = .mainFilters }
                        }
                    )
                case .dateTime:
                    EmptyView()
            }
        }
        .task {
            await viewModel.loadBusinessDomainsIfNeeded()
            await viewModel.loadRecentSearchesIfNeeded()
        }
    }
}
