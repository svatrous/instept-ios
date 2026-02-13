import SwiftUI

class ImageCache {
    static let shared = NSCache<NSString, UIImage>()
    
    private init() {}
    
    func get(forKey key: String) -> UIImage? {
        return ImageCache.shared.object(forKey: key as NSString)
    }
    
    func set(_ image: UIImage, forKey key: String) {
        ImageCache.shared.setObject(image, forKey: key as NSString)
    }
}

struct CachedAsyncImage<Content: View, Placeholder: View>: View {
    private let url: URL?
    private let scale: CGFloat
    private let transaction: Transaction
    private let content: (Image) -> Content
    private let placeholder: () -> Placeholder
    
    @State private var image: UIImage? = nil
    @State private var isLoading = false
    
    init(
        url: URL?,
        scale: CGFloat = 1.0,
        transaction: Transaction = Transaction(),
        @ViewBuilder content: @escaping (Image) -> Content,
        @ViewBuilder placeholder: @escaping () -> Placeholder
    ) {
        self.url = url
        self.scale = scale
        self.transaction = transaction
        self.content = content
        self.placeholder = placeholder
    }
    
    var body: some View {
        if let image = image {
            content(Image(uiImage: image))
        } else {
            placeholder()
                .onAppear {
                    loadImage()
                }
        }
    }
    
    private func loadImage() {
        guard let url = url else { return }
        
        // Check cache first
        if let cachedImage = ImageCache.shared.object(forKey: url.absoluteString as NSString) {
            self.image = cachedImage
            return
        }
        
        guard !isLoading else { return }
        isLoading = true
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            defer { isLoading = false }
            
            guard let data = data, let uiImage = UIImage(data: data) else { return }
            
            // Save to cache
            ImageCache.shared.setObject(uiImage, forKey: url.absoluteString as NSString)
            
            DispatchQueue.main.async {
                withAnimation(transaction.animation) {
                    self.image = uiImage
                }
            }
        }.resume()
    }
}
