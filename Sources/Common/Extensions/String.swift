//
//  File.swift
//  
//
//  Created by Александр Кравченков on 13.12.2020.
//

import Foundation

extension String {
    func tabShifted() -> String {
        return self.replacingOccurrences(of: "\n", with: "\n\t")
    }
}
