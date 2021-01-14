//
//  String.swift
//  
//
//  Created by Александр Кравченков on 13.12.2020.
//

import Foundation

extension String {
    /// Shift each `\n` on one `\t`
    public func tabShifted() -> String {
        return self.replacingOccurrences(of: "\n", with: "\n\t")
    }
}
