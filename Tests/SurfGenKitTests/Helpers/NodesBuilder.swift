//
//  NodesBuilder.swift
//  ModelsCodeGenerationTests
//
//  Created by Mikhail Monakov on 27/11/2019.
//  Copyright © 2019 Surf. All rights reserved.
//

@testable import SurfGenKit

final class NodesBuilder {

    // MARK: - Model declaration nodes

    static func formShopLocationDeclNode() -> Node {
        return Node(token: .decl,
                    [
                        Node(token: .name(value: "ShopLocation"), []),
                        Node(token: .type(name: "object"), []),
                        Node(token: .content,
                             [
                                formFieldNode(isOptional: false, name: "region", typeName: "string"),
                                formFieldNode(isOptional: false, name: "city", typeName: "string"),
                                formFieldNode(isOptional: false, name: "address", typeName: "string"),
                                formFieldNode(isOptional: true, name: "floor", typeName: "string"),
                                formFieldNode(isOptional: true, name: "sector", typeName: "string"),
                                formFieldNode(isOptional: false,
                                              name: "geo_pos",
                                              typeName: "object",
                                              typeSubNodes: [Node(token: .type(name: "Geoposition"), [])])
                            ]
                        )
                    ]
        )
    }
    
    static func formShopDeclNode() -> Node {
        return Node(token: .decl,
                            [
                                Node(token: .name(value: "Shop"), []),
                                Node(token: .type(name: "object"), []),
                                Node(token: .description("Главная модель магазина"), []),
                                Node(token: .content,
                                     [
                                        formFieldNode(isOptional: false, name: "id", typeName: "string"),
                                        formFieldNode(isOptional: false, name: "name", typeName: "string", description: "Название магазина"),
                                        formFieldNode(isOptional: false, name: "phone", typeName: "string"),
                                        formFieldNode(isOptional: false,
                                                      name: "location",
                                                      typeName: "object",
                                                      typeSubNodes: [Node(token: .type(name: "ShopLocation"), [])]),
                                        formFieldNode(isOptional: true, name: "working_hours", typeName: "string", description: "Время работы магазина. Может содержать строку в формате \"10.00-22.00\", если время работы магазина не зависит от дня недели. Либо строку формата \"пт-сб 10.00-23.00\" в противном случае.")
                                     ]
                                )
                            ]
        )
    }

    static func formProfileCustomDataNode() -> Node {
        return Node(token: .decl,
                    [
                        Node(token: .name(value: "ProfileCustomData"), []),
                        Node(token: .type(name: "object"), []),
                        Node(token: .content,
                             [
                                formFieldNode(isOptional: true,
                                              name: "children",
                                              typeName: "array",
                                              typeSubNodes: [Node(token: .type(name: "object"),
                                                                  [Node(token: .type(name: "Child"), [])])]),
                                formFieldNode(isOptional: false, name: "age", typeName: "integer"),
                                formFieldNode(isOptional: true, name: "additional_info", typeName: "string")
                            ]
                        )
                    ]
        )
    }

    static func formTokenDeclNode() -> Node {
        return Node(token: .decl,
                    [
                        Node(token: .name(value: "ContactToken"), []),
                        Node(token: .type(name: "object"), []),
                        Node(token: .content,
                             [
                                formFieldNode(isOptional: false,
                                              name: "contactToken",
                                              typeName: "string"),
                                formFieldNode(isOptional: true,
                                              name: "id",
                                              typeName: "string"),
                                formFieldNode(isOptional: false,
                                              name: "value",
                                              typeName: "integer")
                            ]
                        )
            ]
        )
    }

    static func formDelivetyTypeDeclNode() -> Node {
        return Node(token: .decl,
                    [
                        Node(token: .name(value: "DeliveryType"), []),
                        Node(token: .type(name: ASTConstants.enum), [Node(token: .type(name: "string"), [])]),
                        Node(token: .description("Тип оплаты\n* 0 - Оплата при получении\n* 1 - Оплата картой онлайн\n* 2 - Оплата Google Pay / Apple Pay"), []),
                        Node(token: .content,
                             [
                                Node(token: .value("CDEK"), []),
                                Node(token: .value("PickPoint"), []),
                                Node(token: .value("Amazon"), [])
                            ]
                        )
            ]
        )
    }

    static func formOrderCancelReasonDeclNode() -> Node {
        return Node(token: .decl,
                    [
                        Node(token: .name(value: "OrderCancelReason"), []),
                        Node(token: .type(name: ASTConstants.enum), [Node(token: .type(name: "integer"), [])]),
                        Node(token: .content,
                             [
                                Node(token: .value("0"), []),
                                Node(token: .value("1"), []),
                                Node(token: .value("2"), [])
                            ]
                        )
            ]
        )
    }

    // MARK: - MediaContent nodes

    static func formJsonEncodedModelContentNode() -> ASTNode {
        return Node(token: .mediaContent,
                    [
                        Node(token: .encoding(type: "application/json"), []),
                        Node(token: .type(name: "Pet"), [])
                    ]
        )
    }

    static func formJsonEncodedArrayContentNode() -> ASTNode {
        return Node(token: .mediaContent,
                    [
                        Node(token: .encoding(type: "application/json"), []),
                        Node(token: .type(name: "array"),
                             [
                                Node(token: .type(name: "Pet"), [])
                             ]
                        )
                    ]
        )
    }

    static func formFormEncodedObjectContentNode() -> ASTNode {
        return Node(token: .mediaContent,
                    [
                       Node(token: .encoding(type: "application/x-www-form-urlencoded"), []),
                       Node(token: .type(name: "object"),
                            [
                               Node(token: .field(isOptional: false),
                                    [
                                       Node(token: .name(value: "testIntValue"), []),
                                       Node(token: .type(name: "integer"), [])
                                    ]
                               ),
                               Node(token: .field(isOptional: false),
                                    [
                                       Node(token: .name(value: "testDoubleValue"), []),
                                       Node(token: .type(name: "number"), [])
                                    ]
                               ),
                               Node(token: .field(isOptional: false),
                                    [
                                       Node(token: .name(value: "testBoolValue"), []),
                                       Node(token: .type(name: "boolean"), [])
                                    ]
                               )
                            ]
                       )
                    ]
        )
    }

    static func formMultipartModelContentNode() -> ASTNode {
        return Node(token: .mediaContent,
                    [
                        Node(token: .encoding(type: "multipart/form-data"), []),
                        Node(token: .type(name: "Image"), [])
                    ]
        )
    }

    static func formUnsupportedEncodingContentNode() -> ASTNode {
        return Node(token: .mediaContent,
                    [
                        Node(token: .encoding(type: "testEncoding"), []),
                        Node(token: .type(name: "Model"), [])
                    ]
        )
    }

    static func formMultipleOptionsContentNode() -> ASTNode {
        return Node(token: .mediaContent,
                    [
                        Node(token: .encoding(type: "application/json"), []),
                        Node(token: .type(name: "group"),
                             [
                                Node(token: .type(name: "Dog"), []),
                                Node(token: .type(name: "Cat"), []),
                                Node(token: .type(name: "Parrot"), [])
                             ]
                        )
                    ]
        )
    }

    // MARK: - Request/response body nodes

    static func formRequestBodyNode(with content: ASTNode) -> ASTNode {
        return Node(token: .requestBody(isOptional: false), [content])
    }

    static func formResponseBodyNode(with content: ASTNode) -> ASTNode {
        return Node(token: .responseBody, [content])
    }

    // MARK: - Operation nodes

    static func formPostPetByIdOperationNode() -> ASTNode {
        return Node(token: .operation,
                    [
                        Node(token: .type(name: "post"), []),
                        Node(token: .path(value: "/pet/{petId}"), []),
                        Node(token: .requestBody(isOptional: false),
                             [
                                formJsonEncodedModelContentNode()
                             ]
                        ),
                        Node(token: .parameters,
                             [
                                Node(token: .parameter(isOptional: false),
                                     [
                                        Node(token: .name(value: "petId"), []),
                                        Node(token: .type(name: "string"), []),
                                        Node(token: .location(type: "path"), [])
                                     ]
                                )
                             ]
                        )
                    ]
        )
    }

    static func formFindPetByStatusOperationNode() -> ASTNode {
        return Node(token: .operation,
                    [
                        Node(token: .type(name: "get"), []),
                        Node(token: .path(value: "/pet/findByStatus"), []),
                        Node(token: .description("Finds Pets by status"), []),
                        Node(token: .requestBody(isOptional: false),
                             [
                                formFormEncodedObjectContentNode()
                             ]
                        ),
                        Node(token: .parameters,
                             [
                                Node(token: .parameter(isOptional: false),
                                     [
                                        Node(token: .name(value: "status"), []),
                                        Node(token: .type(name: "string"), []),
                                        Node(token: .location(type: "query"), [])
                                     ]
                                )
                             ]
                        ),
                        Node(token: .responseBody,
                             [
                                formJsonEncodedArrayContentNode()
                             ]
                        )
                    ]
        )
    }

    static func formPostDifferentPetsOperationNode() -> ASTNode {
        return Node(token: .operation,
                    [
                        Node(token: .type(name: "post"), []),
                        Node(token: .path(value: "/pet/differentPets"), []),
                        Node(token: .description("Posts any kind of a pet"), []),
                        Node(token: .requestBody(isOptional: false),
                             [
                                formMultipleOptionsContentNode()
                             ]
                        )
                    ]
        )
    }

    // MARK: - Service declaration nodes

    static func formTestServiceDeclarationNode() -> ASTNode {
        return Node(token: .decl,
                    [
                        Node(token: .name(value: "Pet"), []),
                        Node(token: .content,
                             [
                                formPostPetByIdOperationNode(),
                                formFindPetByStatusOperationNode()
                             ]
                        )
                    ]
        )
    }

}
