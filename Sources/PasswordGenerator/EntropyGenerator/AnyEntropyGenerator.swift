private class _AnyEntropyGeneratorBase<Entropy: BinaryInteger>: EntropyGenerator {

    func generateEntropy(with salt: String, masterPassword: String) throws -> Entropy {

        fatalError("Must be overriden")
    }
}

private final class _AnyEntropyGeneratorBox<Generator: EntropyGenerator>: _AnyEntropyGeneratorBase<Generator.Entropy> {

    let generator: Generator

    init(_ _generator: Generator) {

        generator = _generator
    }

    override func generateEntropy(with salt: String, masterPassword: String) throws -> Generator.Entropy {

        try generator.generateEntropy(with: salt, masterPassword: masterPassword)
    }
}

final class AnyEntropyGenerator<Entropy: BinaryInteger>: EntropyGenerator {

    private let box: _AnyEntropyGeneratorBase<Entropy>

    public init<Generator: EntropyGenerator>(_ generator: Generator) where Generator.Entropy == Entropy {

        box = _AnyEntropyGeneratorBox(generator)
    }

    func generateEntropy(with salt: String, masterPassword: String) throws -> Entropy {

        try box.generateEntropy(with: salt, masterPassword: masterPassword)
    }
}
