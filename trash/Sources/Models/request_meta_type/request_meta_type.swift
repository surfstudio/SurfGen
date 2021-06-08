
import NodeKit

public struct Entity {

    // MARK: - Public Properties

    // MARK: - Initialization

    public init(
    }

}

// MARK: - DTOConvertible

extension Entity: DTOConvertible {
    public static func from(dto model: Entry) throws -> Entity {
        return .init()
    }

    public func toDTO() throws -> Entry {
        return .init()
    }
}
