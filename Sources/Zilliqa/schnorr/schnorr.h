// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

#ifndef schnorr_h
#define schnorr_h

#include <stdio.h>
#include "ecdsa.h"

int schnorr_verify_message(const ecdsa_curve *curve, const uint8_t *pub_key, const uint8_t *sig, const uint8_t *msg, const size_t msg_len);


#endif /* schnorr_h */
