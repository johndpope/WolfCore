//
//  UUID.swift
//  WolfCore
//
//  Created by Robert McNally on 1/14/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

import Foundation

extension UUID {
    public static func string(from uuid: UUID) -> String {
        return uuid.uuidString
    }
}

extension String {
    public static func uuid(from string: String) throws -> UUID {
        guard let uuid = UUID(uuidString: string) else {
            throw ValidationError(message: "Invalid UUID string: \(string).", violation: "uuidFormat")
        }
        return uuid
    }
}
