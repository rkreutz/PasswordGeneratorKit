public enum PasswordRule {

    case mustContain(characterSet: String, atLeast: Int)
    case length(Int)
}
