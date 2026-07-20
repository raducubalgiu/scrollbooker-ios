//
//  SearchServicesSheet.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 19.07.2026.
//

import SwiftUI

enum ServicesSheetStep {
    case mainFilters
    case service
    case dateTime
}

struct DateTimeState {
    var startDate: String? = nil
    var startTime: String? = nil
    var endTime: String? = nil
}

struct SearchServicesSheet: View {
    var viewModel: SearchViewModel
    var onClose: () -> Void
    var onFilter: (SearchFilters) -> Void
    
    @State private var localFilters: SearchFilters
    @State private var step: ServicesSheetStep
    
    init(
        viewModel: SearchViewModel,
        onClose: @escaping () -> Void,
        onFilter: @escaping (SearchFilters) -> Void
    ) {
        self.viewModel = viewModel
        self.onClose = onClose
        self.onFilter = onFilter
        
        let initialFilters = viewModel.filters
        self._localFilters = State(initialValue: initialFilters)
        
        if initialFilters.serviceDomainId != nil &&
            initialFilters.serviceDomainId == viewModel.filters.serviceDomainId {
            self._step = State(initialValue: .service)
        } else {
            self._step = State(initialValue: .mainFilters)
        }
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                ZStack {
                    switch step {
                        case .mainFilters:
                            MainFiltersStep(
                                businessDomains: viewModel.businessDomains,
                                selectedBusinessDomainId: localFilters.businessDomainId,
                                onSetSelectedBusinessDomainId: { id in
                                    localFilters.businessDomainId = id
                                },
                                onSetServiceDomain: { domain in
                                    localFilters.serviceDomainId = domain.id
                                    localFilters.serviceId = nil
                                    localFilters.subFilterIds = nil
                                    
                                    withAnimation { step = .service }
                                },
                                onClose: onClose
                            )

                        case .service:
                            ServiceStep(
                                selectedServiceDomain: nil,
                                selectedServiceId: nil,
                                services: [],
                                isLoadingServices: false,
                                selectedSubFilterIds: [],
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
                                    localFilters.serviceDomainId = nil
                                    localFilters.serviceId = nil
                                    localFilters.subFilterIds = nil
                                    
                                    withAnimation(.easeInOut(duration: 0.3)) { step = .mainFilters }
                                }
                            )
                            .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .trailing)))
                            
                        case .dateTime:
                            Spacer()
                        }
                }
                .frame(maxHeight: .infinity)
                
                MainFiltersFooter(
                    isClearEnabled: true,
                    isConfirmEnabled: true,
                    onConfirm: { onFilter(localFilters) },
                    onClear: {
                        localFilters.clear()
                        withAnimation { step = .mainFilters }
                    },
                    onOpenDate: {
                        if step != .dateTime {
                            withAnimation { step = .dateTime }
                        }
                    },
                    onClearDate: {
                        localFilters.startDate = nil
                        localFilters.startTime = nil
                        localFilters.endTime = nil
                    },
                    summary: "Selectează data",
                    isActive: localFilters.startDate != nil
                )

            }
            
            if step == .dateTime {
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
                .transition(.move(edge: .bottom))
                .background(Color(.systemBackground))
            }
        }
    }
}
