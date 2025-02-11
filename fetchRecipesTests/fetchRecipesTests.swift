//
//  fetchRecipesTests.swift
//  fetchRecipesTests
//
//  Created by Choonghun Lee on 2/10/25.
//

import XCTest
@testable import fetchRecipes

final class fetchRecipesTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDecoding() throws {
        let jsonData = """
           {
               "recipes": [
                   {
                       "cuisine": "Malaysian",
                       "name": "Apam Balik",
                       "photo_url_large": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg",
                       "photo_url_small": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg",
                       "source_url": "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ",
                       "uuid": "0c6ca6e7-e32a-4053-b824-1dbf749910d8",
                       "youtube_url": "https://www.youtube.com/watch?v=6R8ffRRJcrg"
                   },
                   {
                       "cuisine": "British",
                       "name": "Apple & Blackberry Crumble",
                       "photo_url_large": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/large.jpg",
                       "photo_url_small": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/small.jpg",
                       "source_url": "https://www.bbcgoodfood.com/recipes/778642/apple-and-blackberry-crumble",
                       "uuid": "599344f4-3c5c-4cca-b914-2210e3b3312f",
                       "youtube_url": "https://www.youtube.com/watch?v=4vhcOwVBDO4"
                   }]
           }
           """.data(using: .utf8)!
        
        let decoder = JSONDecoder()

        let decodedData = try decoder.decode(Recipes.self, from: jsonData)

        XCTAssertEqual(decodedData.recipes.count, 2)

        // Test first recipe
        let firstRecipe = decodedData.recipes[0]
        XCTAssertEqual(firstRecipe.cuisine, "Malaysian")
        XCTAssertEqual(firstRecipe.name, "Apam Balik")
        XCTAssertEqual(firstRecipe.photoURLLarge, "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg")
        XCTAssertEqual(firstRecipe.uuid, "0c6ca6e7-e32a-4053-b824-1dbf749910d8")
        XCTAssertNotNil(URL(string: firstRecipe.sourceURL ?? ""))

        // Test second recipe
        let secondRecipe = decodedData.recipes[1]
        XCTAssertEqual(secondRecipe.cuisine, "British")
        XCTAssertEqual(secondRecipe.name, "Apple & Blackberry Crumble")
        XCTAssertEqual(secondRecipe.photoURLLarge, "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/large.jpg")
        XCTAssertEqual(secondRecipe.uuid, "599344f4-3c5c-4cca-b914-2210e3b3312f")
        XCTAssertNotNil(URL(string: secondRecipe.youtubeURL ?? ""))
    }
   
    func testFetchSuccess() async {
          let viewModel = RecipeViewModel()
          
          XCTAssertTrue(viewModel.recipesToDisplay.isEmpty)
          XCTAssertNil(viewModel.errorMessage)
          XCTAssertFalse(viewModel.isLoading)

          await viewModel.fetchRecipe()
        
          try? await Task.sleep(nanoseconds: 3_000_000_000)
          XCTAssertFalse(viewModel.isLoading)
          XCTAssertNil(viewModel.errorMessage)
          XCTAssertFalse(viewModel.recipesToDisplay.isEmpty)
      }

      func testFetchEmptyResponse() async {
          let viewModel = RecipeViewModel(urlStr: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json")
          
          await viewModel.fetchRecipe()
          
          try? await Task.sleep(nanoseconds: 3_000_000_000)
          XCTAssertFalse(viewModel.isLoading)
          XCTAssertEqual(viewModel.errorMessage, "No recipes found.", "Error message should indicate no recipes")
          XCTAssertTrue(viewModel.recipesToDisplay.isEmpty)
      }

      func testFetchMalformedJSON() async {
          let viewModel = RecipeViewModel(urlStr: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json")
          
          await viewModel.fetchRecipe()
          
          try? await Task.sleep(nanoseconds: 3_000_000_000)
          XCTAssertFalse(viewModel.isLoading)
          XCTAssertNotNil(viewModel.errorMessage, "Error message should be set on JSON parsing failure")
          XCTAssertTrue(viewModel.recipesToDisplay.isEmpty)
      }

      func testRetryFetch() async {
          let viewModel = RecipeViewModel(urlStr: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")
          
          await viewModel.retry()
          
          try? await Task.sleep(nanoseconds: 3_000_000_000)
          XCTAssertFalse(viewModel.isLoading)
          XCTAssertNil(viewModel.errorMessage)
          XCTAssertFalse(viewModel.recipesToDisplay.isEmpty)
      }
    
    func testImageCaching() {
        let cache = ImageCacheManager.shared
        let testKey = "test_image_key"
        let testImage = UIImage(systemName: "photo")!
        
        XCTAssertNil(cache.getImage(forKey: testKey))
        
        cache.setImage(testImage, forKey: testKey)
        
        let cachedImage = cache.getImage(forKey: testKey)
        
        XCTAssertNotNil(cachedImage)
        XCTAssertEqual(cachedImage?.pngData(), testImage.pngData())
    }

    func testCacheDoesNotRetainImageAfterClear() {
        let cache = ImageCacheManager.shared
        let testKey = "test_clear_cache"
        let testImage = UIImage(systemName: "photo")!
        
        cache.setImage(testImage, forKey: testKey)
        XCTAssertNotNil(cache.getImage(forKey: testKey))
        
        cache.setImage(nil, forKey: testKey)
        
        XCTAssertNil(cache.getImage(forKey: testKey))
    }
}
