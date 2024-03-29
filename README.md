# PasswordGeneratorKit
![Swift 5.2](https://img.shields.io/badge/Swift-5.2-orange.svg)
[![Swift Package Manager](https://img.shields.io/badge/spm-compatible-brightgreen.svg?style=flat)](https://swift.org/package-manager)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![GitHub tag](https://img.shields.io/github/tag/rkreutz/PasswordGeneratorKit.svg)](https://GitHub.com/rkreutz/PasswordGeneratorKit/tags/)
[![Run Tests](https://github.com/rkreutz/PasswordGeneratorKit/actions/workflows/tests.yml/badge.svg)](https://github.com/rkreutz/PasswordGeneratorKit/actions/workflows/tests.yml)

As the name implies, this is a Swift Package that generates passwords pseudo-randomically deriving from a master password and some other inputs.

- [Usage](https://github.com/rkreutz/PasswordGeneratorKit/blob/master/README.md#usage)
  - [Discussion](https://github.com/rkreutz/PasswordGeneratorKit/blob/master/README.md#discussion)
- [CLI](https://github.com/rkreutz/PasswordGeneratorKit/blob/master/README.md#cli)
  - [Usage](https://github.com/rkreutz/PasswordGeneratorKit/blob/master/README.md#usage-1)
- [Installation](https://github.com/rkreutz/PasswordGeneratorKit/blob/master/README.md#installation)
- [Help & Feedback](https://github.com/rkreutz/PasswordGeneratorKit/blob/master/README.md#help--feedback)

## Usage

To use a `PasswordGenerator` you must specify a `MasterPasswordProvider`, which will be responsible for providing the master password from which the final password will be generated from. `String` by default conforms to `MasterPasswordProvider` by returning itself as the master password. You may optionally provide some extra configuration related to the entropy generator: you may use a PBKDF2 based entropy generator, providing an optional amount of iterations; or you may use a Argon2 based entropy generator, providing optional iterations, memory cost and threads. Both entropy generators support also the amount of bytes that should be generated.

```swift
let passwordGenerator = PasswordGenerator(
    masterPasswordProvider: "masterPassword",
    entropyGenerator: .pbkdf2(iterations: 1_000),
    bytes: 24
)

// OR

let passwordGenerator = PasswordGenerator(
    masterPasswordProvider: "masterPassword",
    entropyGenerator: .argon2(iterations: 3, memory: 16_384, threads: 1),
    bytes: 24
)
```

With the created password generator you can generate passwords through the provided methods which expects some inputs that will be used as a `salt` on the underlying entropy generator.

```swift
// Generates a password using a salt based on an username (email, username, ...), domain (website domain) and seed (user defined number).
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
    case mustContain(characterSet: String, atLeast: UInt)
    
    // The length of the generated password
    case length(UInt)
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

### Discussion
- You can further tweak the entropy generators so they take less or more time to generate entropy. The longer it takes, the better it is on a security level perspective, but at the same time it degrades user experience.
- The number of `bytes` will affect how many characters the password generator will be able to randomize before starting to repeat itself (entropy), so if you get to a point where the generated password has several trailing characters that are the same, most likely you need more bytes being generated by your entropy source. 24 _should_ be enough for up to 32 characters long passwords.

## CLI

There is a CLI for using the password generator, you can easily download it from the latest Release or compile it locally with:
```bash
swift build --configuration release
```

### Usage
```bash
> password-generator --help (master) 
OVERVIEW: Deterministic password generator.

A password generator which will detereministically generate random passwords.
Will always generate the same passwords given the same input.

USAGE: password-generator <subcommand>

OPTIONS:
  --version               Show the version.
  -h, --help              Show help information.

SUBCOMMANDS:
  salt-based
  service-based
  domain-based

> password-generator salt-based --help
USAGE: password-generator salt-based <options>

OPTIONS:
  -s, --salt <salt>       The salt to be used 
  --entropy-source <entropy-source>
                          The entropy source to be used (default: pbkdf2)
  -i, --iterations <iterations>
                          The number of iterations to be used by the entropy source (default: 1000)
  -m, --memory <memory>   The memory cost in kilobytes to be used by Argon2 entropy source. Ignored if using PBKDF2 (default: 16384)
  -t, --threads <threads> The number of threads to be used by Argon2 entropy source. Ignored if using PBKDF2 (default: 1)
  --entropy <entropy>     The size in bytes of the generated entropy (default: 64)
  -p, --master-password <master-password>
                          The master password to be used 
  -l, --length <length>   The length in characters of the generated password (default: 16)
  --lowercase/--uppercase/--decimal/--symbols
                          The charactes that must be used in the generated password, at least one must be specified. Any combinations of the flags may be specified and this
                          will be defined as having at least one character of that character set 
  -v, --verbose           Prints extra info in the terminal 
  --version               Show the version.
  -h, --help              Show help information.
  
 > password-generator domain-based --help
SAGE: password-generator domain-based <options>

OPTIONS:
  -u, --username <username>
                          The username to which this password generator is used for, e.g. an email 
  -d, --domain <domain>   The domain to which this password generator is used for, e.g. a website 
  -s, --seed <seed>       The seed to be used (default: 1)
  --entropy-source <entropy-source>
                          The entropy source to be used (default: pbkdf2)
  -i, --iterations <iterations>
                          The number of iterations to be used by the entropy source (default: 1000)
  -m, --memory <memory>   The memory cost in kilobytes to be used by Argon2 entropy source. Ignored if using PBKDF2 (default: 16384)
  -t, --threads <threads> The number of threads to be used by Argon2 entropy source. Ignored if using PBKDF2 (default: 1)
  --entropy <entropy>     The size in bytes of the generated entropy (default: 64)
  -p, --master-password <master-password>
                          The master password to be used 
  -l, --length <length>   The length in characters of the generated password (default: 16)
  --lowercase/--uppercase/--decimal/--symbols
                          The charactes that must be used in the generated password, at least one must be specified. Any combinations of the flags may be specified and this
                          will be defined as having at least one character of that character set 
  -v, --verbose           Prints extra info in the terminal 
  --version               Show the version.
  -h, --help              Show help information.
  
 > password-generator service-based --help
USAGE: password-generator service-based <options>

OPTIONS:
  -s, --service <service> The service to which this password generator is used for, e.g. a bank account 
  --entropy-source <entropy-source>
                          The entropy source to be used (default: pbkdf2)
  -i, --iterations <iterations>
                          The number of iterations to be used by the entropy source (default: 1000)
  -m, --memory <memory>   The memory cost in kilobytes to be used by Argon2 entropy source. Ignored if using PBKDF2 (default: 16384)
  -t, --threads <threads> The number of threads to be used by Argon2 entropy source. Ignored if using PBKDF2 (default: 1)
  --entropy <entropy>     The size in bytes of the generated entropy (default: 64)
  -p, --master-password <master-password>
                          The master password to be used 
  -l, --length <length>   The length in characters of the generated password (default: 16)
  --lowercase/--uppercase/--decimal/--symbols
                          The charactes that must be used in the generated password, at least one must be specified. Any combinations of the flags may be specified and this
                          will be defined as having at least one character of that character set 
  -v, --verbose           Prints extra info in the terminal 
  --version               Show the version.
  -h, --help              Show help information.
```

## Installation
### Using Swift Package Manager

Add **PasswordGeneratorKit** as a dependency to your `Package.swift` file. For more information, see the [Swift Package Manager documentation](https://github.com/apple/swift-package-manager/tree/master/Documentation).

```swift
.package(url: "https://github.com/rkreutz/PasswordGeneratorKit", from: "4.1.0")
```

## Help & Feedback
- [Open an issue](https://github.com/rkreutz/PasswordGeneratorKit/issues/new) if you need help, if you found a bug, or if you want to discuss a feature request.
- [Open a PR](https://github.com/rkreutz/PasswordGeneratorKit/pull/new/master) if you want to make some change to `PasswordGeneratorKit`.
