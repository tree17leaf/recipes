//
//  ContentView.swift
//  fetchRecipes
//
//  Created by Choonghun Lee on 2/10/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel: RecipeViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    Text("Fetching Recipes...")
                } else if let errorMessage = viewModel.errorMessage {
                    VStack {
                        Text(errorMessage)
                            .foregroundColor(.red)
                        Button("Retry") {
                            Task {
                                await viewModel.retry()
                            }
                        }
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(viewModel.recipesToDisplay, id: \.uuid) { recipe in
                                cardView(for: recipe)
                            }
                        }
                        .padding()
                    }
                    .refreshable {
                        await viewModel.fetchRecipe()
                    }
                }
            }
            .navigationTitle("Recipes")
        }
        .onAppear {
            Task {
                await viewModel.fetchRecipe()
            }
        }
        .padding()
    }
    
    @ViewBuilder
    func cardView(for recipe: Recipe) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(recipe.cuisine)
                .font(.headline)
                .foregroundColor(.gray)

            Text(recipe.name)
                .font(.title2)
                .fontWeight(.bold)

            HStack {
                if let photoURLLarge = recipe.photoURLLarge {
                    RecipeImageView(url: photoURLLarge)
                        .frame(width: 100, height: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.gray, lineWidth: 1))
                        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 4)
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.gray.opacity(0.6))
                }
            }
            .frame(maxWidth: .infinity)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 4)
        .padding(.horizontal)
    }
}

#Preview {
    ContentView(viewModel: RecipeViewModel())
}
