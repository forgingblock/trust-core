// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import Foundation
import BigInt

public struct ZilliqaTransaction {
    public let version: Int
    public let to: ZilliqaAddress

    public let value: BigInt
    public let nonce: BigInt
    public let gasPrice: BigInt
    public let gasLimit: BigInt

    // only for contract
    public let code: Data
    public let data: Data

    public var pubKey: Data
    public var signature: Data

    public init(
        version: Int,
        to: ZilliqaAddress,
        value: BigInt,
        nonce: BigInt,
        gasPrice: BigInt,
        gasLimit: BigInt,
        code: Data = Data(),
        data: Data = Data(),
        pubKey: Data = Data(),
        signature: Data = Data()
    ) {
        self.version = version
        self.to = to
        self.value = value
        self.nonce = nonce
        self.gasLimit = gasLimit
        self.gasPrice = gasPrice
        self.code = code
        self.data = data
        self.pubKey = pubKey
        self.signature = signature
    }
}
