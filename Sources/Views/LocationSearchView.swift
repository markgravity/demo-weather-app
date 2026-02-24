import SwiftUI
import MapKit

struct LocationSearchView: View {
    @State private var searchText = ""
    @State private var results: [MKLocalSearchCompletion] = []
    @State private var completer = MKLocalSearchCompleter()
    @Environment(\.dismiss) private var dismiss

    let onLocationSelected: (SavedLocation) -> Void

    var body: some View {
        NavigationStack {
            List {
                if results.isEmpty && !searchText.isEmpty {
                    ContentUnavailableView.search(text: searchText)
                }
                ForEach(results, id: \.self) { result in
                    Button {
                        selectLocation(result)
                    } label: {
                        VStack(alignment: .leading) {
                            Text(result.title)
                                .font(.body)
                            Text(result.subtitle)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Search cities...")
            .navigationTitle("Add Location")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
        .onChange(of: searchText) { _, newValue in
            completer.queryFragment = newValue
        }
    }

    private func selectLocation(_ completion: MKLocalSearchCompletion) {
        let request = MKLocalSearch.Request(completion: completion)
        let search = MKLocalSearch(request: request)
        Task {
            if let response = try? await search.start(),
               let item = response.mapItems.first {
                let location = SavedLocation(
                    id: UUID(),
                    name: completion.title,
                    latitude: item.placemark.coordinate.latitude,
                    longitude: item.placemark.coordinate.longitude
                )
                onLocationSelected(location)
                dismiss()
            }
        }
    }
}
