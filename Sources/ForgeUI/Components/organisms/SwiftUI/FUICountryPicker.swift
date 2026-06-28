import SwiftUI

// MARK: - Model

/// A country entry. The `flag` emoji is derived from the ISO 3166-1 alpha-2
/// `id` code using Unicode regional-indicator symbols — no bundled images.
public struct FUICountry: Identifiable, Sendable {
    /// ISO 3166-1 alpha-2 code (e.g. `"ID"`, `"US"`).
    public let id: String
    public let name: String
    public let dialCode: String

    /// Regional-indicator emoji pair derived from the ISO code.
    public var flag: String {
        id.uppercased().unicodeScalars.compactMap {
            Unicode.Scalar(0x1F1E6 + $0.value - 0x41)
        }.map { String($0) }.joined()
    }

    public init(code: String, name: String, dialCode: String) {
        self.id = code
        self.name = name
        self.dialCode = dialCode
    }
}

// MARK: - Bundled country list (~20 common countries)

/// A curated default set of common countries. Pass a custom list to
/// `.fuiCountryPicker` when a fuller or localized set is needed.
public let kFUICountries: [FUICountry] = [
    FUICountry(code: "AU", name: "Australia",             dialCode: "+61"),
    FUICountry(code: "BR", name: "Brazil",                dialCode: "+55"),
    FUICountry(code: "CA", name: "Canada",                dialCode: "+1"),
    FUICountry(code: "CN", name: "China",                 dialCode: "+86"),
    FUICountry(code: "DE", name: "Germany",               dialCode: "+49"),
    FUICountry(code: "EG", name: "Egypt",                 dialCode: "+20"),
    FUICountry(code: "FR", name: "France",                dialCode: "+33"),
    FUICountry(code: "GB", name: "United Kingdom",        dialCode: "+44"),
    FUICountry(code: "ID", name: "Indonesia",             dialCode: "+62"),
    FUICountry(code: "IN", name: "India",                 dialCode: "+91"),
    FUICountry(code: "JP", name: "Japan",                 dialCode: "+81"),
    FUICountry(code: "KR", name: "South Korea",           dialCode: "+82"),
    FUICountry(code: "MX", name: "Mexico",                dialCode: "+52"),
    FUICountry(code: "MY", name: "Malaysia",              dialCode: "+60"),
    FUICountry(code: "NG", name: "Nigeria",               dialCode: "+234"),
    FUICountry(code: "PH", name: "Philippines",           dialCode: "+63"),
    FUICountry(code: "SA", name: "Saudi Arabia",          dialCode: "+966"),
    FUICountry(code: "SG", name: "Singapore",             dialCode: "+65"),
    FUICountry(code: "TR", name: "Turkey",                dialCode: "+90"),
    FUICountry(code: "US", name: "United States",         dialCode: "+1"),
    FUICountry(code: "VN", name: "Vietnam",               dialCode: "+84"),
    FUICountry(code: "ZA", name: "South Africa",          dialCode: "+27"),
]

// MARK: - Sheet content

private struct FUICountryPickerSheet: View {
    let countries: [FUICountry]
    let onSelect: (FUICountry) -> Void

    @State private var query = ""
    @Environment(\.dismiss) private var dismiss

    private var filtered: [FUICountry] {
        if query.isEmpty { return countries }
        let q = query.lowercased()
        return countries.filter {
            $0.name.lowercased().contains(q) ||
            $0.id.lowercased().contains(q) ||
            $0.dialCode.contains(q)
        }
    }

    var body: some View {
        NavigationStack {
            List(filtered) { country in
                Button {
                    onSelect(country)
                    dismiss()
                } label: {
                    HStack(spacing: Spacing.md) {
                        Text(country.flag)
                            .font(.system(size: 22))
                        Text(country.name)
                            .font(.fuiBody)
                            .foregroundColor(Color(FUIColor.textPrimary))
                        Spacer()
                        Text(country.dialCode)
                            .font(.fuiBody)
                            .foregroundColor(Color(FUIColor.textSecondary))
                    }
                }
                .buttonStyle(.plain)
            }
            .listStyle(.plain)
            .searchable(text: $query, prompt: "Search country or code")
            .navigationTitle("Select Country")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}

// MARK: - ViewModifier

private struct FUICountryPickerModifier: ViewModifier {
    @Binding var isPresented: Bool
    let countries: [FUICountry]
    let onSelect: (FUICountry) -> Void

    func body(content: Content) -> some View {
        content
            .sheet(isPresented: $isPresented) {
                FUICountryPickerSheet(countries: countries, onSelect: onSelect)
            }
    }
}

public extension View {
    /// Presents a searchable country picker sheet. `onSelect` is called with the
    /// chosen `FUICountry`; the sheet dismisses itself afterward.
    func fuiCountryPicker(
        isPresented: Binding<Bool>,
        countries: [FUICountry] = kFUICountries,
        onSelect: @escaping (FUICountry) -> Void
    ) -> some View {
        modifier(FUICountryPickerModifier(
            isPresented: isPresented,
            countries: countries,
            onSelect: onSelect
        ))
    }
}
