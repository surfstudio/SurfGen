//
//  main.swift
//  surfgen
//
//  Created by Mikhail Monakov on 04/01/2020.
//  Copyright © 2020 Surf. All rights reserved.
//

import SwiftCLI
import XcodeProj

let version = "0.0.1"
let cli = CLI(name: "surfgen",
              version: version,
              description: "surfgen code generator",
              commands: [GenerateCommand()])
cli.go(with: [
    "generate", "/Users/monakov/Development/openapi.yaml",
    "-m", "UserLocations", "-t", "nodeKitEntry"
])

