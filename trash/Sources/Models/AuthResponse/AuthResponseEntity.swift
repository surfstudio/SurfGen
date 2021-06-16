
import NodeKit

public struct AuthResponseEntity {

    // MARK: - Public Properties

    public let accessToken: String?

    /// Дата, когда токен протухнет в ISO8601
    public let expires: ISO8601Date?

    /// если true, то необходимо запрашивать акцепт, не смотрим на isFirstEnter
    public let isNeedAccept: Bool?

    /// True если это первый вход. Тогда мы должны будем запросить оферту.
    public let isFirstEnter: Bool?

    /// Дата генерации токена в ISO8601
    public let issued: ISO8601Date?

    public let refreshToken: String?

    public let tokenType: String?

    public let userId: String?

    // MARK: - Initialization

    public init(accessToken: String?,
                expires: ISO8601Date?,
                isNeedAccept: Bool?,
                isFirstEnter: Bool?,
                issued: ISO8601Date?,
                refreshToken: String?,
                tokenType: String?,
                userId: String?) {
        self.accessToken = accessToken
        self.expires = expires
        self.isNeedAccept = isNeedAccept
        self.isFirstEnter = isFirstEnter
        self.issued = issued
        self.refreshToken = refreshToken
        self.tokenType = tokenType
        self.userId = userId
    }

}

// MARK: - DTOConvertible

extension AuthResponseEntity: DTOConvertible {
    public static func from(dto model: AuthResponseEntry) throws -> AuthResponseEntity {
        return .init(accessToken: model.access_token,
                     expires: model.expires,
                     isNeedAccept: model.isNeedAccept,
                     isFirstEnter: model.is_first_enter,
                     issued: model.issued,
                     refreshToken: model.refresh_token,
                     tokenType: model.token_type,
                     userId: model.user_id)
    }

    public func toDTO() throws -> AuthResponseEntry {
        return .init(access_token: accessToken,
                     expires: expires,
                     isNeedAccept: isNeedAccept,
                     is_first_enter: isFirstEnter,
                     issued: issued,
                     refresh_token: refreshToken,
                     token_type: tokenType,
                     user_id: userId)
    }
}
