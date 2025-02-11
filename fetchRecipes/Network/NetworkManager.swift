//
//  NetworkManager.swift
//  fetchRecipes
//
//  Created by Choonghun Lee on 2/10/25.
//

import Foundation
protocol NetworkManager {
    func buildRequest(path: String, headers: [String: String]?) throws -> URLRequest
    func fetch<T: Codable>(path: String, headers: [String: String]?) async throws -> T
}
