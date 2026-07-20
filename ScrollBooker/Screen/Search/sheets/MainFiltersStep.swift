//
//  MainFiltersStep.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 20.07.2026.
//

import SwiftUI

struct SearchRecent: Identifiable {
    let id: Int
    let name: String
    let description: String
}

struct MainFiltersStep: View {
    var businessDomains: [BusinessDomain]
    var selectedBusinessDomainId: Int?
    var onSetSelectedBusinessDomainId: (Int?) -> Void
    var onSetServiceDomain: (ServiceDomain) -> Void
    var onClose: () -> Void
    
    @State private var currentPageIndex: Int = 0
    
    private let recentSearches = [
        SearchRecent(id: 1, name: "Tuns", description: "Barbati"),
        SearchRecent(id: 1, name: "Consultatie veterinara", description: "Caini • Mascul"),
        SearchRecent(id: 2, name: "Vopsit", description: "Barbati"),
        SearchRecent(id: 3, name: "ITP", description: "Autoturisme"),
        SearchRecent(id: 3, name: "Consultatie stomatologica", description: "Adult")
    ]
    
    private var fullDomainList: [BusinessDomain] {
        let allDomain = BusinessDomain(
            id: 0,
            name: "Toate",
            shortName: "Toate",
            serviceDomains: [],
            businessTypes: []
        )
        return [allDomain] + businessDomains
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Spacer()
                Button(action: onClose) {
                    Image(systemName: "xmark")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.primary)
                        .padding(10)
                        .clipShape(Circle())
                }
            }
            .padding()
            
            Text("Servicii")
                .font(.largeTitle)
                .bold()
                .padding(.horizontal)
            
            Spacer().frame(height: 16)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(Array(fullDomainList.enumerated()), id: \.element.id) { index, bd in
                        let isSelected = selectedBusinessDomainId == bd.id || (selectedBusinessDomainId == nil && bd.id == 0)
                        
                        Text(bd.shortName)
                            .font(.system(size: 15, weight: .medium))
                            .padding(.horizontal, 22)
                            .padding(.vertical, 10)
                            .background(isSelected ? Color.primarySB : Color.surfaceSB)
                            .foregroundColor(isSelected ? Color.onPrimarySB : Color.onSurfaceSB)
                            .cornerRadius(12)
                            .onTapGesture {
                                onSetSelectedBusinessDomainId(bd.id == 0 ? nil : bd.id)
                                withAnimation {
                                    currentPageIndex = index
                                }
                            }
                    }
                }
                .padding(.horizontal)
            }
            .padding(.bottom, 8)
            
            TabView(selection: $currentPageIndex) {
                ForEach(Array(fullDomainList.enumerated()), id: \.element.id) { index, bd in
                    if index == 0 {
                        ScrollView(.vertical, showsIndicators: false) {
                            recentSearchesListView
                        }
                        .tag(index)
                    } else {
                        ServiceDomainsList(
                            serviceDomains: bd.serviceDomains,
                            onSetServiceDomain: onSetServiceDomain
                        )
                        .tag(index)
                    }
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .gesture(DragGesture())
            .onChange(of: selectedBusinessDomainId) { _, newValue in
                if let newId = newValue, let targetIndex = fullDomainList.firstIndex(where: { $0.id == newId }) {
                    currentPageIndex = targetIndex
                } else {
                    currentPageIndex = 0
                }
            }
        }
    }
    
    private var recentSearchesListView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Cautari recente")
                .font(.headline)
                .bold()
                .padding(.top, 16)
                .padding(.horizontal)
            
            ForEach(Array(recentSearches.enumerated()), id: \.offset) { _, search in
                HStack(spacing: 16) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(search.name)
                            .font(.system(size: 16, weight: .semibold))
                        Text(search.description)
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }
                    Spacer()
                }
                .padding(.horizontal)
            }
        }
    }
}

struct ServiceDomainsList: View {
    var serviceDomains: [ServiceDomain]
    var onSetServiceDomain: (ServiceDomain) -> Void
    
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(serviceDomains) { domain in
                    ServiceDomainCard(
                        name: domain.name,
                        thumbnailUrl: domain.thumbnailUrl,
                        onClick: { onSetServiceDomain(domain) }
                    )
                }
            }
            .padding(16)
        }
    }
}


struct ServiceDomainCard: View {
    let name: String
    let thumbnailUrl: String?
    var onClick: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray6))
                    .frame(height: 120)
                
                if let urlString = thumbnailUrl, let url = URL(string: urlString) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(minWidth: 0, maxWidth: .infinity)
                                .frame(height: 120)
                                .clipped()
                                .cornerRadius(12)
                        default:
                            EmptyView()
                        }
                    }
                }
            }
            .frame(height: 120)
            .contentShape(Rectangle())
            .onTapGesture {
                onClick()
            }
            
            Text(name)
                .font(.headline)
                .bold()
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity)
    }
}
