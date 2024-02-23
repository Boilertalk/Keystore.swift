import Foundation
import CryptoSwift
import Scrypt

public struct KeystoreETH2Factory {

    /// Extracts the private key from the given keystore
    ///
    /// - parameter keystore: The keystore.
    /// - parameter password: The password to use for the decryption.
    ///
    /// - returns: The extracted private key.
    ///
    /// - throws: Some `KeystoreFactory.Error` if any step fails.
    public static func privateKey(from keystore: KeystoreETH2, password: String) throws -> Array<UInt8> {
        var forbiddenCharacterSet = CharacterSet()
        forbiddenCharacterSet.insert(charactersIn: Unicode.Scalar(0x00)...Unicode.Scalar(0x1f))
        forbiddenCharacterSet.insert(charactersIn: Unicode.Scalar(0x80)...Unicode.Scalar(0x9f))
        forbiddenCharacterSet.insert(Unicode.Scalar(0x7f))

        let password = password.decomposedStringWithCompatibilityMapping
            .components(separatedBy: .controlCharacters)
            .filter({ !$0.isEmpty })
            .joined(separator: "")

        // Check version
        guard keystore.version == 4 else {
            throw Error.keystoreVersionNotSupported
        }

        // Derive key
        let decryptionKey = try deriveKey(password: password, kdf: keystore.crypto.kdf)
        guard decryptionKey.count >= 32 else {
            throw Error.kdfFailed
        }

        // Verify password
        let isValidPassword = try passwordVerification(
            decryptionKey: decryptionKey,
            cipher: keystore.crypto.cipher,
            checksum: keystore.crypto.checksum
        )
        if !isValidPassword {
            throw Error.passwordWrong
        }

        let ivData = try keystore.crypto.cipher.params.iv.dataWithHexString()
        let ciphertextData = try keystore.crypto.cipher.message.dataWithHexString()
        let cipher = keystore.crypto.cipher.function

        let usableKey = decryptionKey[0..<16]

        guard cipher == .aes128Ctr else {
            throw Error.cipherNotAvailable
        }

        let aes = try AES(
            key: [UInt8](usableKey),
            blockMode: CTR(iv: ivData.bytes),
            padding: .noPadding
        )

        return try aes.decrypt([UInt8](ciphertextData))
    }

    private static func deriveKey(
        password: String,
        kdf: KeystoreETH2.KDFModule
    ) throws -> Data {
        guard let passwordData = password.data(using: .utf8) else {
            throw Error.passwordMalformed
        }
        let saltData = try kdf.params.salt.dataWithHexString()

        if kdf.function == .scrypt {
            guard let n = kdf.params.n, let r = kdf.params.r, let p = kdf.params.p else {
                throw Error.kdfInputsMalformed
            }

            return try Data(scrypt(
                password: password.bytes,
                salt: saltData.bytes,
                length: kdf.params.dklen,
                N: UInt64(n),
                r: UInt32(r),
                p: UInt32(p)
            ))
        }

        // PBKDF2
        guard kdf.function == .pbkdf2, kdf.params.prf == "hmac-sha256" else {
            throw Error.kdfInputsMalformed
        }
        guard let c = kdf.params.c, c > 0 else {
            throw Error.kdfInputsMalformed
        }

        return try Data(PKCS5.PBKDF2(
            password: [UInt8](passwordData),
            salt: [UInt8](saltData),
            iterations: c,
            keyLength: kdf.params.dklen,
            variant: .sha2(.sha256)
        ).calculate())
    }

    private static func passwordVerification(
        decryptionKey: Data,
        cipher: KeystoreETH2.CipherModule,
        checksum: KeystoreETH2.ChecksumModule
    ) throws -> Bool {
        let dkSlice = decryptionKey[16..<32]
        var preImage = dkSlice
        try preImage.append(contentsOf: cipher.message.dataWithHexString())

        let calculatedChecksum = preImage.sha256()

        return try calculatedChecksum == checksum.message.dataWithHexString()
    }

    public enum Error: Swift.Error {

        /// Unsupported keystore version
        case keystoreVersionNotSupported

        /// The password can't be represented as utf8 data
        case passwordMalformed

        /// The keystore contains values which are not acceptable or misses some values which are needed
        case keystoreMalformed

        /// The kdf values in the keystore are missing values/are not available
        case kdfInputsMalformed

        /// The kdf failed at any point
        case kdfFailed

        /// The password is wrong/mac verification failed
        case passwordWrong

        /// The given cipher is not available
        case cipherNotAvailable

        /// Generating random bytes failed
        case bytesGenerationFailed

        /// The given private key is not a valid secp256k1 private key
        case privateKeyMalformed
    }
}
