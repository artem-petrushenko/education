protocol ContentProvider {
    func getContent(query: String?) async throws -> [ContentModel]
    
    func getContentDetails(id: String) async throws -> ContentModel
}
 
class ContentProviderImpl: ContentProvider {
    private let contentNetwork: ContentNetworkProtocol
    
    init(contentNetwork: ContentNetworkProtocol) {
        self.contentNetwork = contentNetwork
    }
    
    func getContent(query: String?) async throws -> [ContentModel] {
        try await contentNetwork.fetchContent(query: query)
    }
    
    func getContentDetails(id: String) async throws -> ContentModel {
        try await contentNetwork.fetchDetailsContent(id: id)
    }
}
