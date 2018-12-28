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
    public static func sign(_ tx: inout ZilliqaTransaction, with privateKey: PrivateKey) throws {
        let pubKey = privateKey.publicKey(compressed: true)
        tx.pubKey = pubKey.data

        let signature = try sign(tx.serialize(), with: privateKey)
        tx.signature = signature
    }

    public static func sign(_ data: Data, with privateKey: PrivateKey) throws -> Data {
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

extension ZilliqaTransaction {
    public func serialize() -> Data {
        do {
            guard let amount = value.serialize(bitWidth: 16),
                let gasPrice = gasPrice.serialize(bitWidth: 16) else {
                    throw ZilliqaError.signError
            }
            return try ZilliqaMessage_ProtoTransactionCoreInfo.with {
                $0.amount = amount.byteArray
                $0.version = UInt32(version)
                $0.nonce = UInt64(nonce)
                $0.toaddr = to.data
                $0.senderpubkey = pubKey.byteArray
                $0.gasprice = gasPrice.byteArray
                $0.gaslimit = UInt64(gasLimit)
                $0.code = code
                $0.data = data
            }.serializedData()
        } catch {
            return Data()
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
        try container.encode(pubKey.hexString, forKey: .senderPubKey)
    }
}
