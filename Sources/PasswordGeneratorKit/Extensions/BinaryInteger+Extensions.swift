extension BinaryInteger {

    func consumeEntropy(
        generatedPassword: String,
        characters: String,
        maxLength: Int
    ) -> (password: String, remainingEntropy: Self) {

        guard generatedPassword.count < maxLength else { return (generatedPassword, self) }

        let (quotient, remainder) = quotientAndRemainder(dividingBy: max(Self(characters.count), 1))

        let character = characters[Int(remainder)]

        return quotient.consumeEntropy(
            generatedPassword: generatedPassword + "\(character)",
            characters: characters,
            maxLength: maxLength
        )
    }
}
