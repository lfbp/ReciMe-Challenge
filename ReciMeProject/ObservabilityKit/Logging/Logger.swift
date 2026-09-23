//
//  Logger.swift
//  ReciMeProject
//
//  Created by Luis Pereira on 22/09/26.
//

import Foundation

protocol LoggerProtocol {
    func verbose(_ message: String, category: String, file: String, function: String, line: Int, metadata: [String: Any]?)
    func debug(_ message: String, category: String, file: String, function: String, line: Int, metadata: [String: Any]?)
    func info(_ message: String, category: String, file: String, function: String, line: Int, metadata: [String: Any]?)
    func warning(_ message: String, category: String, file: String, function: String, line: Int, metadata: [String: Any]?)
    func error(_ message: String, category: String, file: String, function: String, line: Int, metadata: [String: Any]?)
    func critical(_ message: String, category: String, file: String, function: String, line: Int, metadata: [String: Any]?)
}

final class Logger: LoggerProtocol {
    static let shared = Logger(providers: [
        // Keep console quiet: warnings/errors only (file still gets more detail if needed)
        ConsoleLogProvider(minLevel: .warning),
        FileLogProvider()
    ])
    
    private let providers: [LogProvider]
    private let queue: DispatchQueue
    
    init(providers: [LogProvider]) {
        self.providers = providers
        self.queue = DispatchQueue(label: "com.recime.logger", qos: .utility)
    }
    
    private func log(
        level: LogLevel,
        message: String,
        category: String,
        file: String,
        function: String,
        line: Int,
        metadata: [String: Any]?
    ) {
        let entry = LogEntry(
            timestamp: Date(),
            level: level,
            category: category,
            message: message,
            file: file,
            function: function,
            line: line,
            metadata: metadata
        )
        
        queue.async { [weak self] in
            self?.providers.forEach { $0.log(entry: entry) }
        }
    }
    
    func verbose(_ message: String, category: String = "App", file: String = #file, function: String = #function, line: Int = #line, metadata: [String: Any]? = nil) {
        log(level: .verbose, message: message, category: category, file: file, function: function, line: line, metadata: metadata)
    }
    
    func debug(_ message: String, category: String = "App", file: String = #file, function: String = #function, line: Int = #line, metadata: [String: Any]? = nil) {
        log(level: .debug, message: message, category: category, file: file, function: function, line: line, metadata: metadata)
    }
    
    func info(_ message: String, category: String = "App", file: String = #file, function: String = #function, line: Int = #line, metadata: [String: Any]? = nil) {
        log(level: .info, message: message, category: category, file: file, function: function, line: line, metadata: metadata)
    }
    
    func warning(_ message: String, category: String = "App", file: String = #file, function: String = #function, line: Int = #line, metadata: [String: Any]? = nil) {
        log(level: .warning, message: message, category: category, file: file, function: function, line: line, metadata: metadata)
    }
    
    func error(_ message: String, category: String = "App", file: String = #file, function: String = #function, line: Int = #line, metadata: [String: Any]? = nil) {
        log(level: .error, message: message, category: category, file: file, function: function, line: line, metadata: metadata)
    }
    
    func critical(_ message: String, category: String = "App", file: String = #file, function: String = #function, line: Int = #line, metadata: [String: Any]? = nil) {
        log(level: .critical, message: message, category: category, file: file, function: function, line: line, metadata: metadata)
    }
}
