//
//  LogEntry.swift
//  ReciMeProject
//
//  Created by Luis Pereira on 22/09/26.
//

import Foundation

struct LogEntry {
    let timestamp: Date
    let level: LogLevel
    let category: String
    let message: String
    let file: String
    let function: String
    let line: Int
    let metadata: [String: Any]?
    
    var formattedMessage: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        let time = formatter.string(from: timestamp)
        let fileName = (file as NSString).lastPathComponent
        
        var msg = """
        \(level.emoji) [\(level.name)] \(time)
        📂 \(category) | 📄 \(fileName):\(line) - \(function)
        💬 \(message)
        """
        
        if let metadata = metadata, !metadata.isEmpty {
            msg += "\n📦 Metadata: \(metadata)"
        }
        
        return msg
    }
}
