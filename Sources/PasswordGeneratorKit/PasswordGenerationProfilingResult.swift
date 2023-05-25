import Foundation

public struct PasswordGenerationProfilingResult: Equatable {
    public let entropyGeneration: TimeMeasurement
    public let computation: [LabeledTimeMeasurement]
    public let total: [LabeledTimeMeasurement]
}

public struct TimeMeasurement: Equatable {
    public let median: TimeInterval
    public let average: TimeInterval
    public let standardDeviation: TimeInterval

    public var probableRange: ClosedRange<TimeInterval> {
        (average - 3 * standardDeviation) ... (average + 3 * standardDeviation)
    }

    init(_ measurements: [TimeInterval]) {
        self.median = measurements.median()
        self.average = measurements.average()
        self.standardDeviation = measurements.standardDeviation()
    }
}

public struct LabeledTimeMeasurement: Equatable {
    public let passwordLength: UInt
    public let median: TimeInterval
    public let average: TimeInterval
    public let standardDeviation: TimeInterval

    init(passwordLength: UInt, measurements: [TimeInterval]) {
        self.passwordLength = passwordLength
        self.median = measurements.median()
        self.average = measurements.average()
        self.standardDeviation = measurements.standardDeviation()
    }
}

public extension Array where Element == LabeledTimeMeasurement {
    func average() -> TimeInterval {
        map(\.average).average()
    }
}

private extension Array where Element: FloatingPoint {

    func sum() -> Element {
        return reduce(0, +)
    }

    func average() -> Element {
        return sum() / Element(count)
    }

    func median() -> Element {
        guard !isEmpty else { return Element(0) }
        let sorted = sorted()
        if count % 2 == 0 {
            return (sorted[count / 2] + sorted[count / 2 - 1]) / 2
        } else {
            return sorted[count / 2]
        }
    }

    func standardDeviation() -> Element {
        let mean = average()
        let v = reduce(0, { $0 + ($1 - mean) * ($1 - mean) })
        return sqrt(v / (Element(count) - 1))
    }

}
