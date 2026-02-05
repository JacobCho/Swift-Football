//
//  DataFetcher.swift
//  Swift Football
//
//  Created by Jacob Cho on 2026-01-26.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case decodingError(Error)
    case serverError(Int)
}

class DataFetcher {
    
    var cachedResponse: Decodable?
    var cachedParameters: [String: String]?
    
    init() {}
    
    func shouldReturnCache(new: [String: String]) -> Bool {
        guard let cachedParams = cachedParameters else {
            return false
        }
        
        return new == cachedParams
    }
    
    func fetch<T: Decodable>(endPoint: String, parameters: [String: String]? = nil) async throws -> T {
        let urlString = "https://v3.football.api-sports.io/\(endPoint)?"
        guard var components = URLComponents(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        if let cached = cachedResponse as? T, let params = parameters, shouldReturnCache(new: params) {
            return cached
        } else {
            cachedParameters = parameters
        }
        
        if let parameters {
            components.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value)}
        }
        
        guard let url = components.url else {
            throw NetworkError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(APIConfig.apiKey, forHTTPHeaderField: "x-apisports-key")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard (200..<300).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError(httpResponse.statusCode)
        }
        
        return try JSONDecoder().decode(T.self, from: data)
    }
}
