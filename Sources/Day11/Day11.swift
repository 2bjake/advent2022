import Algorithms
import RegexBuilder
import Foundation
import AdventUtilities

let intCapture = TryCapture { .localizedInteger(locale: .current) } transform: { Int($0) }

struct Monkey {
  var inspectCount = 0

  var worryLevels: [Int]
  let operation: (Int, Int) -> Int
  let operand: Int?
  let modulo: Int
  let trueMonkeyIdx: Int
  let falseMonkeyIdx: Int
  let divideByThree: Bool

  init<S: StringProtocol>(_ source: S, divideByThree: Bool) {
    let lines = source.components(separatedBy: "\n")
    worryLevels = lines[1].matches(of: intCapture).map(\.output.1)
    operation = lines[2].contains("+") ? (+) : (*)
    operand = lines[2].firstMatch(of: intCapture)?.output.1
    modulo = lines[3].firstMatch(of: intCapture)!.output.1
    trueMonkeyIdx = lines[4].firstMatch(of: intCapture)!.output.1
    falseMonkeyIdx = lines[5].firstMatch(of: intCapture)!.output.1
    self.divideByThree = divideByThree
  }

  private func calculatePlan(worryLevel: Int) -> (worryLevel: Int, monkeyIdx: Int) {
    var value = operation(worryLevel, operand ?? worryLevel)
    if divideByThree {
      value /= 3
    }
    let monkeyIdx = value % modulo == 0 ? trueMonkeyIdx : falseMonkeyIdx
    return (value, monkeyIdx)
  }

  mutating func throwItems() -> [(worryLevel: Int, monkeyIdx: Int)] {
    inspectCount += worryLevels.count
    let result = worryLevels.map(calculatePlan)
    worryLevels = []
    return result
  }
}

func makePartOneMonkey<S: StringProtocol>(_ source: S) -> Monkey {
  Monkey(source, divideByThree: true)
}

func makePartTwoMonkey<S: StringProtocol>(_ source: S) -> Monkey {
  Monkey(source, divideByThree: false)
}

public func partOne() {
  var monkeys = input.split(separator: "\n\n").map(makePartOneMonkey)
  for _ in 0..<20 {
    for i in monkeys.indices {
      for result in monkeys[i].throwItems() {
        monkeys[result.monkeyIdx].worryLevels.append(result.worryLevel)
      }
    }
  }

  let result = monkeys.max(count: 2, sortedBy: sorter(for: \.inspectCount)).map(\.inspectCount).reduce(1, *)
  print(result) // 117640
}

public func partTwo() {
  var monkeys = input.split(separator: "\n\n").map(makePartTwoMonkey)
  let superMod = monkeys.map(\.modulo).reduce(1, *)

  for _ in 0..<10_000 {
    for i in monkeys.indices {
      for result in monkeys[i].throwItems() {
        monkeys[result.monkeyIdx].worryLevels.append(result.worryLevel % superMod)
      }
    }
  }

  let result = monkeys.max(count: 2, sortedBy: sorter(for: \.inspectCount)).map(\.inspectCount).reduce(1, *)
  print(result) // 30616425600
}
