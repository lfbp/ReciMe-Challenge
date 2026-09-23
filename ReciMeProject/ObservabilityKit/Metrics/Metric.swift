//
//  Metric.swift
//  ReciMeProject
//
//  Created by Luis Pereira on 22/09/26.
//

import Foundation

enum MetricType {
    case counter(name: String, value: Double, tags: [String: String])
    case gauge(name: String, value: Double, tags: [String: String])
    case timer(name: String, duration: TimeInterval, tags: [String: String])
    case distribution(name: String, value: Double, tags: [String: String])
    
    var name: String {
        switch self {
        case .counter(let name, _, _),
             .gauge(let name, _, _),
             .timer(let name, _, _),
             .distribution(let name, _, _):
            return name
        }
    }
}

struct Metric {
    let type: MetricType
    let timestamp: Date
    
    init(type: MetricType) {
        self.type = type
        self.timestamp = Date()
    }
}
