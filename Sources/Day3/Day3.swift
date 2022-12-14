import Algorithms
import AdventUtilities

func priority(of char: Character) -> Int {
  switch char {
    case "a"..."z":
      return Int(char.asciiValue! - Character("a").asciiValue!) + 1
    case "A"..."Z":
      return Int(char.asciiValue! - Character("A").asciiValue!) + 27
    default:
      return 0
  }
}

public func partOne() {
  let result = input.split(separator: "\n").map {
    let halves = $0.halved()!
    let char = Set(halves.front).intersection(halves.back).only!
    return priority(of: char)
  }.reduce(0, +)
  print(result) // 7878
}

func priorityOfGroup(_ group: any Collection<[Character]>) -> Int {
  let group = group.map(Set.init)
  guard let first = group.first else { return 0 }
  let char = group.reduce(first) { result, value in
    result.intersection(value)
  }.only!
  return priority(of: char)
}

public func partTwo() {
  let result = input
    .split(separator: "\n")
    .map(Array.init)
    .chunks(ofCount: 3)
    .map(priorityOfGroup)
    .reduce(0, +)
  print(result) // 2760
}
