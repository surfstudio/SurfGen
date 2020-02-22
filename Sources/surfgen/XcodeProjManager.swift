//
//  XcodeProjManager.swift
//  surfgen
//
//  Created by Mikhail Monakov on 22/02/2020.
//  Copyright © 2020 Surf. All rights reserved.
//

import XcodeProj
import PathKit

final class XcodeProjManager {

    private let proj: XcodeProj
    private let projPath: Path

    init(project: Path) throws {
        self.proj = try XcodeProj(path: project)
        self.projPath = project
    }

//    func addFiles(filePaths: [Path], targets: [String]) throws {
//        let pbxproj = proj.pbxproj
////        let fileRef = try pbxproj.projects.first?.mainGroup.addFile(at: , sourceRoot: projPath)
//
////        try pbxproj.nativeTargets.forEach {
////            if $0.name == "Models" {
////                let tmp = try $0.sourcesBuildPhase()?.add(file: element)
////            }
////        }
//
//        try proj.write(path: projPath, override: true)
//    }

//    func findGroup(for path: Path, in group: PBXGroup) -> PBXGroup? {
//        let pbxproj = proj.pbxproj
//        pbxproj.projects.first?.mainGroup.children
//
//    }

}
