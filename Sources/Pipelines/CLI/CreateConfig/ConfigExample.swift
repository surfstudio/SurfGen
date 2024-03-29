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
    
    # If is not empty than models will be generated to separated packages according specification.
    # Useful for Kotlin projects.
    # for more info look at https://github.com/surfstudio/SurfGen#package-separation
    specificationRootPath: ""

    # Will remove listed prefixes from method names
    # for detais look at https://github.com/surfstudio/SurfGen#prefix-cutting
    prefixesToCutDownInServiceNames:
      - "/api/v1"

    # Will remove OpenAPI node by path /components/schemas/BadModel
    # in file Tests/Common/NodeExcluding/models.yaml
    #
    # At run time. It doesn't touch real files
    #
    # In generated code all referenсes to removed nodes will be generated as `TODO` string
    #
    # You can remove by this leaf nodes like:
    # - /components/schemas/*
    # - /components/parameters/*
    # - /components/header/*
    # - /components/responses/*
    # - /components/requestBodies/*
    # - /paths/**/*
    #
    # To exclude specific operation you can write something like
    # /paths/api/v1.1/auth~post
    # Where:
    # - `paths` - constant from OpenAPI specification
    # - `/api/v1.1/auth` - method URI (just like in specification)
    # - `post` - operation (you can skip it to remove whole method). Symbol ~ is used to mark specific operation.
    exludedNodes:
      - "Tests/Common/NodeExcluding/models.yaml#/components/schemas/BadModel"
      - "Tests/Common/NodeExcluding/api.yaml#/paths/api/v1.1/superAuth~delete"

    templates:

    # This option will generate Interface (Protocol) for service

      - type: service
        nameSuffix: Service
        fileExtension: ${fileExtension}
        templatePath: ./Templates/v2/Swift/Service.stencil
        destinationPath: ./tmp/Sources/Services/{name}

    # This template will generate Implementation for service

      - type: service
        nameSuffix: NetworkService
        fileExtension: ${fileExtension}
        templatePath: ./Templates/v2/Swift/NetworkService.stencil
        destinationPath: ./tmp/Sources/Services/{name}

    # This template will generate Business Model

      - type: model
        nameSuffix: Entity
        fileExtension: ${fileExtension}
        templatePath: ./Templates/v2/Swift/Entity.stencil
        destinationPath: ./tmp/Sources/Models/{name}

    # This template will generate Plain Model (for network communication)

      - type: model
        nameSuffix: Entry
        fileExtension: ${fileExtension}
        templatePath: ./Templates/v2/Swift/Entry.stencil
        destinationPath: ./tmp/Sources/Models/{name}

    # This template will generate alias on other types

      - type: typealias
        fileExtension: ${fileExtension}
        templatePath: ./Templates/v2/Swift/Typealias.stencil
        destinationPath: ./tmp/Sources/Aliases/{name}

    # This template will generate enum

      - type: enum
        fileExtension: ${fileExtension}
        fileNameCase: snakeCase # ATTENTION! Just for example that you can change naming pattern for files
        templatePath: ./Templates/v2/Swift/Entity.stencil
        destinationPath: ./tmp/Sources/Models/{name}

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
    
    # Will remove OpenAPI node by path /components/schemas/BadModel
    # in file Tests/Common/NodeExcluding/models.yaml
    #
    # At run time. It doesn't touch real files
    #
    # You can remove by this leaf nodes like:
    # - /components/schemas/*
    # - /components/parameters/*
    # - /components/header/*
    # - /components/responses/*
    # - /components/requestBodies/*
    # - /paths/**/*
    #
    # To exclude specific operation you can write something like
    # /paths/api/v1.1/auth~post
    # Where:
    # - `paths` - constant from OpenAPI specification
    # - `/api/v1.1/auth` - method URI (just like in specification)
    # - `post` - operation (you can skip it to remove whole method). Symbol ~ is used to mark specific operation.
    exludedNodes:
      - "Tests/Common/NodeExcluding/models.yaml#/components/schemas/BadModel"
      - "Tests/Common/NodeExcluding/api.yaml#/paths/api/v1.1/superAuth~delete"
    """

}
