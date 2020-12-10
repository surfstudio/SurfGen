//
//  XcodeProjManager.swift
//  surfgen
//
//  Created by Mikhail Monakov on 22/02/2020.
//  Copyright © 2020 Surf. All rights reserved.
//

import XcodeProj
import PathKit

enum XcodeProjError: Error {
    case cantFindMainGroup(String)
    case filePathIsNotInMainGroup(String)
    case cantFindGroupForFilePath(String)

    var localizedDescription: String {
        switch self {
        case .cantFindMainGroup(let dirName):
            return "Provided main group name \(dirName) can not be found"
        case .filePathIsNotInMainGroup(let filePath):
            return "Provided files path \(filePath) does not in provided main group"
        case .cantFindGroupForFilePath(let filePath):
            return "Project does not have group for file at path: \(filePath)"
        }
    }

}

final class XcodeProjManager {

    private let proj: XcodeProj
    private let projPath: Path
    private let mainGroupName: String

    init(project: Path, mainGroupName: String) throws {
        self.proj = try XcodeProj(path: project)
        self.projPath = project
        self.mainGroupName = mainGroupName
    }

    func addFiles(filePaths: [Path], targets: [String]) throws {

        guard let mainGroup = proj.pbxproj.projects.first?.mainGroup.children.first(where: { $0.path == mainGroupName }) as? PBXGroup else {
            throw XcodeProjError.cantFindMainGroup(mainGroupName)
        }

        let targets = proj.pbxproj.nativeTargets.filter { targets.contains($0.name) }


        try filePaths.forEach { try addFile(path: $0, mainGroup: mainGroup, targets: targets) }

        try proj.write(path: projPath)
    }

    func findExistingFiles(_ fileNames: [String]) -> [String] {
        return fileNames.filter { isFileExist(fileName: $0) }
    }

    func isFileExist(fileName: String) -> Bool {
        return proj.pbxproj.buildFiles.first { $0.file?.path == fileName } != nil
    }

    private func addFile(path: Path, mainGroup: PBXGroup, targets: [PBXNativeTarget]) throws {
        // remove last component with file name
        let components = path.components.dropLast()

        // find path components that are relative to main group name
        guard let index = components.firstIndex(where: { $0 == mainGroupName }) else {
            throw XcodeProjError.filePathIsNotInMainGroup(path.components.joined(separator: "/"))
        }

        // remove main group component
        let subComponents = components[index...].dropFirst()

        // find group for
        guard let groupToBeAdded = mainGroup.group(for: Array(subComponents)) else {
            throw XcodeProjError.cantFindGroupForFilePath(path.components.joined(separator: "/"))
        }

        // remove .xcodeproj file from path
        let sourceRoot = Path(projPath.components.dropLast().joined(separator: "/"))
        let fileReference = try groupToBeAdded.addFile(at: path, sourceRoot: sourceRoot)

        try targets.forEach { _ = try $0.sourcesBuildPhase()?.add(file: fileReference) }
    }

}

public extension PBXGroup {

    func group(for components: [String]) -> PBXGroup? {
        var iteratorGroup: PBXGroup? = self
        for component in components {
            let subgroup = iteratorGroup?.children.first(where: { $0.path == component }) as? PBXGroup
            if subgroup == nil {
                do {
                    iteratorGroup = try iteratorGroup?.addGroup(named: component).first
                } catch {
                    return nil
                }
            } else {
                iteratorGroup = subgroup
            }
        }
        return iteratorGroup
    }

}
