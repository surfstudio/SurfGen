//
//  ConfigExample.swift
//  
//
//  Created by Александр Кравченков on 13.10.2021.
//

import Foundation

public enum ConfigTemplates {
    public static let generator = """
    # if set to true then nullability will be determined by the `nullable` property of OpenAPI schema
    # if set to false then `required` will be used
    # for more info look at https://github.com/surfstudio/SurfGen#nullability
    useNewNullableDeterminationStrategy: true

    # Will remove listed prefixes from URIs in generated code
    prefixesToCutDownInServiceNames:
      - "/api/v1"

    templates:

    # This option will generate Interface (Protocol) for service

      - type: service
        nameSuffix: Service
        fileExtension: ${fileExtension}
        templatePath: ./Templates/v2/Swift/Service.txt
        destinationPath: ./trash/Sources/Services/{name}

    # This template will generate Implementation for service

      - type: service
        nameSuffix: Service
        fileExtension: ${fileExtension}
        templatePath: ./Templates/v2/Swift/NetworkService.txt
        destinationPath: ./trash/Sources/Services/{name}

    # This template will generate Business Model

      - type: model
        nameSuffix: Entity
        fileExtension: ${fileExtension}
        templatePath: ./Templates/v2/Swift/Entity.txt
        destinationPath: ./trash/Sources/Models/{name}

    # This template will generate Plain Model (for network communication)

      - type: model
        nameSuffix: Entry
        fileExtension: ${fileExtension}
        templatePath: ./Templates/v2/Swift/Entry.txt
        destinationPath: ./trash/Sources/Models/{name}

    # This template will generate alias on other types

      - type: typealias
        fileExtension: ${fileExtension}
        templatePath: ./Templates/v2/Swift/Typealias.txt
        destinationPath: ./trash/Sources/Aliases/{name}

    # This template will generate enum

      - type: enum
        fileExtension: ${fileExtension}
        fileNameCase: snakeCase # ATTENTION! Just for example that you can change naming pattern for files
        templatePath: ./Templates/v2/Swift/Entity.txt
        destinationPath: ./trash/Sources/Models/{name}

    # We use it to collect analytics about SurfGen usage inside our company.
    # You can set it to gather the analytics for your company or just delete it from config
    analytcsConfig:
        logstashEnpointURI: http://127.0.0.1:6644
        payload:
            project: Test
    """

    public static let linter = """
    analytcsConfig:
      logstashEnpointURI: http://logs.ps.surfstudio.ru
      payload:
        project: Test

    # List of files (not directories) which must be excluded from linting
    exclude:
      - "./api/auth/api.yaml"
    """

}
