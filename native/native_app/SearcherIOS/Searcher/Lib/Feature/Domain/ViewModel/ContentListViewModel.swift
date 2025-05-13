import SwiftUI

enum ContentListState {
    case loading
    case success([ContentModel])
    case empty
    case error(String)
}

class ContentListViewModel: ObservableObject {
    @Published var state: ContentListState = .loading
    private var contentProvider: ContentProvider
     
    init(contentProvider: ContentProvider) {
        self.contentProvider = contentProvider
    }
    
    func fetchContent(query: String? = nil) {
        state = .loading
        let finalQuery = query?.isEmpty == false ? query : "Memes"
        Task {
            do {
                let content = try await contentProvider.getContent(query: finalQuery)
                if content.isEmpty {
                    self.state = .empty
                } else {
                    self.state = .success(content)
                }
            } catch {
                self.state = .error("Failed to fetch content: \(error.localizedDescription)")
            }
        }
    }
}
