//
//  LinitingConfig.swift
//  
//
//  Created by Александр Кравченков on 07.01.2021.
//

import Foundation

public struct LintingConfig: Decodable {
    /// Contains file pathes which should be escluded from linting
    ///
    /// **WARNING**
    ///
    /// Patch should be path to file. Not to dir.
    var exclude: [String]
}
