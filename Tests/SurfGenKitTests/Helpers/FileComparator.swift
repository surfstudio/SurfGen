//
//  FileComparator.swift
//  
//
//  Created by Dmitry Demyanov on 27.11.2020.
//

class FileComparator {

    
    /// Compares files by lines
    /// - Parameters:
    ///   - realFile: generated file text
    ///   - expectedFile: expected file text
    /// - Returns: all lines which are different in provided files
    func getDifference(for realFile: String, expectedFile: String) -> String {
        let realLines = realFile.components(separatedBy: "\n")
        let expectedLines = expectedFile.components(separatedBy: "\n")
        
        return realLines.enumerated().reduce("Different lines:\n") { result, nextLine in
            let (index, line) = nextLine
            let expectedLine = index < expectedLines.count ? expectedLines[index] : ""
            return line == expectedLine ? result : result + "\n#\(index)\n\(line)\n\(expectedLine)\n"
        }
    }

}
