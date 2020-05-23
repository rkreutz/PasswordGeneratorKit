protocol EntropyGenerator {

    associatedtype Entropy: BinaryInteger

    func generateEntropy(with salt: String, masterPassword: String) throws -> Entropy
}
