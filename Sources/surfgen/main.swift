//
//  main.swift
//  surfgen
//
//  Created by Mikhail Monakov on 04/01/2020.
//  Copyright © 2020 Surf. All rights reserved.
//

import SwiftCLI

let version = "4.3.0"
let cli = CLI(name: "surfgen", version: version,
              description: "surfgen code generator",
              commands: [GenerateCommand()])
cli.goAndExit()

