// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import Foundation

public struct ZilliqaAddress: Address, Equatable {

    static let size = 20

    private let checksumString: String

    public static func isValid(data: Data) -> Bool {
        return data.count == ZilliqaAddress.size
    }

    public static func isValid(string: String) -> Bool {
        guard let data = Data(hexString: string),
            data.count == ZilliqaAddress.size else {
            return false
        }
        return true
    }

    public var data: Data

    public init?(string: String) {
        guard ZilliqaAddress.isValid(string: string) else {
            return nil
        }
        self.data = Data(hexString: string)!
        self.checksumString = EthereumChecksum.computeString(for: data, type: .eip55)
    }

    public init?(data: Data) {
        guard ZilliqaAddress.isValid(data: data) else {
            return nil
        }
        self.data = data
        self.checksumString = EthereumChecksum.computeString(for: data, type: .eip55)
    }

    public var description: String {
        return checksumString
    }
}
