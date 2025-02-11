//
//  RecipeImageView.swift
//  fetchRecipes
//
//  Created by Choonghun Lee on 2/10/25.
//

import SwiftUI

struct RecipeImageView: View {
    @StateObject private var loader = ImageLoader()
    let url: String
    
    init(url: String) {
        self.url = url
    }
    
    var body: some View {
        Group {
            if let image = loader.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80, height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            } else {
                ProgressView()
                    .frame(width: 80, height: 80)
            }
        }
        .onAppear {
            loader.load(from: url)
        }
        .onDisappear {
            loader.cancel()
        }
    }
}
