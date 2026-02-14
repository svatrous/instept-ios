import SwiftUI

class ImageCache {
    static let shared = ImageCache()
    
    // Memory cache
    private let cache = NSCache<NSString, UIImage>()
    
    // Disk cache
    private let fileManager = FileManager.default
    private let cacheDirectory: URL?
    
    private init() {
        // Create a custom subdirectory for image cache
        let paths = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)
        cacheDirectory = paths.first?.appendingPathComponent("ImageCache")
        
        if let directory = cacheDirectory {
            try? fileManager.createDirectory(at: directory, withIntermediateDirectories: true)
        }
    }
    
    func get(forKey key: String) -> UIImage? {
        // 1. Check memory cache
        if let image = cache.object(forKey: key as NSString) {
            return image
        }
        
        // 2. Check disk cache
        guard let directory = cacheDirectory,
              let fileName = key.addingPercentEncoding(withAllowedCharacters: .alphanumerics) else {
            return nil
        }
        
        let fileURL = directory.appendingPathComponent(fileName)
        
        guard let data = try? Data(contentsOf: fileURL),
              let image = UIImage(data: data) else {
            return nil
        }
        
        // Populate memory cache
        cache.setObject(image, forKey: key as NSString)
        
        return image
    }
    
    func set(_ image: UIImage, forKey key: String) {
        // 1. Save to memory cache
        cache.setObject(image, forKey: key as NSString)
        
        // 2. Save to disk cache
        guard let directory = cacheDirectory,
              let fileName = key.addingPercentEncoding(withAllowedCharacters: .alphanumerics),
              let data = image.jpegData(compressionQuality: 0.8) else {
            return
        }
        
        let fileURL = directory.appendingPathComponent(fileName)
        
        // Perform file write on background queue to avoid blocking UI
        DispatchQueue.global(qos: .background).async {
            try? data.write(to: fileURL)
        }
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
        if let cachedImage = ImageCache.shared.get(forKey: url.absoluteString) {
            self.image = cachedImage
            return
        }
        
        guard !isLoading else { return }
        isLoading = true
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            defer { isLoading = false }
            
            guard let data = data, let uiImage = UIImage(data: data) else { return }
            
            // Save to cache
            ImageCache.shared.set(uiImage, forKey: url.absoluteString)
            
            DispatchQueue.main.async {
                withAnimation(transaction.animation) {
                    self.image = uiImage
                }
            }
        }.resume()
    }
}
