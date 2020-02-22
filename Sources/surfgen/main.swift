//
//  main.swift
//  surfgen
//
//  Created by Mikhail Monakov on 04/01/2020.
//  Copyright © 2020 Surf. All rights reserved.
//

import SwiftCLI
import XcodeProj

let version = "4.3.0"
let cli = CLI(name: "surfgen", version: version,
              description: "surfgen code generator",
              commands: [GenerateCommand()])
cli.go(with: ["generate", "./rendezvous.yaml",
              "-m", "Profile",
              "-t", "nodeKitEntity",
              "-d", "/Users/monakov/Development/rendez-vous-ios/Common/Models/Entity/ProfileEntity.swift",
              "-p", "/Users/monakov/Development/rendez-vous-ios/Common/Models/Models.xcodeproj"])

