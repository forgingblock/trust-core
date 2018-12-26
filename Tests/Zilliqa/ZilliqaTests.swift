// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import XCTest
import TrustCore

class ZilliqaTests: XCTestCase {

    func testZilliqaAddressFromPrivateKey() {
        let data = Data(hexString: "B4EB8E8B343E2CCE46DB4E7571EC1D9654693CCA200BC41CC20148355CA62ED9")!
        let key = PrivateKey(data: data)!
        let address = Zilliqa().address(for: key.publicKey())

        XCTAssertEqual(address as? ZilliqaAddress, ZilliqaAddress(string: "0x4BAF5FADA8E5DB92C3D3242618C5B47133AE003C"))
    }

    func testZilliqaAddressFromPublicKey() {
        let pubKey = PublicKey(data: Data(hexString: "034CE268AC5A340038D8ACEBBDD7363611A5B1197916775E32481F5D6B104FAF65")!)!

        let address = Zilliqa().address(for: pubKey)

        XCTAssertEqual(address.description, ZilliqaAddress(string: "0x448261915A80CDE9BDE7C7A791685200D3A0BF4E")?.description)
    }
}
