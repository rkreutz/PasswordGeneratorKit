import Combine
import Foundation
import PasswordGeneratorKit

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
private extension PasswordGenerator {

    struct Publisher: Combine.Publisher {

        typealias Output = PasswordGenerationProfilingResult
        typealias Failure = PasswordGenerator.Error

        var generator: PasswordGenerator
        var iterations: Int
        var passwordLengths: [UInt]

        func receive<S>(subscriber: S) where S: Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {

            let subscription = Subscription(
                subscriber: subscriber,
                generator: generator,
                iterations: iterations,
                passwordLengths: passwordLengths
            )
            subscriber.receive(subscription: subscription)
        }
    }

    final class Subscription: Combine.Subscription {

        private var subscriber: AnySubscriber<PasswordGenerationProfilingResult, PasswordGenerator.Error>?
        private let generator: PasswordGenerator
        private let iterations: Int
        private let passwordLengths: [UInt]
        private var queue: OperationQueue?

        init<Subscriber: Combine.Subscriber>(
            subscriber: Subscriber,
            generator: PasswordGenerator,
            iterations: Int,
            passwordLengths: [UInt]
        ) where Subscriber.Input == PasswordGenerationProfilingResult, Subscriber.Failure == PasswordGenerator.Error {

            self.subscriber = AnySubscriber(subscriber)
            self.generator = generator
            self.iterations = iterations
            self.passwordLengths = passwordLengths
        }

        public func request(_ demand: Subscribers.Demand) {

            guard demand > 0 else {

                subscriber?.receive(completion: .finished)
                return
            }

            queue = OperationQueue()
            queue?.addOperation { [generator, iterations, passwordLengths, weak self] in

                do {

                    let result = try generator.profilePasswordGeneration(iterations: iterations, passwordLengths: passwordLengths)

                    _ = self?.subscriber?.receive(result)
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

    func profilePasswordGeneration(
        iterations: Int = 5,
        passwordLengths: [UInt] = [4, 8, 16, 32]
    ) -> AnyPublisher<PasswordGenerationProfilingResult, PasswordGenerator.Error> {

        PasswordGenerator.Publisher(generator: generator, iterations: iterations, passwordLengths: passwordLengths)
            .eraseToAnyPublisher()
    }
}
