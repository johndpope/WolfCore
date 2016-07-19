//
//  SignalExceptions.swift
//  WolfCore
//
//  Created by Robert McNally on 7/7/16.
//  Copyright © 2016 Arciem. All rights reserved.
//

public enum SignalError: ErrorProtocol {
    /// Thrown when the user is:
    ///
    /// 1) Sending a message with a PreKeyBundle that contains a different identity key than the previously known one.
    /// 2) Receiving a new PreKeyWhisperMessage that has a different identity key than the previously known one.
    case untrustedIdentityKeyException

    /// Thrown thrown when a message is received with an unknown PreKeyID.
    case invalidKeyIDException

    /// Thrown when:
    ///
    /// 1) Signature of Prekeys are not correctly signed.
    /// 2) We received a key type that is not compatible with this version. (All keys should be Curve25519).
    case invalidKeyException

    /// Thrown when receiving a message with no associated session for decryption.
    case noSessionException

    /// Thrown when receiving a malformatted message.
    case invalidMessageException

    /// Thrown when experiencing issues encrypting/decrypting a message symetrically.
    case cipherException

    /// Thrown when detecting a message being sent a second time. (Replay attacks/bugs)
    case duplicateMessageException

    /// Thrown when receiving a message send with a non-supported version of the TextSecure protocol.
    case legacyMessageException

    /// Thrown when a client tries to initiate a session with a non-supported version.
    case invalidVersionException
}
