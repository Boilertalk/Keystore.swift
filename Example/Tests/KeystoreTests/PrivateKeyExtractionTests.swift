//
//  PrivateKeyExtractionTests.swift
//  Keystore_Example
//
//  Created by Koray Koska on 27.06.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import Quick
import Nimble
import Foundation
@testable import Keystore

struct KeystoreStub: Codable {

    let privateKey: String
    let keystore: Keystore
    let password: String
}

class PrivateKeyExtractionTests: QuickSpec {

    let decoder = JSONDecoder()

    override func spec() {
        describe("private key extraction") {

            context("mycrypto keystores") {

                let mycryptoTests = [
                    "mycrypto_test1", "mycrypto_test2", "mycrypto_test3", "mycrypto_test4"
                ]

                for testName in mycryptoTests {
                    guard let testData = loadStub(named: testName), let test = try? decoder.decode(KeystoreStub.self, from: testData) else {
                        it("should never happen") {
                            expect(true) == false
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

                    // try! JSONEncoder().encode(Keystore(privateKey: privateKey!, password: test.password))
                }
            }
        }
    }
}
