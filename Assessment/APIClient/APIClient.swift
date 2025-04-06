//
//  APIClient.swift
//  Assessment
//
//  Created by Asad Mehmood on 06/04/2025.
//

import Foundation
import Alamofire
import Combine

enum APIError: Error {
    case decodingError
    case serverError(String)
    case unknown
}

final class APIClient {
    static let shared = APIClient()

    private init() {}

    func request<T: Decodable>(
        _ url: String,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = JSONEncoding.default,
        headers: HTTPHeaders? = nil
    ) -> AnyPublisher<T, APIError> {
        return Future<T, APIError> { promise in
            AF.request(url,
                       method: method,
                       parameters: parameters,
                       encoding: encoding,
                       headers: headers)
                .validate()
                .responseDecodable(of: T.self) { response in
                    switch response.result {
                    case .success(let value):
                        promise(.success(value))
                    case .failure(let error):
                        if let data = response.data,
                           let errorString = String(data: data, encoding: .utf8) {
                            promise(.failure(.serverError(errorString)))
                        } else {
                            promise(.failure(.serverError(error.localizedDescription)))
                        }
                    }
                }
        }
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
    }
}
