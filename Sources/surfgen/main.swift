//
//  main.swift
//  surfgen
//
//  Created by Mikhail Monakov on 04/01/2020.
//  Copyright © 2020 Surf. All rights reserved.
//

import SwiftCLI
import SurfGenKit

let version = "4.3.0"
let cli = CLI(name: "swaggen", version: version, description: "Swagger code generator", commands: [])
cli.goAndExit()
let root = RootGenerator()
root.

