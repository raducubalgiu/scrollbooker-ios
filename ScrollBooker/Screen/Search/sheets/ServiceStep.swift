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
        var list = [Option(value: "0", name: "Toate serviciile")]
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
                
                Spacer().frame(height: 16)
                
                VStack(alignment: .leading, spacing: 16) {
                    InputSelectPlaceholder(
                        options: services != nil ? serviceOptions : [],
                        selectedOption: selectedServiceId != nil ? String(selectedServiceId!) : "0",
                        placeholder: "Alege un serviciu",
                        label: "Serviciu",
                        isLoading: isLoadingServices,
                        onValueChange: { newValue in
                            let parsedId = Int(newValue)
                            onChangeService(parsedId == 0 ? nil : parsedId)
                        }
                    )
                    
                    if let service = selectedService {
                        let filteredFilters = service.filters.filter { $0.type != .range }
                        
                        SearchAdvancedFilters(
                            selectedSubFilterIds: selectedSubFilterIds,
                            filters: filteredFilters,
                            onSetSelectedFilter: onChangeFilter
                        )
                        .transition(.opacity.combined(with: .move(edge: .top)))
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical, 8) // SpacingS
        }
    }
}

struct ServiceStepHeader: View {
    var onBack: () -> Void
    var serviceDomainName: String?
    var serviceDomainUrl: String?
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: onBack) {
                    Image(systemName: "arrow.backward")
                        .font(.title2)
                        .foregroundColor(.primary)
                        .frame(width: 60, height: 60)
                }
                
                Text("Filtrare avansată") // R.string.advancedFiltering
                    .font(.headline)
                    .bold()
                
                Spacer()
            }
            
            // Imaginea rotundă de categorie și Titlul Central
            VStack(alignment: .center, spacing: 16) {
                ZStack {
                    Circle()
                        .fill(Color(.systemGray6)) // SurfaceBG
                        .frame(width: 130, height: 130)
                    
                    if let urlString = serviceDomainUrl, let url = URL(string: urlString) {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 130, height: 130)
                                    .clipShape(Circle())
                            default:
                                EmptyView()
                            }
                        }
                    }
                }
                .padding(.horizontal)
                
                Text(serviceDomainName ?? "")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

struct SearchAdvancedFilters: View {
    var selectedSubFilterIds: [Int]?
    let filters: [Filter]
    var onSetSelectedFilter: (Int) -> Void
    
    var body: some View {
        // Se randează doar dacă există filtre în listă
        if !filters.isEmpty {
            VStack(alignment: .leading, spacing: 16) {
                Text("Filtre") // R.string.filters
                    .font(.headline)
                    .foregroundColor(.primary)
                
                ForEach(filters) { filter in
                    let options = filter.subFilters.map {
                        Option(value: String($0.id), name: $0.name, description: $0.description)
                    }
                    
                    // Găsim dacă un sub-filtru din acest grup este deja selectat
                    let activeSubFilter = filter.subFilters.first { sub in
                        selectedSubFilterIds?.contains(sub.id) ?? false
                    }
                    
                    InputSelectPlaceholder(
                        options: options,
                        selectedOption: activeSubFilter != nil ? String(activeSubFilter!.id) : "",
                        placeholder: filter.name,
                        label: filter.name,
                        isLoading: false,
                        onValueChange: { newValue in
                            if let subId = Int(newValue) {
                                onSetSelectedFilter(subId)
                            }
                        }
                    )
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.systemGray6)) // SurfaceBG
            .cornerRadius(16)
            .animation(.default, value: filters.count) // Replică animateContentSize()
        }
    }
}

// MARK: - Placeholder pentru InputSelect (Până îl implementezi pe cel real)
struct InputSelectPlaceholder: View {
    let options: [Option]
    let selectedOption: String
    let placeholder: String
    let label: String
    var isLoading: Bool = false
    var onValueChange: (String) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.caption)
                .foregroundColor(.gray)
            
            HStack {
                if isLoading {
                    ProgressView()
                        .scaleEffect(0.8)
                } else {
                    let selectedName = options.first(where: { $0.value == selectedOption })?.name
                    Text(selectedName ?? placeholder)
                        .foregroundColor(selectedName != nil ? .primary : .gray)
                }
                Spacer()
                Image(systemName: "chevron.down")
                    .foregroundColor(.gray)
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(8)
            .onTapGesture {
                // Simulare simplă: Când dai click, alege prima opțiune din listă (în afară de default) care nu e deja selectată
                if let nextOption = options.first(where: { $0.value != "0" && $0.value != selectedOption }) {
                    onValueChange(nextOption.value)
                } else if let first = options.first {
                    onValueChange(first.value)
                }
            }
        }
    }
}

