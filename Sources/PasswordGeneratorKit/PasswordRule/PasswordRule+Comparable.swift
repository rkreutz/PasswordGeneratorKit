extension PasswordRule: Comparable {

    public static func < (lhs: PasswordRule, rhs: PasswordRule) -> Bool {

        switch (lhs, rhs) {

        case (.length, _):
            return true

        case (_, .length):
            return false

        case let (.mustContain(lhsCharacterSet, _), .mustContain(rhsCharacterSet, _)):
            return lhsCharacterSet < rhsCharacterSet
        }
    }
}
