
import NodeKit

/// Содержит все данные, необходимые для авторизации по логину и паролю
public struct AuthRequestEntity {

    // MARK: - Public Properties

    /// Передается, только если есть капча Содержит строку, которую пользователь ввел как разгадку капчи. 
    public let captcha: CaptchaPayloadInfoEntity?

    public let grantType: AuthGrantType?

    public let password: String?

    /// Значение всегда `Login`
    public let type: RequestMetaType?

    /// То, что используется как логин пользователя (телефон, номер договора, whatever)
    public let username: String?

    // MARK: - Initialization

    public init(captcha: CaptchaPayloadInfoEntity?,
                grantType: AuthGrantType?,
                password: String?,
                type: RequestMetaType?,
                username: String?) {
        self.captcha = captcha
        self.grantType = grantType
        self.password = password
        self.type = type
        self.username = username
    }

}

// MARK: - DTOConvertible

extension AuthRequestEntity: DTOConvertible {
    public static func from(dto model: AuthRequestEntry) throws -> AuthRequestEntity {
        return try .init(captcha: .from(dto: model.captcha),
                     grantType: model.grant_type,
                     password: model.password,
                     type: model.type,
                     username: model.username)
    }

    public func toDTO() throws -> AuthRequestEntry {
        return try .init(captcha: captcha?.toDTO(),
                     grant_type: grantType,
                     password: password,
                     type: type,
                     username: username)
    }
}
