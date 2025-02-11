//
//  RecipeViewModel.swift
//  fetchRecipes
//
//  Created by Choonghun Lee on 2/10/25.
//

import Foundation

class RecipeViewModel: ObservableObject {
    @Published var recipesToDisplay: [Recipe] = []
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false
    
    let recipeUrl: String
    
    init(urlStr: String = RecipeNetworkManager.basicUrlStr ) {
        self.recipeUrl = urlStr
    }

    
    func fetchRecipe() async {
        do {
            let recipeData: Recipes = try await RecipeNetworkManager.shared.fetch(path: recipeUrl)
            DispatchQueue.main.async {
                self.isLoading = true
                self.errorMessage = nil
                
                if !recipeData.recipes.isEmpty {
                    self.recipesToDisplay = recipeData.recipes
                } else {
                    self.errorMessage = "No recipes found."
                }
                self.isLoading = false
            }
            
        } catch let error as NetworkError {
            DispatchQueue.main.async {
                self.errorMessage = "Network error: \(error.localizedDescription)"
                self.isLoading = false
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "An unexpected error occurred."
                self.isLoading = false
            }
      }
    }
    
    func retry() async {
        await fetchRecipe()
    }
}
