private class _AnyEntropyGeneratorBase<Entropy: BinaryInteger>: EntropyGenerator {

    //swiftlint:disable:next unavailable_function
    func generateEntropy(with salt: String, masterPassword: String) throws -> Entropy {

        fatalError("Must be overriden")
    }
}

private final class _AnyEntropyGeneratorBox<Generator: EntropyGenerator>: _AnyEntropyGeneratorBase<Generator.Entropy> {

    let generator: Generator

    init(_ generator: Generator) {

        self.generator = generator
    }

    override func generateEntropy(with salt: String, masterPassword: String) throws -> Generator.Entropy {

        try generator.generateEntropy(with: salt, masterPassword: masterPassword)
    }
}

final class AnyEntropyGenerator<Entropy: BinaryInteger>: EntropyGenerator {

    private let box: _AnyEntropyGeneratorBase<Entropy>

    init<Generator: EntropyGenerator>(_ generator: Generator) where Generator.Entropy == Entropy {

        box = _AnyEntropyGeneratorBox(generator)
    }

    func generateEntropy(with salt: String, masterPassword: String) throws -> Entropy {

        try box.generateEntropy(with: salt, masterPassword: masterPassword)
    }
}
