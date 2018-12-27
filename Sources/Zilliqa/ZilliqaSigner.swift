// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import Foundation

enum ZilliqaError: LocalizedError {
    case signError
}

public struct ZilliqaSigner {
    func sign(_ tx: inout ZilliqaTransaction, with privateKey: PrivateKey) throws {
        guard let amount = tx.value.serialize(bitWidth: 16) else {
            throw ZilliqaError.signError
        }

        let pubKey = privateKey.publicKey(compressed: true)
        let serialized = try ZilliqaMessage_ProtoTransactionCoreInfo.with {
            $0.amount = amount.byteArray
            $0.version = UInt32(tx.version)
            $0.nonce = UInt64(tx.nonce)
            $0.toaddr = tx.to.data
            $0.senderpubkey = pubKey.data.byteArray
            $0.gasprice = String(tx.gasPrice).data(using: .utf8)!.byteArray
            $0.gaslimit = UInt64(tx.gasLimit)
            $0.code = tx.code
            $0.data = tx.data
        }.serializedData()

        let signature = try sign(serialized, with: privateKey)
        tx.signature = signature
        tx.pubKey = pubKey
    }

    func sign(_ data: Data, with privateKey: PrivateKey) throws -> Data {
        //FIXME: schnorr signature
        let signature = Data()
        return signature
    }
}

extension Data {
    var byteArray: ZilliqaMessage_ByteArray {
        return ZilliqaMessage_ByteArray.with {
            $0.data = self
        }
    }
}

extension ZilliqaTransaction: Encodable {

    enum CodingKeys: String, CodingKey {
        case version, toAddr, nonce, senderPubKey, amount, gasPrice, gasLimit, code, data, signature
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(version, forKey: .version)
        try container.encode(to.data.hexString, forKey: .toAddr)
        try container.encode(String(value), forKey: .amount)
        try container.encode(UInt64(nonce), forKey: .nonce)
        try container.encode(String(gasPrice), forKey: .gasPrice)
        try container.encode(String(gasLimit), forKey: .gasLimit)

        try container.encode(code, forKey: .code)
        try container.encode(data, forKey: .data)
        try container.encode(signature.hexString, forKey: .signature)
        try container.encode(pubKey.compressed.data.hexString, forKey: .senderPubKey)
    }
}
