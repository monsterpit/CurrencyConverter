//
//  NetworkManager.swift
//  CurrencyConverter
//
//  Created by Vikas Salian on 14/05/23.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case badHTTPResponse
    case decodingError
    case noData
}

enum NetworkResult<T> {
    case success(T)
    case failure(Error)
}

protocol NetworkManaging {
    func request<T: Codable>(_ endpoint: Endpoint, completion: @escaping (NetworkResult<T>) -> Void)
}

final class NetworkManager: NetworkManaging {

    static let shared = NetworkManager()
    private let session = URLSession.shared
    private let validTime: TimeInterval = 30 * 60 // if before 30 minutes

    func request<T: Codable>(_ endpoint: Endpoint, completion: @escaping (NetworkResult<T>) -> Void) {

        let cacheFileName = cacheFileName(url: endpoint.urlRequest?.url)
        if let data = readFromCache(withName: cacheFileName, validFor: validTime) {
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(NetworkError.decodingError))
            }
            return
        }
        guard let urlRequest = endpoint.urlRequest  else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        let task = session.dataTask(with: urlRequest) { (data, response, error) in

            print("OUTGOING request \(String(describing: response?.url))")

            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NetworkError.badHTTPResponse))
                return
            }

            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }

            do {
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode(T.self, from: data)
                self.writeToCache(data, withName: cacheFileName)
                print("Fetched From API")
                completion(.success(decodedData))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }

    private func writeToCache(_ data: Data, withName name: String) {
        let cacheDir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let fileUrl = cacheDir.appendingPathComponent(name)

        do {
            try data.write(to: fileUrl)
        } catch {
            print("Failed to write data to cache: \(error)")
        }
    }

    private func readFromCache(withName name: String, validFor seconds: TimeInterval) -> Data? {
        let cacheDir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let fileUrl = cacheDir.appendingPathComponent(name)

        guard let data = try? Data(contentsOf: fileUrl) else {
            return nil
        }

        let fileCreationTime = try? FileManager.default.attributesOfItem(atPath: fileUrl.path)[.modificationDate] as? Date
        let currentTime = Date()
        let timeSinceCreation = currentTime.timeIntervalSince(fileCreationTime ?? currentTime)

        if timeSinceCreation > seconds && Reachability.isConnectedToNetwork {
            // Cache is stale and you are connected to network else return data
            return nil
        }
        print("Fetched From Saved Data")
        return data
    }

    private func cacheFileName(url: URL?) -> String {
        var fileName = url?.absoluteString ?? "default"
        if let query = url?.query {
            fileName += "?\(query)"
        }
        return fileName.replacingOccurrences(of: "[^a-zA-Z0-9]+", with: "_", options: .regularExpression)
    }
}
