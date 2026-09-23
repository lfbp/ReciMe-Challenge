//
//  NetworkService.swift
//  ReciMeProject
//
//  Created by Luis Pereira on 22/09/26.
//

import Foundation
import Combine

protocol NetworkServiceProtocol {
    func loadLocalJSON<T: Decodable>(filename: String) -> AnyPublisher<T, Error>
}

final class NetworkService: NetworkServiceProtocol {
    
    private let observability: ObservabilityManager
    private let bundle: Bundle
    
    init(observability: ObservabilityManager, bundle: Bundle = .main) {
        self.observability = observability
        self.bundle = bundle
    }
    
    func loadLocalJSON<T: Decodable>(filename: String) -> AnyPublisher<T, Error> {
        let bundle = self.bundle
        let observability = self.observability
        
        return Future { promise in
            do {
                let data = try bundle.decode(T.self, from: filename)
                promise(.success(data))
            } catch {
                observability.logger.error(
                    "Failed to load \(filename).json: \(error.localizedDescription)",
                    category: "Network",
                    file: #file,
                    function: #function,
                    line: #line,
                    metadata: ["filename": filename]
                )
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
}
