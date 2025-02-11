//
//  NetworkError.swift
//  fetchRecipes
//
//  Created by Choonghun Lee on 2/10/25.
//

import Foundation

enum NetworkError: Error, Equatable {
    case invalidUrl
    case networkFailure
    case requestFailed
    case serverFailure
}
