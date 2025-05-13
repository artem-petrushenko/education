import SwiftUI
import UIKit

struct GIFImageView: UIViewRepresentable {
    let gifURL: URL

    func makeUIView(context: Context) -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }

    func updateUIView(_ uiView: UIImageView, context: Context) {
        URLSession.shared.dataTask(with: gifURL) { data, _, _ in
            guard let data = data else { return }
            DispatchQueue.main.async {
                uiView.image = UIImage.animatedImage(withAnimatedGIFData: data)
            }
        }.resume()
    }
}

extension UIImage {
    static func animatedImage(withAnimatedGIFData data: Data) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else { return nil }
        let count = CGImageSourceGetCount(source)
        var images: [UIImage] = []
        
        for i in 0..<count {
            if let cgImage = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(UIImage(cgImage: cgImage))
            }
        }
        
        return UIImage.animatedImage(with: images, duration: Double(count) * 0.1)
    }
}
