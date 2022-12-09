import Algorithms
import AdventUtilities
import RegexBuilder

func makeDirections(_ char: Character, _ count: Int) -> [Direction] {
  var direction: Direction

  switch char {
    case "L": direction = .left
    case "R": direction = .right
    case "U": direction = .up
    case "D": direction = .down
    default: return []
  }
  return Array(repeating: direction, count: count)
}

let regex = Regex {
  Anchor.startOfLine
  TryCapture { /L|R|U|D/ } transform: { $0.only }
  " "
  TryCapture { OneOrMore(.digit) } transform: { Int($0) }
  Anchor.endOfLine
}

public func partOneOrig() {
  var headPosition = Position(0, 0)
  var tailPosition = headPosition
  var visited: Set<Position> = [tailPosition]

  let directions = input.matches(of: regex).flatMap {
    makeDirections($0.output.1, $0.output.2)
  }

  for direction in directions {
    headPosition.move(direction)
    if tailPosition != headPosition && !tailPosition.isAdjacent(to: headPosition, includingDiagonals: true) {
      tailPosition.advance(toward: headPosition)
    }
    visited.insert(tailPosition)
  }
  print(visited.count) // 5513
}

public func moveRope(count: Int) {
  var positions = Array(repeating: Position(0, 0), count: count)
  var visited: Set<Position> = [positions.last!]

  let directions = input.matches(of: regex).flatMap {
    makeDirections($0.output.1, $0.output.2)
  }

  for direction in directions {
    positions[0].move(direction)

    for i in 1..<positions.count {
      if positions[i] != positions[i - 1] && !positions[i].isAdjacent(to: positions[i - 1], includingDiagonals: true) {
        positions[i].advance(toward: positions[i - 1])
      }
    }

    visited.insert(positions.last!)
  }
  print(visited.count)
}

public func partOne() {
  moveRope(count: 2) // 5513
}

public func partTwo() {
  moveRope(count: 10) // 2427
}
