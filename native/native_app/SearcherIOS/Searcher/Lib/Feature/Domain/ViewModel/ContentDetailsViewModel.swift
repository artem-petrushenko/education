import SwiftUI

enum ContentDetailsState {
    case loading
    case success(ContentModel)
    case error(String)
}

class ContentDetailsViewModel: ObservableObject {
    @Published var state: ContentDetailsState = .loading
    private var contentProvider: ContentProvider
    private var id: String

    init(contentProvider: ContentProvider, id: String) {
        self.contentProvider = contentProvider
        self.id = id
    }

    func fetchContent(id: String) {
        state = .loading
        Task {
            do {
                let content = try await contentProvider.getContentDetails(id: id)
                self.state = .success(content)
            } catch {
                self.state = .error("Failed to fetch content: \(error.localizedDescription)")
            }
        }
    }
}
