# PasswordGeneratorKit
![Swift 5.2](https://img.shields.io/badge/Swift-5.2-orange.svg)
[![Swift Package Manager](https://img.shields.io/badge/spm-compatible-brightgreen.svg?style=flat)](https://swift.org/package-manager)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![GitHub tag](https://img.shields.io/github/tag/rkreutz/PasswordGeneratorKit.svg)](https://GitHub.com/rkreutz/PasswordGeneratorKit/tags/)
[![Run Tests](https://github.com/rkreutz/PasswordGeneratorKit/actions/workflows/tests.yml/badge.svg)](https://github.com/rkreutz/PasswordGeneratorKit/actions/workflows/tests.yml)

As the name implies, this is a Swift Package that generates passwords pseudo-randomically deriving from a master password and some other inputs.

## Usage

To use a `PasswordGenerator` you must specify a `MasterPasswordProvider`, which will be responsible for providing the master password from which the final password will be generated from. `String` by default conforms to `MasterPasswordProvider` by returning itself as the master password. You may optionally provide some extra configuration for the underlying PBKDF like `iterations` (the number of iterations that should be used for generating the PBKDF2 key) and `bytes` (number of bytes of the PBKDF2 key).

```swift
let passwordGenerator = PasswordGenerator(
    masterPasswordProvider: "masterPassword",
    iterations: 1000,
    bytes: 64
)
```

With the created password generator you can generate passwords through the provided methods which expects some inputs that will be used as a `salt` on the underlying PBKDF2 key.

```swift
// Generates a password using a salt based on an username (email, username, ...), domain (webdsite domain) and seed (user defined number).
func generatePassword(username: String, domain: String, seed: Int, rules: Set<PasswordRule>) throws -> String

// Generates a password using a salt based on a service (Bank account, card pin, ...)
func generatePassword(service: String, rules: Set<PasswordRule>) throws -> String

// Generates a password using the provided salt
func generatePassword(salt: String, rules: Set<PasswordRule>) throws -> String
```

All the methods expect a `Set` of `PasswordRule`s:

```swift
enum PasswordRule {

    // Specifies that the generated password must contain a minimum number of characters in the provided character set
    case mustContain(characterSet: String, atLeast: Int)
    
    // The length of the generated password
    case length(Int)
}
```

Have in mind that the `Set<PasswordRule>` must contain a `.length` case and at least one `.mustContain` case.

You may use `PasswordRule.defaultRules` which comprimises a union of `PasswordRule.defaultCharacterSet` (minimum of 1 special character, decimal character, uppercase character and lowercase character) and `PasswordRule.defaultLength` (length of 16 characters).

In the end you would have something like this:
```swift
let generator = PasswordGenerator(masterPasswordProvider: "masterPassword")

let generatedPassword = try generator.generatePassword(
    username: "rkreutz",
    domain: "github.com",
    seed: 1,
    rules: PasswordRule.defaultRules
)

print(generatedPassword) // L5bnoSNxy5OZ_6LE     -> Don't even bother this is not my password 😂
```

**Some caveats:**
- The number of `iterations` will affect the time the password generation will take.
- The number of `bytes` will affect how many characters the password generator will be able to randomize before starting to repeat the last character, so if you get to a point where the generated password has several trailing characters that are the same, most likely you need more bytes on the PBKDF2 key. 64 should be enough for up to 32 characters long passwords.

## CLI

There is a CLI for using the password generator:

```bash
> password-generator --help (master) 
USAGE: password-generator-cli <subcommand>

OPTIONS:
  -h, --help              Show help information.

SUBCOMMANDS:
  salt-based
  service-based
  domain-based

> password-generator salt-based --help
USAGE: password-generator-cli salt-based --salt <salt> [--key-iterations <key-iterations>] [--key-length <key-length>] --master-password <master-password> [--length <length>] [--lowercase] [--uppercase] [--decimal] [--symbols]

OPTIONS:
  -s, --salt <salt>       The salt to be used 
  --key-iterations <key-iterations>
                          The number of iterations to be used to generate a
                          PBKDF2 key (default: 1000)
  --key-length <key-length>
                          The size in bytes of the PBKDF2 key (default: 64)
  -m, --master-password <master-password>
                          The master password to be used 
  -l, --length <length>   The length in characters of the generated password
                          (default: 16)
  --lowercase/--uppercase/--decimal/--symbols
                          The charactes that must be used in the generated
                          password, at least one must be specified. Any
                          combinations of the flags may be specified and this
                          will be defined as having at least one character of
                          that character set 
  -h, --help              Show help information.
  
 > password-generator domain-based --help
USAGE: password-generator-cli domain-based --username <username> --domain <domain> [--seed <seed>] [--key-iterations <key-iterations>] [--key-length <key-length>] --master-password <master-password> [--length <length>] [--lowercase] [--uppercase] [--decimal] [--symbols]

OPTIONS:
  -u, --username <username>
                          The username to which this password generator is used
                          for, e.g. an email 
  -d, --domain <domain>   The domain to which this password generator is used
                          for, e.g. a website 
  -s, --seed <seed>       The seed to be used (default: 1)
  --key-iterations <key-iterations>
                          The number of iterations to be used to generate a
                          PBKDF2 key (default: 1000)
  --key-length <key-length>
                          The size in bytes of the PBKDF2 key (default: 64)
  -m, --master-password <master-password>
                          The master password to be used 
  -l, --length <length>   The length in characters of the generated password
                          (default: 16)
  --lowercase/--uppercase/--decimal/--symbols
                          The charactes that must be used in the generated
                          password, at least one must be specified. Any
                          combinations of the flags may be specified and this
                          will be defined as having at least one character of
                          that character set 
  -h, --help              Show help information.
  
 > password-generator service-based --help
USAGE: password-generator-cli service-based --service <service> [--key-iterations <key-iterations>] [--key-length <key-length>] --master-password <master-password> [--length <length>] [--lowercase] [--uppercase] [--decimal] [--symbols]

OPTIONS:
  -s, --service <service> The service to which this password generator is used
                          for, e.g. a bank account 
  --key-iterations <key-iterations>
                          The number of iterations to be used to generate a
                          PBKDF2 key (default: 1000)
  --key-length <key-length>
                          The size in bytes of the PBKDF2 key (default: 64)
  -m, --master-password <master-password>
                          The master password to be used 
  -l, --length <length>   The length in characters of the generated password
                          (default: 16)
  --lowercase/--uppercase/--decimal/--symbols
                          The charactes that must be used in the generated
                          password, at least one must be specified. Any
                          combinations of the flags may be specified and this
                          will be defined as having at least one character of
                          that character set 
  -h, --help              Show help information.
```

## Installation
### Using Swift Package Manager

Add **PasswordGeneratorKit** as a dependency to your `Package.swift` file. For more information, see the [Swift Package Manager documentation](https://github.com/apple/swift-package-manager/tree/master/Documentation).

```
.package(url: "https://github.com/rkreutz/PasswordGeneratorKit", from: "1.0.0")
```

## Help & Feedback
- [Open an issue](https://github.com/rkreutz/PasswordGeneratorKit/issues/new) if you need help, if you found a bug, or if you want to discuss a feature request.
- [Open a PR](https://github.com/rkreutz/PasswordGeneratorKit/pull/new/master) if you want to make some change to `PasswordGeneratorKit`.
