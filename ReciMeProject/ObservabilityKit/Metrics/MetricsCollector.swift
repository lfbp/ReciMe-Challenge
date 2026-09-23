//
//  MetricsCollector.swift
//  ReciMeProject
//
//  Created by Luis Pereira on 22/09/26.
//

import Foundation

protocol MetricsCollectorProtocol {
    func recordCounter(name: String, value: Double, tags: [String: String])
    func recordGauge(name: String, value: Double, tags: [String: String])
    func recordTimer(name: String, duration: TimeInterval, tags: [String: String])
    func recordDistribution(name: String, value: Double, tags: [String: String])
}

final class MetricsCollector: MetricsCollectorProtocol {
    private let queue: DispatchQueue
    private var metrics: [Metric] = []
    
    init() {
        self.queue = DispatchQueue(label: "com.recime.metrics", qos: .utility)
    }
    
    func recordCounter(name: String, value: Double = 1.0, tags: [String: String] = [:]) {
        let metric = Metric(type: .counter(name: name, value: value, tags: tags))
        record(metric: metric)
    }
    
    func recordGauge(name: String, value: Double, tags: [String: String] = [:]) {
        let metric = Metric(type: .gauge(name: name, value: value, tags: tags))
        record(metric: metric)
    }
    
    func recordTimer(name: String, duration: TimeInterval, tags: [String: String] = [:]) {
        let metric = Metric(type: .timer(name: name, duration: duration, tags: tags))
        record(metric: metric)
    }
    
    func recordDistribution(name: String, value: Double, tags: [String: String] = [:]) {
        let metric = Metric(type: .distribution(name: name, value: value, tags: tags))
        record(metric: metric)
    }
    
    private func record(metric: Metric) {
        queue.async { [weak self] in
            self?.metrics.append(metric)
            self?.logMetric(metric)
        }
    }
    
    private func logMetric(_ metric: Metric) {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss.SSS"
        let timestamp = formatter.string(from: metric.timestamp)
        print("📈 [METRIC] \(timestamp) - \(metric.type.name)")
    }
}
