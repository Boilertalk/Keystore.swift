import Quick
import Nimble
import Foundation
@testable import Keystore

struct KeystoreETH2Stub: Codable {

    let privateKey: String
    let keystore: KeystoreETH2
    let password: String
}

class ETH2PrivateKeyExtractionTests: QuickSpec {

    let decoder = JSONDecoder()

    override func spec() {
        describe("eth2 private key extraction") {

            context("eth2 stubs keystore private key extraction") {

                let stubTests = [
                    "eth2_pbkdf2_test1",
                    "eth2_scrypt_test1"
                ]

                for testName in stubTests {
                    guard let testData = loadStub(named: testName), let test = try? decoder.decode(KeystoreETH2Stub.self, from: testData) else {
                        it("should never happen") {
                            fail("Stub \(testName) couldn't be loaded")
                        }
                        return
                    }

                    let privateKey = try? test.keystore.privateKey(password: test.password)
                    it("should not be nil") {
                        expect(privateKey).toNot(beNil())
                    }

                    let actualPrivateKey = try? [UInt8](test.privateKey.dataWithHexString())
                    it("should extract the private key correctly") {
                        expect(privateKey) == actualPrivateKey
                    }
                }
            }
        }
    }
}
