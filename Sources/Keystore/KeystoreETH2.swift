import Foundation
import CryptoSwift

/// ERC-2335: BLS12-381 Keystore
public struct KeystoreETH2: Codable {

    // MARK: - Public API

    /// Creates a new keystore for the given private key and password.
    ///
    /// - parameter privateKey: The private key to encrypt.
    /// - parameter password: The password to use for the encryption.
    ///
    /// - throws: Error if any step fails.
//    public init(privateKey: [UInt8], password: String, kdf: Keystore.Crypto.KDFType = .scrypt, cipher: IVBlockModeType = .ctr, rounds: Int? = nil) throws {
//        self = try KeystoreFactory.keystore(from: privateKey, password: password, kdf: kdf, cipher: cipher, rounds: rounds)
//    }

    /// Extracts the private key from this keystore with the given password.
    ///
    /// - parameter
    public func privateKey(password: String) throws -> [UInt8] {
        return try KeystoreETH2Factory.privateKey(from: self, password: password)
    }

    // MARK: - Internal stuff

    init(
        crypto: Crypto,
        description: String?,
        pubkey: String?,
        path: String,
        uuid: String,
        version: Int
    ) {
        self.crypto = crypto
        self.description = description
        self.pubkey = pubkey
        self.path = path
        self.uuid = uuid
        self.version = version
    }

    public let crypto: Crypto

    public let description: String?

    public let pubkey: String?

    public let path: String

    public let uuid: String

    public let version: Int

    public struct Crypto: Codable {

        public let kdf: KDFModule

        public let checksum: ChecksumModule

        public let cipher: CipherModule
    }

    public struct KDFModule: Codable {
        public let function: KDFType

        public enum KDFType: String, Codable {
            case scrypt
            case pbkdf2
        }

        public let params: KDFParams

        public struct KDFParams: Codable {

            public let salt: String

            public let dklen: Int

            // *** Scrypt params ***

            public let n: Int?

            public let r: Int?

            public let p: Int?

            // *** End Scrypt params ***

            // *** PBKDF2 params ***

            public let prf: String?

            public let c: Int?

            // *** End PBKDF2 params ***

            /// Scrypt init
            init(salt: String, dklen: Int, n: Int, r: Int, p: Int) {
                self.salt = salt
                self.dklen = dklen
                self.n = n
                self.r = r
                self.p = p
                self.prf = nil
                self.c = nil
            }

            /// PBKDF2 init
            init(salt: String, dklen: Int, prf: String, c: Int) {
                self.salt = salt
                self.dklen = dklen
                self.prf = prf
                self.c = c
                self.n = nil
                self.r = nil
                self.p = nil
            }
        }

        public let message: String
    }

    public struct ChecksumModule: Codable {
        public let function: ChecksumType

        public enum ChecksumType: String, Codable {
            case sha256
        }

        public let params: ChecksumParams

        public struct ChecksumParams: Codable {
        }

        public let message: String
    }

    public struct CipherModule: Codable {
        public let function: CipherType

        public enum CipherType: String, Codable {
            case aes128Ctr = "aes-128-ctr"
        }

        public let params: CipherParams

        public struct CipherParams: Codable {
            public let iv: String
        }

        public let message: String
    }
}
