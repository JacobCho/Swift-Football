//
//  DataFetcher.swift
//  Swift Football
//
//  Created by Jacob Cho on 2026-01-26.
//

import Foundation

protocol DescriptiveError: Error {
    var description: String { get }
}

enum NetworkError: DescriptiveError {
    case invalidURL
    case invalidResponse
    case decodingError
    case serverError(Int)
    case testFileError
    
    var description: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid Response"
        case .decodingError:
            return "Could not decode JSON"
        case .serverError(let code):
            return "Server Error Code: \(code)"
        case .testFileError:
            return "Error loading mock file"
        }
    }
}

enum Endpoint: String {
    case countries
    case leagues
    case standings
    
    func jsonFilename() -> String {
        switch self {
        case .countries:
            return "countries"
        case .leagues:
            return "english-leagues"
        case .standings:
            return "prem-2024-standings"
        }
    }
    
    func shouldUseMock() -> Bool {
        switch self {
        case .countries:
            return true
        case .leagues:
            return false
        case .standings:
            return false
        }
    }
}

class DataFetcher {
    
    init() {}
    
    func fetch<T: Decodable>(endPoint: Endpoint, parameters: [String: String]? = nil) async throws -> T {
        if endPoint.shouldUseMock() {
            return try fetchTestFiles(endPoint: endPoint)
        }
        
        let urlString = "https://v3.football.api-sports.io/\(endPoint.rawValue)?"
        guard var components = URLComponents(string: urlString) else {
            throw NetworkError.invalidURL
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
        
        do {
            let decoded = try JSONDecoder().decode(T.self, from: data)
            return decoded
        } catch {
            throw NetworkError.decodingError
        }
    }
    
    func fetchTestFiles<T: Decodable>(endPoint: Endpoint) throws -> T {
        guard let url = Bundle.main.url(forResource: endPoint.jsonFilename(), withExtension: "json") else {
            throw NetworkError.testFileError
        }
        
        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NetworkError.testFileError
        }
    }
}
