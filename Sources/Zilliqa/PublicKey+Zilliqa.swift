// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import Foundation

public extension PublicKey {
    public var zilliqaAddress: ZilliqaAddress {
        let hash = Crypto.sha256(data)
        return ZilliqaAddress(data: Data(hash.suffix(ZilliqaAddress.size)))!
    }
}
