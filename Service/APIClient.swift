//
//  APIClient.swift
//  BrexMobileApp
//
//  Created by Krishna Kumar on 12/3/21.
//

import Foundation


final class APIClient {
    private let urlSession = URLSession.shared
    private let jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .useDefaultKeys
        return jsonDecoder
    }()
    static let shared = APIClient()
    private init() {}
}

extension URLSession {
    func dataTask(with request: URLRequest, result: @escaping (Result<(URLResponse, Data), Error>) -> Void) -> URLSessionDataTask {
        return dataTask(with: request){ (data, response, error) in
            if let error = error {
                result(.failure(error))
                return
            }
            guard let response = response, let data = data else {
                let error = NSError(domain: "error", code: 0, userInfo: nil)
                result(.failure(error))
                return
            }
            result(.success((response, data)))
        }
    }
    
    func dataTask(with url: URL, result: @escaping (Result<(URLResponse, Data), Error>) -> Void) -> URLSessionDataTask {
        return dataTask(with: url) { (data, response, error) in
            if let error = error {
                result(.failure(error))
                return
            }
            guard let response = response, let data = data else {
                let error = NSError(domain: "error", code: 0, userInfo: nil)
                result(.failure(error))
                return
            }
            result(.success((response, data)))
        }
    }
}

extension APIClient {
    
    public enum APIServiceError: Error {
        case apiError
        case invalidEndpoint
        case invalidResponse
        case noData
        case decodeError
    }
    
    func sendRequest<T: Decodable>(url: URL, queryItems:[URLQueryItem]? = nil, data: [String: String]? = nil, httpMethod: String? = "GET", completion: @escaping (Result<T, APIServiceError>) -> Void) {
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            completion(.failure(.invalidEndpoint))
            return
        }
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else {
            completion(.failure(.invalidEndpoint))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        //request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "content-type")

        request.allHTTPHeaderFields = [
            "content-type": "application/x-www-form-urlencoded",
            "Accept": "application/json"
        ]
        
        if let data = data {
            if let data1 = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted) {
                request.httpBody = data1
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.setValue("\(data.count)", forHTTPHeaderField: "Content-Length")
            }
        }
        
       
         
        
        urlSession.dataTask(with: request) { [weak self] result in
            guard let self = self else {
                return
            }
            
            switch result {
            case .success(let (response, data)):
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode, 200..<299 ~= statusCode else {
                    completion(.failure(.invalidResponse))
                    return
                }
                do {
                    let values = try self.jsonDecoder.decode(T.self, from: data)
                    completion(.success(values))
                } catch (let error){
                    print("error = \(error.localizedDescription)")
                    completion(.failure(.decodeError))
                }
            case .failure( _):
                completion(.failure(.apiError))
            }
        }.resume()
    }
}
