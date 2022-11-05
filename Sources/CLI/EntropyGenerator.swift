import ArgumentParser
import PasswordGeneratorKit

public enum EntropyGenerator: String, ExpressibleByArgument {

    case pbkdf2
    case argon2
}
