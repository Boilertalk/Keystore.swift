//
//  LinuxMain.swift
//  Web3
//
//  Created by Koray Koska on 28.06.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

#if os(Linux)

import XCTest
import Quick
@testable import KeystoreTests

@main struct Main {
    static func main() {
        QCKMain([
            // All Keystore Tests
            KeystoreCreationTests.self,
            PrivateKeyExtractionTests.self,
            ETH2PrivateKeyExtractionTests.self,
        ]), configurations: [], testCases: [])
    }
}

#endif
