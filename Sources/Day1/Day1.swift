import Algorithms
import AdventUtilities

func calorieSums() -> [Int] {
  input.split(separator: "\n\n").map {
    $0.split(separator: "\n").compactMap(Int.init).reduce(0, +)
  }
}

public func partOne() {
  print(calorieSums().max()!) // 71471
}

public func partTwo() {
  print(calorieSums().max(count: 3).reduce(0, +)) // 211189
}
