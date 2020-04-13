extension String {
    
    static let lowercaseCharacters = "qwertyuiopasdfghjklzxcvbnm"
    static let uppercaseCharacters = "QWERTYUIOPASDFGHJKLZXCVBNM"
    static let decimalCharacters = "1234567890"
    static let symbolCharacters = "!@#$%&_-|?."

    subscript(_ integer: Int) -> Character { self[index(startIndex, offsetBy: integer)] }

    subscript(_ range: ClosedRange<Int>) -> Substring {

        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(startIndex, offsetBy: range.upperBound)
        return self[start ... end]
    }

    subscript(_ range: PartialRangeUpTo<Int>) -> Substring {

        let start = startIndex
        let end = index(startIndex, offsetBy: range.upperBound)
        return self[start ..< end]
    }

    subscript(_ range: PartialRangeThrough<Int>) -> Substring {

        let start = startIndex
        let end = index(startIndex, offsetBy: range.upperBound)
        return self[start ... end]
    }

    subscript(_ range: PartialRangeFrom<Int>) -> Substring {

        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = endIndex
        return self[start ..< end]
    }

    subscript(_ range: CountableRange<Int>) -> Substring {

        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(startIndex, offsetBy: range.upperBound)
        return self[start ..< end]
    }

    mutating func insertStringRandomically<Entropy>(_ string: String, entropy: Entropy)
        where Entropy: BinaryInteger {

        var remainingEntropy = entropy
        for character in string {

            let (quotient, remainder) = remainingEntropy.quotientAndRemainder(dividingBy: max(Entropy(count), 1))

            switch remainder {

                case 0:
                    self = "\(character)" + self

                case (Entropy(count) - 1)...:
                    self += "\(character)"

                case let remainder:
                    self = String(self[..<Int(remainder)]) + "\(character)" + String(self[Int(remainder)...])
            }

            remainingEntropy = quotient
        }
    }
}
