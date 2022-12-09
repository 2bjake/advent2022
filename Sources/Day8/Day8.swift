import Algorithms
import AdventUtilities

public func partOne() {
  let trees = input.split(separator: "\n").map {
    $0.compactMap(Int.init)
  }

  var visibleGrid = Array(repeating: Array(repeating: false, count: trees[0].count), count: trees.count)

  func recordVisibility(for positions: [Position]) {
    var highestTree = -1
    for position in positions {
      if trees[position] > highestTree {
        highestTree = trees[position]
        visibleGrid[position] = true
      }
    }
  }

  for rowNum in 0..<trees.numberOfRows {
    let positions = trees.positionsInRow(rowNum)
    recordVisibility(for: positions)
    recordVisibility(for: positions.reversed())
  }

  for colNum in 0..<trees.numberOfColumns {
    let positions = trees.positionsInColumn(colNum)
    recordVisibility(for: positions)
    recordVisibility(for: positions.reversed())
  }

  let visibleTrees = visibleGrid.allPositions.count { visibleGrid[$0] }
  print(visibleTrees) // 1816
}

public func partTwo() {
  let trees = input.split(separator: "\n").map {
    $0.compactMap(Int.init)
  }

  func calculateScore(at position: Position, inDirection direction: Direction) -> Int {
    var score = 0
    var curPosition = position.moved(direction)
    while trees.isValidPosition(curPosition) {
      score += 1
      if trees[position] <= trees[curPosition] { break }
      curPosition = curPosition.moved(direction)
    }
    return score
  }

  var bestScore = 0

  for position in trees.allPositions {
    let score = Direction.allCases.map { calculateScore(at: position, inDirection: $0) }.reduce(1, *)
    bestScore = max(score, bestScore)
  }
  print(bestScore) // 383520
}
