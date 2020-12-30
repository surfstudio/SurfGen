//
//  ConfigModel.swift
//  surfgen
//
//  Created by Mikhail Monakov on 20/03/2020.
//

import PathKit

struct ConfigModel: Decodable {
    let platform: String

    let entitiesPath: String?
    let entriesPath: String?
    let enumPath: String?

    let endpointsPath: String?
    let servicesPath: String?

    let modelTypes: [String]?
    let generateDescriptions: Bool?
    let templatesPath: String
    let blackList: String?

    let projectPath: String?
    let mainGroup: String?
    let targets: [String]?

    let gitlabToken: String?

    enum CodingKeys: String, CodingKey {
        case platform = "platform"
        case entitiesPath = "entities_path"
        case entriesPath = "entries_path"
        case enumPath = "enums_path"

        case endpointsPath = "endpoints_path"
        case servicesPath = "services_path"

        case projectPath = "project_path"
        case mainGroup = "project_main_group"
        case targets = "targets"

        case modelTypes = "generation_types"
        case generateDescriptions = "generate_descriptions"
        case templatesPath = "templates_path"
        case blackList = "black_list_path"

        case gitlabToken = "gitlab_token"
    }

}
