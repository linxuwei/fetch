import SwiftUI
import Foundation
import UIKit

struct CachedAsyncImage: View {
    let url: URL?

    @State private var uiImage: UIImage? = nil
    @State private var isLoading = false

    var body: some View {
        if let uiImage = uiImage {
            // 如果图片已加载或缓存，显示图片
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFit()
        } else if isLoading {
            // 加载中的占位视图
            ProgressView()
        } else {
            // 开始加载图片
            Color.gray
                .onAppear {
                    loadImage()
                }
        }
    }

    private func loadImage() {
        // 防止重复加载
        guard !isLoading else { return }
        isLoading = true

        // 检查缓存
        if let url = url, let cachedImage = ImageCache.shared.image(for: url) {
            self.uiImage = cachedImage
            self.isLoading = false
        } else if let url = url {
            // 从网络加载图片
            Task {
                do {
                    let (data, _) = try await URLSession.shared.data(from: url)
                    if let downloadedImage = UIImage(data: data) {
                        ImageCache.shared.save(image: downloadedImage, for: url)
                        self.uiImage = downloadedImage
                    }
                } catch {
                    print("Failed to load image: \(error)")
                }
                self.isLoading = false
            }
        } else {
            // 如果 URL 为空
            self.uiImage = nil
            self.isLoading = false
        }
    }
}

extension Image {
    func asUIImage() -> UIImage? {
        let uiImageRenderer = UIGraphicsImageRenderer(size: CGSize(width: 100, height: 100))
        return uiImageRenderer.image { _ in
            guard let placeholderImage = UIImage(systemName: "photo") else {
                return
            }
            placeholderImage.draw(in: CGRect(origin: .zero, size: CGSize(width: 100, height: 100)))
        }
    }
}
