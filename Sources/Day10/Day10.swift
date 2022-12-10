import Algorithms
import RegexBuilder
import Foundation
import AdventUtilities

enum Instruction {
  case noop
  case addx(Int)
}

let intCapture = TryCapture { .localizedInteger(locale: .current) } transform: { Int($0) }

func parseInstructions() -> [Instruction] {
  input.split(separator: "\n").flatMap {
    if $0 == "noop" {
      return [Instruction.noop]
    } else if let (_, value) = $0.firstMatch(of: intCapture)?.output {
      return [.noop, .addx(value)]
    } else {
      fatalError()
    }
  }
}



public func partOne() {
  let cycles: Set = [20, 60, 100, 140, 180, 220]

  var result = 0
  var value = 1
  var cycle = 1
  for instruction in parseInstructions() {
    if cycle.isIn(cycles) {
      result += cycle * value
    }
    if case let .addx(addValue) = instruction {
      value += addValue
    }
    cycle += 1
  }

  print(result)
}

struct Sprite {
  var centerPosition: Int

  func contains(_ x: Int) -> Bool {
    x == centerPosition - 1 || x == centerPosition || x == centerPosition + 1
  }
}

func drawLine(instructions: [Instruction], sprite: inout Sprite) -> String {
  var result = ""
  var pixelNum = 0
  for instruction in instructions {
    result += sprite.contains(pixelNum) ? "#" : " "
    if case let .addx(value) = instruction {
      sprite.centerPosition += value
    }
    pixelNum += 1
  }
  return result
}

public func partTwo() {
  var sprite = Sprite(centerPosition: 1)

  var lines = [String]()
  for lineInstructions in parseInstructions().chunks(ofCount: 40) {
    lines.append(drawLine(instructions: Array(lineInstructions), sprite: &sprite))
  }
  print(lines.joined(separator: "\n"))
}
