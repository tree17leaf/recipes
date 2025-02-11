//
//  ImageLoader.swift
//  fetchRecipes
//
//  Created by Choonghun Lee on 2/10/25.
//

import SwiftUI

class ImageLoader: ObservableObject {
    @Published var image: UIImage?

    private var urlString: String?
    private var task: Task<Void, Never>?

    func load(from urlString: String) {
        self.urlString = urlString

        if let cachedImage = ImageCacheManager.shared.getImage(forKey: urlString) {
            self.image = cachedImage
            return
        }

        guard let url = URL(string: urlString) else { return }

        task?.cancel()

        task = Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                
                if Task.isCancelled { return }
                
                if let downloadedImage = UIImage(data: data) {
                    ImageCacheManager.shared.setImage(downloadedImage, forKey: urlString)
                    DispatchQueue.main.async {
                        self.image = downloadedImage
                    }
                }
            } catch {
                if Task.isCancelled { return }
                print("Image loading error: \(error.localizedDescription)")
            }
        }
    }

    func cancel() {
        task?.cancel()
    }
}
