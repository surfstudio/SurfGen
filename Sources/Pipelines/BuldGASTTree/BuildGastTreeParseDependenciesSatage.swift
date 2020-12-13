//
//  BuildGastTreeParseDependenciesSatage.swift
//  
//
//  Created by Александр Кравченков on 13.12.2020.
//

import Foundation
import GASTBuilder
import Common

public struct BuildGastTreeParseDependenciesSatage: PipelineEntryPoint {

    let builder: GASTBuilder

    public func run(with input: [String]) throws {

        // there is a problem here
        // we don't now how `input` which is absolute path
        // is connectd to $ref string
        //
        // for example: $ref: "models.yaml#..."
        //
        // it may be `/User/temp/spec/catalog/models.yaml`
        // and at the same time it might be ``/User/temp/spec/auth/models.yaml``
        //
        // So we can solve it in two ways
        //
        // First (and seems like right) is not just extract refs as string array, but as arrray of complex data struture like:
        //
        // struct Dependencies {
        //
        //     let rootFile: String
        //     let rawRef: [String: String]
        //
        // }
        //
        // and rootFile will be spec which is parsed now
        // and rawRef is a key-value pairs where key is $ref value
        // and value is a path to specification
        //
        // for example if we have:
        //
        // api.yaml
        //     models.yaml#... -> User/temp/spec/catalog/models.yaml
        //     ../common/models.yaml#... -> User/temp/spec/catalog/../common/models.yaml
        //
        // then it will be:
        //
        // {
        //     rootFile: "User/temp/spec/catalog/api.yaml"
        //     rawRef: {
        //         "models.yaml": "User/temp/spec/catalog/models.yaml"
        //         "../common/models.yaml": "User/temp/spec/catalog/../common/models.yaml"
        //     }
        // }
        //
        //
        // and fo shure. It's exatcly called header

        var trees = [String: RootNode]()

        try input.forEach { path in
            let root = try wrap(self.builder.build(filePath: path),
                                message: "Error occured in stage `Build GAST for dependencies`")
            trees[path] = root
        }


    }
}
