<a href="https://github.com/Boilertalk/Keystore.swift">
  <img src="https://storage.googleapis.com/boilertalk/logo.svg" width="100%" height="256">
</a>

<p align="center">
  <a href="https://travis-ci.com/Boilertalk/Keystore.swift">
    <img src="https://travis-ci.com/Boilertalk/Keystore.swift.svg?branch=master" alt="CI Status">
  </a>
  <a href="http://cocoapods.org/pods/Keystore">
    <img src="https://img.shields.io/cocoapods/v/Keystore.svg?style=flat" alt="Version">
  </a>
  <a href="http://cocoapods.org/pods/Keystore">
    <img src="https://img.shields.io/cocoapods/l/Keystore.svg?style=flat" alt="License">
  </a>
  <a href="http://cocoapods.org/pods/Keystore">
    <img src="https://img.shields.io/cocoapods/p/Keystore.svg?style=flat" alt="Platform">
  </a>
  <a href="https://github.com/Carthage/Carthage">
    <img src="https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat" alt="Carthage compatible">
  </a>
  <a href="https://t.me/joinchat/BPk3DE6CTFaiOolSIZNLyg">  
    <img src="https://img.shields.io/badge/chat-on%20telegram-blue.svg?longCache=true&style=flat" alt="Telegram">
  </a>
</p>

# :alembic: Keystore

Keystore.swift makes it easy to extract private keys from Ethereum keystore files and generate keystore files from existing private keys.    
This library belongs to our Swift Crypto suite. For a pure Swift Ethereum Web3 library check out [Web3.swift](https://github.com/Boilertalk/Web3.swift)!

## Example

Check the usage below or look through the repositories tests.

## Installation

### CocoaPods

Keystore is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your `Podfile`:

```ruby
pod 'Keystore'
```

### Carthage

Keystore is compatible with [Carthage](https://github.com/Carthage/Carthage), a decentralized dependency manager that builds your dependencies and provides you with binary frameworks. To install it, simply add the following line to your `Cartfile`:

```
github "Boilertalk/Keystore.swift"
```

You will also have to install the dependencies, which can be found in our [Cartfile](Cartfile).

### Swift Package Manager

Keystore is compatible with Swift Package Manager v4 (Swift 4 and above). Simply add it to the dependencies in your `Package.swift`.

```Swift
dependencies: [
    .package(url: "https://github.com/Boilertalk/Keystore.swift.git", from: "0.2.0")
]
```

And then add it to your target dependencies:

```Swift
targets: [
    .target(
        name: "MyProject",
        dependencies: ["Keystore"]),
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

## Author

The awesome guys at Boilertalk :alembic:    
...and even more awesome members from the community :purple_heart:

Check out the [contributors list](https://github.com/Boilertalk/Keystore.swift/graphs/contributors) for a complete list.

## License

Keystore is available under the MIT license. See the LICENSE file for more info.
