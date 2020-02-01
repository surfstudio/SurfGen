//
//  GenerateCommand.swift
//  
//
//  Created by Mikhail Monakov on 01/02/2020.
//

import SwiftCLI
import SurfGenKit
import Foundation

final class GenerateCommand: Command {

    let name = "generate"
    let shortDescription = "Generates models for provided spec"

    let spec = SwiftCLI.Parameter()

    func execute() throws  {

        let specURL: URL
        if URL(string: spec.value)?.scheme == nil {
            let path = Path(spec.value).normalize()
            guard path.exists else {
                exitWithError("Could not find spec at \(path)")
            }
            specURL = URL(fileURLWithPath: path.string)
        } else if let url = URL(string: spec.value) {
            specURL = url
        } else {
            exitWithError("No valid spec parameter. It can be a path or a url")
        }

        let root = RootGenerator(tempatesPath: "./Templates")
        let node = Node(token: .root, [
            Node(token: .decl, [
                Node(token: .name(value: "Test"), []),
                Node(token: .content, [
                    Node(token: .field(isOptional: false), [
                        Node(token: .name(value: "testNameOfField"), []),
                        Node(token: .type(name: "Int"), [])
                    ])
                ])
            ])
        ])

        do {
            let generatedCode = try root.generateCode(for: node, type: .entity)
            stdout <<< generatedCode.first?.0 ?? "error"
            stdout <<< generatedCode.first?.1 ?? "error"
        } catch {
            dump(error)
        }
    }

}
