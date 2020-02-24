//
//  FileReader.swift
//  ModelsCodeGenerationTests
//
//  Created by Mikhail Monakov on 23/11/2019.
//  Copyright © 2019 Surf. All rights reserved.
//

import Foundation

final class FileReader {

    func readFile(_ name: String, _ ext: String) -> String {
        let thisSourceFile = URL(fileURLWithPath: #file)
        let thisDirectory = thisSourceFile.deletingLastPathComponent()
        let resourceURL = thisDirectory.appendingPathComponent(name)
        print(resourceURL)
        do {
            let data = try Data(contentsOf: resourceURL)
            return String(data: data, encoding: .utf8) ?? "Nil"
        } catch {
            fatalError(error.localizedDescription)
        }
    }

}

