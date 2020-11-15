//
//  FileReader.swift
//  surfgenTests
//
//  Created by Mikhail Monakov on 06/01/2020.
//  Copyright © 2020 Surf. All rights reserved.
//

import Foundation

final class FileReader {

    func readFile(_ filePath: String) -> String {
        let thisSourceFile = URL(fileURLWithPath: #file)
        let thisDirectory = thisSourceFile.deletingLastPathComponent()
        let resourceURL = thisDirectory.appendingPathComponent(filePath)
        do {
            let data = try Data(contentsOf: resourceURL)
            return String(data: data, encoding: .utf8) ?? "Nil"
        } catch {
            fatalError(error.localizedDescription)
        }
    }

}
