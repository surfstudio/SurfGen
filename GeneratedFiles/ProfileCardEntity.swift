
import NodeKit

public struct ProfileCardEntity {

    // MARK: - Public Properties

    public let discount: Int?
    public let discountOnUpgrade: Int?
    public let isBlocked: Bool?
    public let number: String?
    public let spend: String?
    public let spendToUpgrade: String?

    // MARK: - Initialization

    public init(discount: Int?,
                discountOnUpgrade: Int?,
                isBlocked: Bool?,
                number: String?,
                spend: String?,
                spendToUpgrade: String?) {
        self.discount = discount
        self.discountOnUpgrade = discountOnUpgrade
        self.isBlocked = isBlocked
        self.number = number
        self.spend = spend
        self.spendToUpgrade = spendToUpgrade
    }

}

// MARK: - DTOConvertible

extension ProfileCardEntity: DTOConvertible {

    public static func from(dto model: ProfileCardEntry) throws -> ProfileCardEntity {
        return .init(discount: model.discount,
                         discountOnUpgrade: model.discount_on_upgrade,
                         isBlocked: model.is_blocked,
                         number: model.number,
                         spend: model.spend,
                         spendToUpgrade: model.spend_to_upgrade)
    }

    public func toDTO() throws -> ProfileCardEntry {
        return .init(discount: discount,
                         discount_on_upgrade: discountOnUpgrade,
                         is_blocked: isBlocked,
                         number: number,
                         spend: spend,
                         spend_to_upgrade: spendToUpgrade)
    }

}
