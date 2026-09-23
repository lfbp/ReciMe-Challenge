//
//  ConsoleLogProvider.swift
//  ReciMeProject
//
//  Created by Luis Pereira on 22/09/26.
//

import Foundation

protocol LogProvider {
    func log(entry: LogEntry)
    func flush()
}

final class ConsoleLogProvider: LogProvider {
    private let minLevel: LogLevel
    
    init(minLevel: LogLevel = .debug) {
        self.minLevel = minLevel
    }
    
    func log(entry: LogEntry) {
        guard entry.level >= minLevel else { return }
        print(entry.formattedMessage)
        print("---")
    }
    
    func flush() {
        // Console doesn't need flushing
    }
}
