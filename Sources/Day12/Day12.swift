import Algorithms
import AdventUtilities

struct Map {
  let startPos: Position
  let endPos: Position

  let heightGrid: [[Int]]

  init(_ source: String) {
    var chars = source.split(separator: "\n").map(Array.init)

    startPos = chars.allPositions.first { chars[$0] == "S" }!
    chars[startPos] = "a"

    endPos = chars.allPositions.first { chars[$0] == "E" }!
    chars[endPos] = "z"

    heightGrid = chars.map {
      $0.map { Int($0.asciiValue!) - Int(Character("a").asciiValue!) }
    }
  }
}


public func partOne() {

  let map = Map(input)

  var toVisit = [map.endPos]
  var visited = Set<Position>()
  var inFrontier: Set<Position> = [map.endPos]
  var costs = Array(repeating: Array(repeating: Int.max, count: map.heightGrid[0].count), count: map.heightGrid.count)
  costs[map.endPos] = 0

  while !toVisit.isEmpty {
    let curPos = toVisit.removeFirst()
    let neighbors = map.heightGrid.adjacentPositions(of: curPos)
      .filter { !visited.contains($0) }
      .filter { map.heightGrid[curPos] - map.heightGrid[$0] <= 1 }

    for neighborPos in neighbors {
      if costs[neighborPos] > costs[curPos] + 1 {
        costs[neighborPos] = costs[curPos] + 1
      }
    }

    visited.insert(curPos)
    toVisit.append(contentsOf: neighbors.filter { !inFrontier.contains($0)})
    inFrontier.formUnion(neighbors)

  }

  print(costs[map.startPos])

  let shortest = map.heightGrid.allPositions.filter { map.heightGrid[$0] == 0 }.map { costs[$0] }.min()!
  print(shortest)

}

public func partTwo() {

}
