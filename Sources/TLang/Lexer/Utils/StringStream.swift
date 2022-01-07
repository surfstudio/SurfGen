//
//  SymbolStream.swift
//  
//
//  Created by Александр Кравченков on 05.01.2022.
//

import Foundation

/// Converts string to stream from which consumers can read cahracter by character
/// Makes it possible to hide file reading implementation
///
/// Implements Copy On Write for intetrnal string so it wont be copied each time you reassign value
public struct SymbolStream {
    private let fileContent: CopyOnWriteBox<String>
    private var currentIndex: String.Index
    
    init(pathToFile: String) throws {
        self.fileContent = .init(try String.init(contentsOfFile: pathToFile))
        self.currentIndex = fileContent.value.startIndex
    }
    
    /// Reads current element and move pointer to next symbol
    mutating func pop() -> Character {
        let result = self.current()
        self.currentIndex = self.fileContent.value.index(after: self.currentIndex)
        return result
    }
    
    /// Read symbol under the pointer (on which pointer points)
    func current() -> Character {
        return self.fileContent.value[self.currentIndex]
    }
    
    func copy() -> SymbolStream {
        return self
    }
}

