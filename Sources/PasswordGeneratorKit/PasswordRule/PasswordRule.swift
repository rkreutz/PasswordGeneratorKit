public enum PasswordRule {

    case mustContain(characterSet: String, atLeast: UInt)
    case length(UInt)
}
