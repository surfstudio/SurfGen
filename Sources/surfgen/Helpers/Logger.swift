//
//  Logger.swift
//  
//
//  Created by Dmitry Demyanov on 01.12.2020.
//

import Foundation
import SwiftCLI
import SurfGenKit
import PathKit

class Logger {

    func print(_ string: String) {
        Term.stdout <<< string
    }

    func printAsList(_ list: [String]) {
        Term.stdout <<< "---------------------------------------".bold
        list.forEach { Term.stdout <<< "• " + $0 }
        Term.stdout <<< "---------------------------------------\n".bold
    }

    func printGenerationResult(_ result: [ModelType: [Path]]) {
        result.forEach {
            switch $0.key {
            case .entity:
                printListWithHeader("Next Enities were generated:".green, list: $0.value.map { $0.lastComponent })
            case .entry:
                printListWithHeader("Next Entries were generated".green, list: $0.value.map { $0.lastComponent })
            case .enum:
                printListWithHeader("Next Enums were generated".green, list: $0.value.map { $0.lastComponent })
            }
        }
    }

    func printGenerationResult(_ result: [ServicePart: Path]) {
        result.forEach {
            Term.stdout <<< "\($0.key.rawValue.capitalizingFirstLetter()): ".green + $0.value.lastComponent
        }
    }

    func printListWithHeader(_ header: String, list: [String]) {
        guard !list.isEmpty else { return }
        Term.stdout <<< header
        printAsList(list)
    }

    func exitWithError(_ string: String) -> Never {
        Term.stderr <<< string.red
        exit(EXIT_FAILURE)
    }

}
