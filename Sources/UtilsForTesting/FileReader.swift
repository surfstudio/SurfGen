//
//  File.swift
//  
//
//  Created by Александр Кравченков on 29.12.2020.
//

import Foundation

public enum FileReader {

    public static func readFile(_ filePath: String, readSource: String = #file) throws -> String {
        let thisSourceFile = URL(fileURLWithPath: readSource)
        let thisDirectory = thisSourceFile.deletingLastPathComponent()
        let resourceURL = thisDirectory.appendingPathComponent(filePath)
        let data = try Data(contentsOf: resourceURL)
        return String(data: data, encoding: .utf8) ?? "Nil"
    }

}
