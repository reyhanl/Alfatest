//
//  NetworkExecutor.swift
//  AlfaMovie
//
//  Created by reyhan muhammad on 2025/7/24.
//

import Foundation

class NetworkExecutor{
    func execute<T: Codable>(request: URLRequest) async throws -> T{
        var request = request
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        request.setValue("no-cache", forHTTPHeaderField: "Cache-Control")
        request.setValue("no-cache", forHTTPHeaderField: "Pragma")
        request.setValue("0", forHTTPHeaderField: "Expires")

        let authentication = RemoteConfigProvider.shared.authentication()
        request.setValue("Bearer \(authentication)", forHTTPHeaderField: "Authorization")
        
        do{
            let (data, response) = try await URLSession.shared.data(for: request)
            // Check HTTP response code
            guard let httpResponse = response as? HTTPURLResponse else {
                throw URLError(.badServerResponse)
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                // Optional: throw a custom error with the statusCode or message from `data`
                throw CustomError.statusCode(httpResponse.statusCode)
            }
            print("Making API call with url: \(request.url)")
            let decoder = JSONDecoder()
            let models = try decoder.decode(T.self, from: data)
            print("models: \(models)")
            return models
        }catch{
            if let urlError = error as? URLError {
                switch urlError.code {
                case .notConnectedToInternet:
                    NotificationCenter.default.post(name: .noInternetNotification, object: nil)
                case .timedOut:
                    NotificationCenter.default.post(name: .slowInternetNotification, object: nil)
                case .cannotFindHost, .cannotConnectToHost:
                    NotificationCenter.default.post(name: .sessionIssue, object: nil)
                default:
                    NotificationCenter.default.post(name: .sessionIssue, object: nil)
                }
            }else if let decodingError = error as? DecodingError {
                //TODO: Do something
            }else{
                NotificationCenter.default.post(name: .sessionIssue, object: nil)
            }
            throw error
        }
    }
}
