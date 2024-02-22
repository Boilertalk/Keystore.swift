import Foundation

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
