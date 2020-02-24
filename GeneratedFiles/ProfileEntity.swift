
import NodeKit

public struct ProfileEntity {

    // MARK: - Public Properties

    public let card: ProfileCardEntity?
    public let email: String?
    public let id: String?
    public let phone: String?
    public let birthday: String?
    public let firstName: String?
    public let footSize: String?
    public let gender: Int?
    public let lastName: String?
    public let middleName: String?

    // MARK: - Initialization

    public init(card: ProfileCardEntity?,
                email: String?,
                id: String?,
                phone: String?,
                birthday: String?,
                firstName: String?,
                footSize: String?,
                gender: Int?,
                lastName: String?,
                middleName: String?) {
        self.card = card
        self.email = email
        self.id = id
        self.phone = phone
        self.birthday = birthday
        self.firstName = firstName
        self.footSize = footSize
        self.gender = gender
        self.lastName = lastName
        self.middleName = middleName
    }

}

// MARK: - DTOConvertible

extension ProfileEntity: DTOConvertible {

    public static func from(dto model: ProfileEntry) throws -> ProfileEntity {
        return try .init(card: .from(dto: model.card),
                         email: model.email,
                         id: model.id,
                         phone: model.phone,
                         birthday: model.birthday,
                         firstName: model.first_name,
                         footSize: model.foot_size,
                         gender: model.gender,
                         lastName: model.last_name,
                         middleName: model.middle_name)
    }

    public func toDTO() throws -> ProfileEntry {
        return try .init(card: card?.toDTO(),
                         email: email,
                         id: id,
                         phone: phone,
                         birthday: birthday,
                         first_name: firstName,
                         foot_size: footSize,
                         gender: gender,
                         last_name: lastName,
                         middle_name: middleName)
    }

}
