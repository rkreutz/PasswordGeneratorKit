extension PasswordRule {

    enum Case {

        case mustContain
        case length
    }

    func caseMatch(_ rule: Case) -> Bool {

        switch (self, rule) {

            case (.mustContain, .mustContain): return true
            case (.length, .length): return true
            default: return false
        }
    }
}
