import Combine
import Foundation
import PasswordGeneratorKit

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
private extension PasswordGenerator {

    struct Publisher: Combine.Publisher {

        typealias Output = String
        typealias Failure = PasswordGenerator.Error

        var generator: PasswordGenerator
        var username: String
        var domain: String
        var seed: Int
        var rules: Set<PasswordRule>

        func receive<S>(subscriber: S) where S: Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {

            let subscription = Subscription(
                subscriber: subscriber,
                generator: generator,
                username: username,
                domain: domain,
                seed: seed,
                rules: rules
            )
            subscriber.receive(subscription: subscription)
        }
    }

    final class Subscription: Combine.Subscription {

        private var subscriber: AnySubscriber<String, PasswordGenerator.Error>?
        private let generator: PasswordGenerator
        private let username: String
        private let domain: String
        private let seed: Int
        private let rules: Set<PasswordRule>
        private var queue: OperationQueue?

        init<Subscriber: Combine.Subscriber>(
            subscriber: Subscriber,
            generator: PasswordGenerator,
            username: String,
            domain: String,
            seed: Int,
            rules: Set<PasswordRule>
        ) where Subscriber.Input == String, Subscriber.Failure == PasswordGenerator.Error {

            self.subscriber = AnySubscriber(subscriber)
            self.generator = generator
            self.username = username
            self.domain = domain
            self.seed = seed
            self.rules = rules
        }

        public func request(_ demand: Subscribers.Demand) {

            guard demand > 0 else {

                subscriber?.receive(completion: .finished)
                return
            }

            queue = OperationQueue()
            queue?.addOperation { [generator, username, domain, seed, rules, weak self] in

                do {

                    let password = try generator.generatePassword(username: username, domain: domain, seed: seed, rules: rules)

                    _ = self?.subscriber?.receive(password)
                    self?.subscriber?.receive(completion: .finished)
                } catch let error as PasswordGenerator.Error {

                    self?.subscriber?.receive(completion: .failure(error))
                } catch {

                    assertionFailure("This shouldn't happen")
                    self?.subscriber?.receive(completion: .finished)
                }
            }
        }

        public func cancel() {

            subscriber = nil
            queue?.cancelAllOperations()
        }
    }
}

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension PasswordGenerator.Publishers {

    func generatePassword(
        username: String,
        domain: String,
        seed: Int,
        rules: Set<PasswordRule>
    ) -> AnyPublisher<String, PasswordGenerator.Error> {

        PasswordGenerator.Publisher(generator: generator, username: username, domain: domain, seed: seed, rules: rules)
            .eraseToAnyPublisher()
    }
}
