//
//  FileLogProvider.swift
//  ReciMeProject
//
//  Created by Luis Pereira on 22/09/26.
//

import Foundation

final class FileLogProvider: LogProvider {
    private let fileManager = FileManager.default
    private let logFileURL: URL
    private let queue = DispatchQueue(label: "com.recime.filelog", qos: .utility)
    private var buffer: [String] = []
    private let bufferLimit = 10
    
    init() {
        let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        self.logFileURL = documentsPath.appendingPathComponent("recime_logs.txt")
        
        // Create file if doesn't exist
        if !fileManager.fileExists(atPath: logFileURL.path) {
            fileManager.createFile(atPath: logFileURL.path, contents: nil)
        }
    }
    
    func log(entry: LogEntry) {
        queue.async { [weak self] in
            guard let self = self else { return }
            
            let logLine = entry.formattedMessage + "\n\n"
            self.buffer.append(logLine)
            
            if self.buffer.count >= self.bufferLimit {
                self.flush()
            }
        }
    }
    
    func flush() {
        queue.async { [weak self] in
            guard let self = self, !self.buffer.isEmpty else { return }
            
            do {
                let fileHandle = try FileHandle(forWritingTo: self.logFileURL)
                fileHandle.seekToEndOfFile()
                
                let data = self.buffer.joined().data(using: .utf8)!
                fileHandle.write(data)
                fileHandle.closeFile()
                
                self.buffer.removeAll()
            } catch {
                print("⚠️ Failed to write logs to file: \(error)")
            }
        }
    }
}
