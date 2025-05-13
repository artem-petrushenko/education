import SwiftUI

struct ContentListView: View {
    @EnvironmentObject private var container: DIContainer
    @StateObject private var viewModel: ContentListViewModel
    @State private var searchQuery: String = "Memes"

    init(contentProvider: ContentProvider) {
        _viewModel = StateObject(wrappedValue: ContentListViewModel(contentProvider: contentProvider))
    }

    var body: some View {
        NavigationView {
            Group {
                switch viewModel.state {
                case .loading:
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                case .success(let content):
                    List(content) { item in
                        NavigationLink(destination: ContentDetailView(id: item.id, contentProvider: container.contentProvider)) {
                            CartItemRow(content: item)
                        }
                    }
                    .listStyle(PlainListStyle())
                case .error(let message):
                    Text(message)
                        .font(.headline)
                        .foregroundColor(.red)
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                case .empty:
                    Text("Empty")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .navigationTitle("Content List")
            .searchable(text: $searchQuery, placement: .navigationBarDrawer(displayMode: .always))
            .onSubmit(of: .search) {
                viewModel.fetchContent(query: searchQuery)
            }
            .onAppear {
                if case .loading = viewModel.state {
                    viewModel.fetchContent(query: searchQuery)
                }
            }
        }
    }
}
