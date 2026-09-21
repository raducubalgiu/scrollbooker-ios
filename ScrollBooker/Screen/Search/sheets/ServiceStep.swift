//
//  ServiceStep.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 20.07.2026.
//

import SwiftUI

struct Option: Identifiable {
    let id = UUID()
    let value: String
    let name: String
    var description: String? = nil
}

struct ServiceStep: View {
    var selectedServiceDomain: ServiceDomain?
    var selectedServiceId: Int?
    var services: [ServiceWithFilters]?
    var isLoadingServices: Bool
    var selectedSubFilterIds: [Int]?

    var onChangeFilter: (Int) -> Void
    var onChangeService: (Int?) -> Void
    var onBack: () -> Void

    private var selectedService: ServiceWithFilters? {
        services?.first(where: { $0.id == selectedServiceId })
    }

    private var serviceOptions: [Option] {
        var list = [Option(value: "0", name: String(localized: "allServices"))]
        if let servicesList = services {
            list.append(contentsOf: servicesList.map {
                Option(value: String($0.id), name: $0.name)
            })
        }
        return list
    }

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                ServiceStepHeader(
                    onBack: onBack,
                    serviceDomainName: selectedServiceDomain?.name,
                    serviceDomainUrl: selectedServiceDomain?.thumbnailUrl
                )

                VStack(alignment: .leading, spacing: AppSize.base.rawValue) {
                    InputSelectPlaceholder(
                        options: services != nil ? serviceOptions : [],
                        selectedOption: selectedServiceId != nil ? String(selectedServiceId!) : "0",
                        placeholder: String(localized: "chooseAService"),
                        label: String(localized: "service"),
                        isLoading: isLoadingServices,
                        onValueChange: { newValue in
                            let parsedId = Int(newValue)
                            onChangeService(parsedId == 0 ? nil : parsedId)
                        }
                    )

                    if let service = selectedService {
                        let filteredFilters = service.filters

                        SearchAdvancedFilters(
                            selectedSubFilterIds: selectedSubFilterIds,
                            filters: filteredFilters,
                            onSetSelectedFilter: onChangeFilter
                        )
                        .transition(.opacity.combined(with: .move(edge: .top)))
                    }
                }
                .padding(.horizontal, .base)
                .padding(.top, AppSize.xl.rawValue)
                .animation(.easeInOut(duration: 0.2), value: selectedService?.id)
            }
            .padding(.bottom, AppSize.xxl.rawValue)
        }
    }
}

struct ServiceStepHeader: View {
    var onBack: () -> Void
    var serviceDomainName: String?
    var serviceDomainUrl: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(action: onBack) {
                Image(systemName: "arrow.backward")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.primary)
                    .padding(10)
                    .clipShape(Circle())
            }
            .padding(.horizontal, .base)
            .padding(.top, .base)
            .padding(.bottom, .s)

            VStack(alignment: .leading, spacing: AppSize.base.rawValue) {
                ZStack {
                    RoundedRectangle(cornerRadius: 28)
                        .fill(Color.surfaceSB)

                    if let urlString = serviceDomainUrl, let url = URL(string: urlString) {
                        AsyncImage(url: url) { phase in
                            if case .success(let image) = phase {
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(minWidth: 0, maxWidth: .infinity)
                            }
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 28))
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 160)
                .clipped()

                Text(serviceDomainName ?? "")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.onBackgroundSB)
            }
            .padding(.horizontal, .base)
        }
    }
}

struct SearchAdvancedFilters: View {
    var selectedSubFilterIds: [Int]?
    let filters: [Filter]
    var onSetSelectedFilter: (Int) -> Void

    var body: some View {
        if !filters.isEmpty {
            VStack(alignment: .leading, spacing: AppSize.base.rawValue) {
                Text(String(localized: "filters"))
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.onBackgroundSB)

                VStack(spacing: AppSize.base.rawValue) {
                    ForEach(filters) { filter in
                        let options = filter.subFilters.map {
                            Option(value: String($0.id), name: $0.name, description: $0.description)
                        }

                        let activeSubFilter = filter.subFilters.first { sub in
                            selectedSubFilterIds?.contains(sub.id) ?? false
                        }

                        InputSelectPlaceholder(
                            options: options,
                            selectedOption: activeSubFilter != nil ? String(activeSubFilter!.id) : "",
                            placeholder: filter.name,
                            label: filter.name,
                            isLoading: false,
                            backgroundColor: .backgroundSB,
                            onValueChange: { newValue in
                                if let subId = Int(newValue) {
                                    onSetSelectedFilter(subId)
                                }
                            }
                        )
                    }
                }
            }
            .padding(AppSize.base.rawValue)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.surfaceSB)
            )
            .animation(.default, value: filters.count)
        }
    }
}

struct InputSelectPlaceholder: View {
    let options: [Option]
    let selectedOption: String
    let placeholder: String
    let label: String
    var isLoading: Bool = false
    var backgroundColor: Color = .surfaceSB
    var onValueChange: (String) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: AppSize.xs.rawValue) {
            Text(label)
                .font(.subheadline)
                .foregroundColor(.gray)

            if isLoading {
                HStack {
                    ProgressView()
                        .scaleEffect(0.8)
                    Spacer()
                }
                .padding(.base)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(backgroundColor)
                )
            } else {
                Menu {
                    ForEach(options) { option in
                        Button(action: { onValueChange(option.value) }) {
                            Text(option.name)
                        }
                    }
                } label: {
                    HStack {
                        let selectedName = options.first(where: { $0.value == selectedOption })?.name
                        Text(selectedName ?? placeholder)
                            .font(.body)
                            .foregroundColor(selectedName != nil ? .onBackgroundSB : .gray)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .font(.footnote)
                            .fontWeight(.semibold)
                            .foregroundColor(.gray)
                    }
                    .padding(.base)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(backgroundColor)
                    )
                }
                .buttonStyle(.plain)
            }
        }
    }
}
