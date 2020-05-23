extension PasswordRule: Hashable {

    public func hash(into hasher: inout Hasher) {

        switch self {

        case .length:
            hasher.combine(1)

        case let .mustContain(characterSet, _):
            hasher.combine(2)
            hasher.combine(characterSet)
        }
    }
}
