// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import Foundation

public class Zilliqa: Blockchain {
    /// Chain identifier.
    open var chainID: Int {
        return 1
    }

    /// SLIP-044 coin type.
    open override var coinType: SLIP.CoinType {
        return .zilliqa
    }

    open override func address(for publicKey: PublicKey) -> Address {
        return publicKey.compressed.zilliqaAddress
    }

    open override func address(string: String) -> Address? {
        return ZilliqaAddress(string: string)
    }

    open override func address(data: Data) -> Address? {
        return ZilliqaAddress(data: data)
    }
}
