
import NodeKit

/// Это общий тип ошибки, который может возвращать сервер.
public struct CommonErrorEntity {

    // MARK: - Public Properties
    
    /// Это идентификатор ошибки. Этот идентификатор мобильное приложение будет использовать для того, чтобы включать определенное поведение.
    public let code: Int
    
    /// Пояснение для разработчика/тестировщика о том, что пошло не так
    public let developerMessage: String?
    
    /// Сообщение, которое будет выведено пользователю в снеке в случае получения ошибки
    public let userMessage: String?

    // MARK: - Initialization

    public init(code: Int,
                developerMessage: String?,
                userMessage: String?) {
        self.code = code
        self.developerMessage = developerMessage
        self.userMessage = userMessage
    }

}

// MARK: - DTOConvertible

extension CommonErrorEntity: DTOConvertible {
    public static func from(dto model: CommonErrorEntry) throws -> CommonErrorEntity {
        return .init(code: model.code,
                     developerMessage: model.developerMessage,
                     userMessage: model.userMessage)
    }

    public func toDTO() throws -> CommonErrorEntry {
        return .init(code: code,
                     developerMessage: developerMessage,
                     userMessage: userMessage)
    }
}
