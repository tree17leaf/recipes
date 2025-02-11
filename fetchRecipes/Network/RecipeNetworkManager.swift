//
//  NetworkManager.swift
//  fetchRecipes
//
//  Created by Choonghun Lee on 2/10/25.
//

import Foundation
import UIKit

class RecipeNetworkManager: NetworkManager {
    static let shared = RecipeNetworkManager()
    let urlSession = URLSession(configuration: .default)

    static let basicUrlStr = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"
    
    private init() {}

    func buildRequest(path: String, headers: [String: String]?) throws -> URLRequest {
        guard let url = URL(string: path) else {
            throw NetworkError.invalidUrl
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if let headers {
            for (headerField, headerValue) in headers {
                request.setValue(headerValue, forHTTPHeaderField: headerField)
            }
        }
        return request
    }

    func fetch<T: Decodable>(path: String, headers: [String: String]? = nil) async throws -> T {
        do {
            let request = try buildRequest(path: path, headers: headers)
            let (data, response) = try await urlSession.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw URLError(.badServerResponse)
            }
            guard (200 ... 299).contains(httpResponse.statusCode) else {
                throw NetworkError.networkFailure
            }

            let dataResponse = try JSONDecoder().decode(T.self, from: data)
            return dataResponse
        } catch {
            throw error
        }
    }
}
