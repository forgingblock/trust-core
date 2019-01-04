// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import XCTest
import TrustCore

struct SchnorrTestFixture: Decodable {
    let msg: String
    let pub: String
    let priv: String
    let k: String
    let r: String
    let s: String
}

class SchnorrTests: XCTestCase {
    func testVerify() throws {
        let url = Bundle(for: type(of: self)).url(forResource: "schnorr.fixtures", withExtension: "json")!
        let data = try Data(contentsOf: url)
        let fixtures = try JSONDecoder().decode([SchnorrTestFixture].self, from: data)

        for (index, fixture) in fixtures.enumerated() {
            if index >= 10 {
                break
            }
            let sig = Data(hexString: fixture.r + fixture.s)!
            let msg = Data(hexString: fixture.msg)!
            let pubkey = Data(hexString: fixture.pub)!
            XCTAssertTrue(Crypto.verifySchnorr(signature: sig, message: msg, publicKey: pubkey))
        }
    }
}
