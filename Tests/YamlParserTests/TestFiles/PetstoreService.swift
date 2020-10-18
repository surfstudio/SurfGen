//
//  PetstoreService.swift
//  
//
//  Created by Dmitry Demyanov on 18.10.2020.
//

enum PetstoreService: String, TestService, CaseIterable {
    case pet = "Pet"
    case store = "Store"
    case user = "User"

    var matchingPaths: Set<String> {
        switch self {
        case .pet:
            return ["/pet",
                    "/pet/findByStatus",
                    "/pet/findByTags",
                    "/pet/{petId}",
                    "/pet/{petId}/uploadImage"]
        case .store:
            return ["/store/inventory",
                    "/store/order",
                    "/store/order/{orderId}"]
        case .user:
            return ["/user",
                    "/user/createWithList",
                    "/user/login",
                    "/user/logout",
                    "/user/{username}"]
        }
    }

    var pathsWithoutDeprecated: Set<String> {
        switch self {
        case .pet:
            return matchingPaths.subtracting(["/pet/findByTags"])
        case .store:
            return matchingPaths
        case .user:
            return matchingPaths
        }
    }

}
