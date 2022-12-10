import Algorithms
import RegexBuilder
import Foundation
import AdventUtilities

let intCapture = TryCapture { .localizedInteger(locale: .current) } transform: { Int($0) }

func parse() -> [Int] {
  input.split(separator: "\n").flatMap {
    var result = [0]
    if let (_, value) = $0.firstMatch(of: intCapture)?.output {
      result += [value]
    }
    return result
  }
}

public func partOne() {
  let cycles: Set = [20, 60, 100, 140, 180, 220]

  var result = 0
  var registerValue = 1
  var cycleNum = 1
  for addValue in parse() {
    if cycleNum.isIn(cycles) {
      result += cycleNum * registerValue
    }
    registerValue += addValue
    cycleNum += 1
  }

  print(result) // 14620
}

func drawLine(addValues: [Int], spritePos: inout Int) -> String {
  var result = ""
  var pixelNum = 0
  for value in addValues {
    result += absDiff(spritePos, pixelNum) <= 1 ? "🟩" : "⬛️"
    spritePos += value
    pixelNum += 1
  }
  return result
}

public func partTwo() {
  var spritePos = 1

  var lines = [String]()
  for values in parse().chunks(ofCount: 40) {
    lines.append(drawLine(addValues: Array(values), spritePos: &spritePos))
  }
  print(lines.joined(separator: "\n")) // BJFRHRFU
}
