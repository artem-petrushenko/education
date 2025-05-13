import SwiftUI

struct ContentDetailView: View {
    @StateObject private var viewModel: ContentDetailsViewModel
    private let id: String

    init(id: String, contentProvider: ContentProvider) {
        _viewModel = StateObject(wrappedValue: ContentDetailsViewModel(contentProvider: contentProvider, id: id))
        self.id = id
    }
    

    var body: some View {
        VStack {
                switch viewModel.state {
                case .loading:
                    ProgressView()
                case .success(let content):
                    Grid {
                        Text(content.title)
                        ShareLink(item: content.images.original.url) {
                                    Label("Share", systemImage: "square.and.arrow.up")
                                }
                                .padding()
                        GIFImageView(gifURL: URL(string: content.images.original.url)!)
                    }
                    
                case .error(let message):
                    Text(message)
                        .font(.headline)
                        .foregroundColor(.red)
                        .padding()
                }
            
        }
        .onAppear {
            viewModel.fetchContent(id: id)
        }
    }
}
