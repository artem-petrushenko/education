import SwiftUI

struct CartItemRow: View {
    var content: ContentModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(content.title)
                .font(.headline)
                .foregroundColor(.primary)
        }
    
    }
}
