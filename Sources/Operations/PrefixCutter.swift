//
//  PrefixCutter.swift
//  
//
//  Created by Александр Кравченков on 20.08.2021.
//

import Foundation

public struct PrefixCutter {
    let prefixesToCut: Set<String>

    public init(prefixesToCut: Set<String>) {
        self.prefixesToCut = prefixesToCut
    }
}

extension PrefixCutter {

    public func Run(urlToCut: String) -> String? {
        for item in self.prefixesToCut {

            guard
                let range = urlToCut.range(of: item),
                range.lowerBound == urlToCut.startIndex
            else {
                continue
            }

            return String(urlToCut[range.upperBound...])
        }

        return nil
    }
}
