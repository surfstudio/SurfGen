
import NodeKit

/// Запрос для обновления AccessToken-а
public struct SilentAuthRequestEntity {

    // MARK: - Public Properties

    public let grantType: AuthGrantType?

    public let refreshToken: String?

    // MARK: - Initialization

    public init(grantType: AuthGrantType?,
                refreshToken: String?) {
        self.grantType = grantType
        self.refreshToken = refreshToken
    }

}

// MARK: - DTOConvertible

extension SilentAuthRequestEntity: DTOConvertible {
    public static func from(dto model: SilentAuthRequestEntry) throws -> SilentAuthRequestEntity {
        return .init(grantType: model.grant_type,
                     refreshToken: model.refresh_token)
    }

    public func toDTO() throws -> SilentAuthRequestEntry {
        return .init(grant_type: grantType,
                     refresh_token: refreshToken)
    }
}
