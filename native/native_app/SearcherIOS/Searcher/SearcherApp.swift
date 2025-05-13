import SwiftUI

@main
struct DefaultApp: App {
    let dependency: DIContainer
    
    init() {
        let contentProvider = ContentProviderImpl(contentNetwork: ContentNetwork())
        self.dependency = DIContainer(contentProvider: contentProvider)
    }
    
    var body: some Scene {
        
        WindowGroup {
            ContentListView(contentProvider: dependency.contentProvider)
                .environmentObject(dependency)
        }
    }
}

final class DIContainer: ObservableObject {
    let contentProvider: ContentProvider

    init(contentProvider: ContentProvider) {
        self.contentProvider = contentProvider
    }
}
