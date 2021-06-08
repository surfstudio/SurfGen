
import NodeKit

/// Объект содержит информацию, которая позволяет однозначно установить верно ли была распознана капча или нет.
public struct CaptchaPayloadInfoEntity {

    // MARK: - Public Properties
    
    /// Тот же хэш, который приходит в `Captcha`
    public let hash: String?
    
    /// Значение, которое ввел пользователь (распознанное значение)
    public let value: String?

    // MARK: - Initialization

    public init(hash: String?,
                value: String?) {
        self.hash = hash
        self.value = value
    }

}

// MARK: - DTOConvertible

extension CaptchaPayloadInfoEntity: DTOConvertible {
    public static func from(dto model: CaptchaPayloadInfoEntry) throws -> CaptchaPayloadInfoEntity {
        return .init(hash: model.hash,
                     value: model.value)
    }

    public func toDTO() throws -> CaptchaPayloadInfoEntry {
        return .init(hash: hash,
                     value: value)
    }
}
