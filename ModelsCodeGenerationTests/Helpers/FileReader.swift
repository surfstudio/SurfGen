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
        guard let filepath = Bundle(for: type(of: self)).path(forResource: name, ofType: ext) else {
            fatalError("Can not load test file with name \(name)")
        }
        do {
            return try String(contentsOfFile: filepath)
        } catch {
            fatalError("Error while file reading with name: \(name), error: \(error.localizedDescription)")
        }
    }

}
