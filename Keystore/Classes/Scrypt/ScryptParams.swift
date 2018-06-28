// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE in the same directory as this source file.
//
// This scrypt implementation is based on [Colin Percival's reference implementation](https://www.tarsnap.com/scrypt/scrypt.pdf)
// and the [Java version](https://github.com/wg/scrypt) by Will Glozer.

//
// Modifications and additions in this file are Copyright © 2018 Boilertalk Ltd.
// The LICENSE file for all the modifications can be found at the root of this project.
//

import Foundation

struct ScryptParams {

    /// The N parameter of Scrypt encryption algorithm, using 256MB memory and taking approximately 1s CPU time on a
    /// modern processor.
    static let standardN = 1 << 18

    /// The P parameter of Scrypt encryption algorithm, using 256MB memory and taking approximately 1s CPU time on a
    /// modern processor.
    static let standardP = 1

    /// The N parameter of Scrypt encryption algorithm, using 4MB memory and taking approximately 100ms CPU time on a
    /// modern processor.
    static let lightN = 1 << 12

    /// The P parameter of Scrypt encryption algorithm, using 4MB memory and taking approximately 100ms CPU time on a
    /// modern processor.
    static let lightP = 6

    /// Default `R` parameter of Scrypt encryption algorithm.
    static let defaultR = 8

    /// Default desired key length of Scrypt encryption algorithm.
    static let defaultDesiredKeyLength = 32

    /// Random salt.
    var salt: Data

    /// Desired key length in bytes.
    var desiredKeyLength = defaultDesiredKeyLength

    /// CPU/Memory cost factor.
    var n = lightN

    /// Parallelization factor (1..232-1 * hLen/MFlen).
    var p = lightP

    /// Block size factor.
    var r = defaultR

    /// Initializes with default scrypt parameters and a random salt.
    init() {
        let length = 32
        let data = Data([UInt8].secureRandom(count: length) ?? [UInt8](repeating: 0, count: length))
        salt = data
    }

    /// Initializes `ScryptParams` with all values.
    init(salt: Data, n: Int, r: Int, p: Int, desiredKeyLength: Int) throws {
        self.salt = salt
        self.n = n
        self.r = r
        self.p = p
        self.desiredKeyLength = desiredKeyLength
        if let error = validate() {
            throw error
        }
    }

    /// Validates the parameters.
    ///
    /// - Returns: a `ValidationError` or `nil` if the parameters are valid.
    func validate() -> ValidationError? {
        if desiredKeyLength > ((1 << 32 as Int64) - 1 as Int64) * 32 {
            return ValidationError.desiredKeyLengthTooLarge
        }
        if UInt64(r) * UInt64(p) >= (1 << 30) {
            return ValidationError.blockSizeTooLarge
        }
        if n & (n - 1) != 0 || n < 2 {
            return ValidationError.invalidCostFactor
        }
        if (r > Int.max / 128 / p) || (n > Int.max / 128 / r) {
            return ValidationError.overflow
        }
        return nil
    }

    enum ValidationError: Error {
        case desiredKeyLengthTooLarge
        case blockSizeTooLarge
        case invalidCostFactor
        case overflow
    }
}

extension ScryptParams: Codable {
    enum CodingKeys: String, CodingKey {
        case salt
        case desiredKeyLength = "dklen"
        case n
        case p
        case r
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        salt = try values.decode(String.self, forKey: .salt).dataWithHexString()
        desiredKeyLength = try values.decode(Int.self, forKey: .desiredKeyLength)
        n = try values.decode(Int.self, forKey: .n)
        p = try values.decode(Int.self, forKey: .p)
        r = try values.decode(Int.self, forKey: .r)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(salt.hexString, forKey: .salt)
        try container.encode(desiredKeyLength, forKey: .desiredKeyLength)
        try container.encode(n, forKey: .n)
        try container.encode(p, forKey: .p)
        try container.encode(r, forKey: .r)
    }
}

extension Data {

    var hexString: String {
        return reduce("") { $0 + String(format: "%02x", $1) }
    }
}

extension String {

    func dataWithHexString() throws -> Data {
        var hex = self
        if hex.starts(with: "0x") {
            let index = hex.index(hex.startIndex, offsetBy: 2)
            hex = String(hex[index...])
        }
        if hex.count % 2 != 0 {
            hex.insert("0", at: hex.startIndex)
        }
        var data = Data()
        while(hex.count > 0) {
            let subIndex = hex.index(hex.startIndex, offsetBy: 2)
            let c = String(hex[..<subIndex])
            hex = String(hex[subIndex...])

            guard let char = UInt8(c, radix: 16) else {
                throw HexDataError.hexStringMalformed
            }
            data.append(char)
        }
        return data
    }
}

enum HexDataError: Error {

    case hexStringMalformed
}
