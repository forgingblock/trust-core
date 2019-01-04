// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

#include "schnorr.h"
#include "hasher.h"

#include "bignum.h"
#include "rand.h"
#include "secp256k1.h"
#include "rfc6979.h"
#include "memzero.h"
#include "sha2.h"
#include "string.h"

int schnorr_verify_message(const ecdsa_curve *curve, const uint8_t *pub_key, const uint8_t *sig, const uint8_t *msg, const size_t msg_len)
{
    curve_point kpub, l, Q;
    bignum256 zero;
    bignum256 r, s, r1;
    if (!ecdsa_read_pubkey(curve, pub_key, &kpub)) {
        return 1;
    }
    bn_zero(&zero);

    bn_read_be(sig, &r);
    bn_read_be(sig + 32, &s);

    // 1. Check if r,s is in [1, ..., order-1]
    if (bn_is_zero(&r) ||
        bn_is_zero(&s) ||
        bn_is_less(&r, &zero) ||
        bn_is_less(&s, &zero) ||
        (!bn_is_less(&r, &curve->order)) ||
        (!bn_is_less(&s, &curve->order))) {
        return 2;
    }

    // 2. Compute Q = sG + r*kpub
    point_multiply(curve, &s, &curve->G, &l);
    point_multiply(curve, &r, &kpub, &Q);
    point_add(curve, &l, &Q);

    // 3. If Q = O (the neutral point), return 0;
    if (point_is_infinity(&Q)) {
        return 3;
    }

    // 4. r' = H(Q, kpub, m)
    uint8_t Qx[33];
    memzero(Qx, 33);
    if (bn_is_even(&Q.y)) {
        Qx[0] = 02;
    } else {
        Qx[0] = 03;
    }
    bn_write_be(&Q.x, Qx + 1);

    size_t buff_len = 33 * 2 + msg_len;
    uint8_t *buffer = (uint8_t *)malloc(buff_len);

    memcpy(buffer, Qx, 33);
    memcpy(buffer + 33, pub_key, 33);
    memcpy(buffer + 66, msg, msg_len);

    uint8_t hash[32];
    sha256_Raw(buffer, buff_len, hash);
    bn_read_be(hash, &r1);
    bn_mod(&r1, &curve->order);

    int result = bn_is_equal(&r, &r1) ? 0 : 4;

    free(buffer);
    buffer = NULL;
    memzero(&kpub, sizeof(kpub));
    memzero(&l, sizeof(l));
    memzero(&Q, sizeof(Q));
    memzero(&zero, sizeof(zero));
    memzero(&r, sizeof(r));
    memzero(&s, sizeof(s));
    memzero(&r1, sizeof(r1));

    return result;
}

int schnorr_sign_digest(const ecdsa_curve *curve, const uint8_t *priv_key, const uint8_t *digest)
{
    return -1;
}
