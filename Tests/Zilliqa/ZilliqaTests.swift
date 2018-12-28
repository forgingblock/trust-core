// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import XCTest
import TrustCore
import BigInt

class ZilliqaTests: XCTestCase {

    func testZilliqaAddressFromPrivateKey() {
        let data = Data(hexString: "B4EB8E8B343E2CCE46DB4E7571EC1D9654693CCA200BC41CC20148355CA62ED9")!
        let key = PrivateKey(data: data)!
        let address = Zilliqa().address(for: key.publicKey())

        XCTAssertEqual(address as? ZilliqaAddress, ZilliqaAddress(string: "0x4BaF5fADa8E5Db92c3D3242618c5b47133Ae003c"))
    }

    func testZilliqaAddressFromPublicKey() {
        let pubKey = PublicKey(data: Data(hexString: "034CE268AC5A340038D8ACEBBDD7363611A5B1197916775E32481F5D6B104FAF65")!)!
        let pubKey2 = PublicKey(data: Data(hexString: "0x029d25b68a18442590e113132a34bb524695c4291d2c49abf2e4cdd7d98db862c3")!)!
        let address = Zilliqa().address(for: pubKey)
        let address2 = Zilliqa().address(for: pubKey2)

        XCTAssertEqual(address.description, ZilliqaAddress(string: "0x448261915a80CDe9bde7C7A791685200d3A0BF4e")?.description)
        XCTAssertEqual(address2.description.lowercased(), "0x7fccacf066a5f26ee3affc2ed1fa9810deaa632c")
    }

    func testSerializeZilliqaTransaction() throws {
        let pubKey = PublicKey(data: Data(hexString: "0x029D25B68A18442590E113132A34BB524695C4291D2C49ABF2E4CDD7D98DB862C3")!)!
        let tx = ZilliqaTransaction(
            version: 1,
            to: ZilliqaAddress(string: "0x88af5ba10796d9091d6893eed4db23ef0bbbca37")!,
            value: BigInt(100000000000000),
            nonce: BigInt(2),
            gasPrice: BigInt(1000000000),
            gasLimit: BigInt(1),
            pubKey: pubKey.data
        )

        // swiftlint:disable:next line_length
        XCTAssertEqual(tx.serialize().hexString, "080110021a1488af5ba10796d9091d6893eed4db23ef0bbbca3722230a21029d25b68a18442590e113132a34bb524695c4291d2c49abf2e4cdd7d98db862c32a120a10000000000000000000005af3107a400032120a100000000000000000000000003b9aca00380142004a00")
    }
}
