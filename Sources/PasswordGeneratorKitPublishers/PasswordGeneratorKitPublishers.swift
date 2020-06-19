import Foundation
import PasswordGeneratorKit

public extension PasswordGenerator {

    struct Publishers {

        let generator: PasswordGenerator

        public init(_ generator: PasswordGenerator) {

            self.generator = generator
        }
    }

    var publishers: Publishers {

        Publishers(self)
    }
}
