//
//  BuildGastTreeParseDependenciesSatage.swift
//  
//
//  Created by Александр Кравченков on 13.12.2020.
//

import Foundation
import GASTBuilder

public struct BuildGastTreeParseDependenciesSatage: PipelineEntryPoint {

    let builder: GASTBuilder

    public func run(with input: [String]) throws {

        input.forEach { path in
            do {
                try self.builder.build(filePath: path)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
