public protocol MasterPasswordProvider {

    func masterPassword() throws -> String
}
