import Algorithms
import RegexBuilder
import AdventUtilities

struct Instruction {
  let count: Int
  let from: Int
  let to: Int
}

func parseInstructions() -> [Instruction] {
  let captureInt = TryCapture { OneOrMore(.digit) } transform: { Int($0) }

  let regex = Regex {
    Anchor.startOfLine
    "move "
    captureInt
    " from "
    captureInt
    " to "
    captureInt
    Anchor.endOfLine
  }

  return instructionsInput.matches(of: regex).map { Instruction(count: $0.1, from: $0.2, to: $0.3) }
}

func parseCrates() -> [[Character]] {
  let chars = cratesInput.split(separator: "\n").map(Array.init)
  var crates = Array(repeating: [Character](), count: 9)

  for i in chars.indices {
    let line = chars[i]
    for j in 0..<9 {
      let char = line[1 + j * 4]
      if char != " " {
        crates[j].append(char)
      }
    }
  }
  return crates.map { $0.reversed() }
}

func perform9000(_ instruction: Instruction, on crates: inout [[Character]]) {
  for _ in 0..<instruction.count {
    let char = crates[instruction.from - 1].removeLast()
    crates[instruction.to - 1].append(char)
  }
}

func perform9001(_ instruction: Instruction, on crates: inout [[Character]]) {
  let chars = crates[instruction.from - 1].suffix(instruction.count)
  crates[instruction.from - 1].removeLast(instruction.count)
  crates[instruction.to - 1].append(contentsOf: chars)
}

func moveCrates(craneModel: Int) -> String {
  var crates = parseCrates()
  let instructions = parseInstructions()

  for instruction in instructions {
    if craneModel == 9000 {
      perform9000(instruction, on: &crates)
    } else {
      perform9001(instruction, on: &crates)
    }
  }
  return String(crates.compactMap(\.last))
}

public func partOne() {
  print(moveCrates(craneModel: 9000))
}

public func partTwo() {
  print(moveCrates(craneModel: 9001))
}
