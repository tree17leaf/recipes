//
//  fetchRecipesApp.swift
//  fetchRecipes
//
//  Created by Choonghun Lee on 2/10/25.
//

import SwiftUI

@main
struct fetchRecipesApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: RecipeViewModel())
        }
    }
}
