//
//  RendezvousService.swift
//  
//
//  Created by Дмитрий on 17.10.2020.
//

enum RendezvousService: String, TestService, CaseIterable {
    case profile = "Profile"
    case cities = "Cities"
    case cart = "Cart"

    var matchingPaths: Set<String> {
        switch self {
        case .profile:
            return ["/profile",
                    "/profile/foot_sizes",
                    "/profile/update/sms_code/",
                    "/profile/update/phone",
                    "/profile/update/email",
                    "/profile/password",
                    "/profile/feed",
                    "/profile/card/hash",
                    "/profile/foot_sizes"]
        case .cities:
            return ["/cities",
                    "/cities/{id}/shops",
                    "/cities/geopos"]
        case .cart:
            return ["/cart",
                    "/cart/promocode",
                    "/cart/check"]
        }
    }

    var pathsWithoutDeprecated: Set<String> {
        return matchingPaths
    }

}
