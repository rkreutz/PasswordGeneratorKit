extension PasswordRule: Equatable {

    public static func == (lhs: PasswordRule, rhs: PasswordRule) -> Bool {

        switch (lhs, rhs) {

        case let (.length(lhsLength), .length(rhsLength)):
            return lhsLength == rhsLength

        case let (.mustContain(lhsCharacterSet, lhsCount), .mustContain(rhsCharacterSet, rhsCount)):
            return lhsCharacterSet == rhsCharacterSet && lhsCount == rhsCount

        default:
            return false
        }
    }
}
