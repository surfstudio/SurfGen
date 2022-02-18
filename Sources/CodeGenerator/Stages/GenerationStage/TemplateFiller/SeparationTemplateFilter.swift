//
//  SeparationTemplateFilter.swift
//  
//
//  Created by volodina on 17.02.2022.
//

import Foundation
import Stencil

/// A template filter which handles `getPackageName` extension for defined root path
public class SeparationTemplateFilter : DefaultTemplateFiller {
    
    public let specificationRootPath: String

    public init(specificationRootPath: String) {
        self.specificationRootPath = specificationRootPath
    }

    override func buildTemplateExtension() -> Extension {
        let templateExtension = super.buildTemplateExtension()

        templateExtension.registerStringFilter("getPackageName") {
            $0.getPackageName(root: self.specificationRootPath)
        }
                 
        return templateExtension
    }
}
