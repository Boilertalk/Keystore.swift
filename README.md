<a href="https://github.com/Boilertalk/Keystore.swift">
  <img src="https://crypto-bot-main.fra1.digitaloceanspaces.com/old/keystore-swift.svg" width="100%" height="256">
</a>

<p align="center">
  <a href="https://travis-ci.com/Boilertalk/Keystore.swift">
    <img src="https://travis-ci.com/Boilertalk/Keystore.swift.svg?branch=master" alt="CI Status">
  </a>
  <a href="https://t.me/joinchat/BPk3DE6CTFaiOolSIZNLyg">  
    <img src="https://img.shields.io/badge/chat-on%20telegram-blue.svg?longCache=true&style=flat" alt="Telegram">
  </a>
</p>

# :alembic: Keystore

Keystore.swift makes it easy to extract private keys from Ethereum keystore files and generate keystore files from existing private keys.    
This library belongs to our Swift Crypto suite. For a pure Swift Ethereum Web3 library check out [Web3.swift](https://github.com/Boilertalk/Web3.swift)!

This library also supports EIP 2335 (BLS/ETH2) keystores.

## Example

Check the usage below or look through the repositories tests.

## Installation

We only support Swift Package Manager. Everything else is outdated.

### Swift Package Manager

Keystore is compatible with Swift Package Manager v5 (Swift 5 and above). Simply add it to the dependencies in your `Package.swift`.

```Swift
dependencies: [
    .package(url: "https://github.com/Boilertalk/Keystore.swift.git", from: "0.3.0")
]
```

And then add it to your target dependencies:

```Swift
targets: [
    .target(
        name: "MyProject",
        dependencies: [
            .product(name: "Keystore", package: "Keystore.swift"),
        ]),
    .testTarget(
        name: "MyProjectTests",
        dependencies: ["MyProject"])
]
```

After the installation you can import `Keystore` in your `.swift` files.

```Swift
import Keystore
```

## Usage

### ETH1 / Normal Keystore

To extract a private key from an existing keystore file, just do the following.

```Swift
import Keystore

let decoder = JSONDecoder()

let keystoreData: Data = ... // Load keystore data from file?
let keystore = try decoder.decode(Keystore.self, from: keystoreData)

let password = "your_super_secret_password"
let privateKey = try keystore.privateKey(password: password)

print(privateKey)    // Your decrypted private key
```

And to generate a keystore file from an existing private key, your code should look a little bit like the following.

```Swift
let privateKey: [UInt8] = ... // Get your private key as a byte array

let password = "your_super_secret_password"
let keystore = try Keystore(privateKey: privateKey, password: password)

let keystoreJson = try JSONEncoder().encode(keystore)
print(String(data: keystoreJson, encoding: .utf8))       // Your encrypted keystore as a json string
```

### ETH2 / BLS Keystore

To extract a private key from an existing keystore file, just do the following.

```Swift
import Keystore

let decoder = JSONDecoder()

let keystoreData: Data = ... // Load keystore data from file?
let keystore = try decoder.decode(KeystoreETH2.self, from: keystoreData)

let password = "your_super_secret_password"
let privateKey = try keystore.privateKey(password: password)

print(privateKey)    // Your decrypted private key
```

## Author

The awesome guys at Boilertalk :alembic:    
...and even more awesome members from the community :purple_heart:

Check out the [contributors list](https://github.com/Boilertalk/Keystore.swift/graphs/contributors) for a complete list.

## License

Keystore is available under the MIT license. See the LICENSE file for more info.
