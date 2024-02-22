//
//  KeystoreCreationTests.swift
//  Keystore_Tests
//
//  Created by Koray Koska on 28.06.18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import Foundation
@testable import Keystore

class KeystoreCreationTests: QuickSpec {

    let decoder = JSONDecoder()

    override func spec() {
        describe("keystore creation") {

            context("random private keys default keystore") {

                for _ in 0..<10 {
                    guard let randomBytes = [UInt8].secureRandom(count: 32) else {
                        it("should never happen") {
                            expect(true) == false
                        }
                        return
                    }

                    let password = UUID().uuidString
                    let keystore = try? Keystore(privateKey: randomBytes, password: password)
                    it("should not be nil") {
                        expect(keystore).toNot(beNil())
                    }

                    it("should create a valid keystore") {
                        expect(keystore?.version) == 3
                        expect(keystore?.crypto.cipher) == "aes-128-ctr"
                        expect(keystore?.crypto.kdf) == Keystore.Crypto.KDFType.scrypt
                        // Scrypt params
                        expect(keystore?.crypto.kdfparams.n).toNot(beNil())
                        expect(keystore?.crypto.kdfparams.r).toNot(beNil())
                        expect(keystore?.crypto.kdfparams.p).toNot(beNil())
                        // PBKDF2 params
                        expect(keystore?.crypto.kdfparams.prf).to(beNil())
                        expect(keystore?.crypto.kdfparams.c).to(beNil())
                    }

                    let extracted = (try? keystore?.privateKey(password: password)) ?? nil
                    it("should not be nil") {
                        expect(extracted).toNot(beNil())
                    }
                    it("should match original key") {
                        expect(extracted) == randomBytes
                    }
                }
            }
        }
    }
}
