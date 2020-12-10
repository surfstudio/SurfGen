//
//  String.swift
//  
//
//  Created by Dmitry Demyanov on 02.12.2020.
//

extension String {

    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

}
