//
//  InputMultiSelectSheetView.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 18.09.2026.
//

import SwiftUI

struct SelectSheetOption: Identifiable, Hashable {
    let value: String
    let name: String
    var id: String { value }
}

struct InputMultiSelectSheetView: View {
    var label: String? = nil
    var placeholder: String = ""
    let options: [SelectSheetOption]
    let selectedValues: Set<String>
    let isSingleSelect: Bool
    var isLoading: Bool = false
    var isError: Bool = false
    var errorMessage: String = ""
    let onConfirm: (Set<String>) -> Void

    @State private var isPresentingSheet = false

    private var selectedOptions: [SelectSheetOption] {
        options.filter { selectedValues.contains($0.value) }
    }

    private var hasValue: Bool { !selectedOptions.isEmpty }

    private var displayText: String {
        selectedOptions.map(\.name).joined(separator: " & ")
    }

    var body: some View {
        VStack(alignment: .leading, spacing: AppSize.xs.rawValue) {
            Button {
                isPresentingSheet = true
            } label: {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        if hasValue, let label {
                            Text(label)
                                .font(.caption2.bold())
                                .foregroundColor(.gray)
                        }

                        Text(hasValue ? displayText : placeholder)
                            .font(.subheadline)
                            .fontWeight(hasValue ? .regular : .semibold)
                            .foregroundColor(hasValue ? .onBackgroundSB : (isError ? .errorSB : .gray))
                            .lineLimit(1)
                    }

                    Spacer()

                    if isLoading {
                        ProgressView()
                    } else {
                        Image(systemName: "chevron.down")
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal, .base)
                .padding(.vertical, AppSize.s.rawValue)
                .frame(minHeight: 44)
                .background(Color.surfaceSB)
                .cornerRadius(12)
            }
            .buttonStyle(.plain)
            .disabled(isLoading)

            if isError {
                HStack(spacing: AppSize.xs.rawValue) {
                    Image(systemName: "exclamationmark.triangle")
                    Text(errorMessage)
                }
                .font(.caption)
                .foregroundColor(.errorSB)
            }
        }
        .sheet(isPresented: $isPresentingSheet) {
            InputMultiSelectSheetContent(
                title: label ?? "",
                options: options,
                initialSelectedValues: selectedValues,
                isSingleSelect: isSingleSelect,
                onConfirm: onConfirm
            )
        }
    }
}

private struct InputMultiSelectSheetContent: View {
    let title: String
    let options: [SelectSheetOption]
    let isSingleSelect: Bool
    let onConfirm: (Set<String>) -> Void

    @State private var localSelectedValues: Set<String>
    @Environment(\.dismiss) private var dismiss
    @State private var measuredHeight: CGFloat = 0

    init(
        title: String,
        options: [SelectSheetOption],
        initialSelectedValues: Set<String>,
        isSingleSelect: Bool,
        onConfirm: @escaping (Set<String>) -> Void
    ) {
        self.title = title
        self.options = options
        self.isSingleSelect = isSingleSelect
        self.onConfirm = onConfirm
        self._localSelectedValues = State(initialValue: initialSelectedValues)
    }

    var body: some View {
        VStack(spacing: 0) {
            SheetHeaderView(
                onDismiss: { dismiss() },
                title: title,
                showDivider: false
            )

            VStack(spacing: 0) {
                ForEach(options) { option in
                    Button {
                        toggle(option.value)
                    } label: {
                        HStack {
                            Text(option.name)
                                .font(.body)
                                .foregroundColor(.onBackgroundSB)

                            Spacer()

                            Image(systemName: localSelectedValues.contains(option.value) ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(localSelectedValues.contains(option.value) ? .onBackgroundSB : .dividerSB)
                        }
                        .padding(.vertical, .m)
                    }
                    .buttonStyle(.plain)
                }

                MainButton(
                    title: String(localized: "add"),
                    isDisabled: localSelectedValues.isEmpty,
                    onClick: {
                        onConfirm(localSelectedValues)
                        dismiss()
                    }
                )
                .padding(.top, .base)
            }
            .padding(.horizontal, .base)
            .padding(.bottom, .base)
        }
        .background(
            GeometryReader { geo in
                Color.clear
                    .onAppear { measuredHeight = geo.size.height }
                    .onChange(of: geo.size.height) { _, new in
                        measuredHeight = new
                    }
            }
        )
        .presentationDetents([.height(max(100, measuredHeight))])
        .presentationContentInteraction(.resizes)
        .presentationDragIndicator(.hidden)
        .presentationCornerRadius(25)
    }

    private func toggle(_ value: String) {
        if isSingleSelect {
            localSelectedValues = [value]
        } else if localSelectedValues.contains(value) {
            localSelectedValues.remove(value)
        } else {
            localSelectedValues.insert(value)
        }
    }
}
