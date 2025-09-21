//
//  APIService.swift
//  BulldozerMobile
//
//  Created by Bulldozer Team on 2025.
//  Copyright © 2025 Bulldozer. All rights reserved.
//

import Foundation

class APIService: ObservableObject {
    static let shared = APIService()
    
    // Your deployed Railway backend URL
    private let baseURL = "https://python-backend-production-2258.up.railway.app/api"
    
    private init() {}
    
    // MARK: - Chat API
    func sendMessage(
        _ message: String,
        enableDeepThinking: Bool = false,
        enableBackgroundInvestigation: Bool = true,
        reportStyle: String = "COMPREHENSIVE"
    ) async throws -> ChatResponse {
        
        let request = ChatRequest(
            message: message,
            enableDeepThinking: enableDeepThinking,
            enableBackgroundInvestigation: enableBackgroundInvestigation,
            reportStyle: reportStyle
        )
        
        guard let url = URL(string: "\(baseURL)/chat/stream") else {
            throw APIError.invalidURL
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            urlRequest.httpBody = try JSONEncoder().encode(request)
        } catch {
            throw APIError.encodingError
        }
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw APIError.serverError
        }
        
        // Parse streaming response
        let responseString = String(data: data, encoding: .utf8) ?? ""
        return try parseStreamingResponse(responseString)
    }
    
    // MARK: - Research API
    func getResearch(_ researchId: String) async throws -> ResearchReport {
        guard let url = URL(string: "\(baseURL)/research/\(researchId)") else {
            throw APIError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw APIError.serverError
        }
        
        return try JSONDecoder().decode(ResearchReport.self, from: data)
    }
    
    func createResearch(_ request: ResearchRequest) async throws -> ResearchReport {
        guard let url = URL(string: "\(baseURL)/research") else {
            throw APIError.invalidURL
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            urlRequest.httpBody = try JSONEncoder().encode(request)
        } catch {
            throw APIError.encodingError
        }
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw APIError.serverError
        }
        
        return try JSONDecoder().decode(ResearchReport.self, from: data)
    }
    
    // MARK: - Configuration API
    func getConfiguration() async throws -> AppConfiguration {
        guard let url = URL(string: "\(baseURL)/config") else {
            throw APIError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw APIError.serverError
        }
        
        return try JSONDecoder().decode(AppConfiguration.self, from: data)
    }
    
    // MARK: - Helper Methods
    private func parseStreamingResponse(_ response: String) throws -> ChatResponse {
        // Parse Server-Sent Events format
        let lines = response.components(separatedBy: .newlines)
        var message = ""
        var researchId: String?
        var isComplete = false
        
        for line in lines {
            if line.hasPrefix("data: ") {
                let data = String(line.dropFirst(6))
                if data == "[DONE]" {
                    isComplete = true
                    break
                }
                
                if let jsonData = data.data(using: .utf8) {
                    do {
                        let streamData = try JSONDecoder().decode(StreamData.self, from: jsonData)
                        message += streamData.content
                        if let id = streamData.researchId {
                            researchId = id
                        }
                    } catch {
                        // Continue parsing other lines
                        continue
                    }
                }
            }
        }
        
        return ChatResponse(
            message: message,
            researchId: researchId,
            isComplete: isComplete
        )
    }
}

// MARK: - Supporting Types
struct AppConfiguration: Codable {
    let models: ModelConfiguration
    let features: FeatureConfiguration
}

struct ModelConfiguration: Codable {
    let basic: [String]
    let reasoning: [String]?
}

struct FeatureConfiguration: Codable {
    let deepThinking: Bool
    let backgroundInvestigation: Bool
    let reportStyles: [String]
}

struct StreamData: Codable {
    let content: String
    let researchId: String?
}

enum APIError: Error, LocalizedError {
    case invalidURL
    case encodingError
    case serverError
    case networkError
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .encodingError:
            return "Failed to encode request"
        case .serverError:
            return "Server error occurred"
        case .networkError:
            return "Network connection failed"
        }
    }
}
