import Algorithms
import AdventUtilities

indirect enum List {
  case int(Int)
  case list([List])
}

extension List: Comparable {
  static func < (lhs: List, rhs: List) -> Bool {
    Day13.compare(lhs, rhs) == .inOrder
  }
}

extension List: Equatable {}


func makeList(_ source: Substring) -> (list: List, remaining: Substring) {
  guard source.first == "[" else { fatalError("not a list") }
  var remaining = source.dropFirst()
  var contents = [List]()

  while remaining.first != "]" {
    if let intMatch = remaining.prefixMatch(of: /\d+/) {
      contents.append(.int(Int(intMatch.output)!))
      remaining = remaining.dropFirst(intMatch.output.count)
    } else if remaining.first == "[" {
      let result = makeList(remaining)
      contents.append(result.list)
      remaining = result.remaining
    } else if remaining.first == "," {
      remaining.removeFirst()
    } else {
      fatalError("unexpected char")
    }
  }

  return (.list(contents), remaining.dropFirst())
}

func parseList(_ source: Substring) -> List {
  let (list, remaining) = makeList(source)
  guard remaining.isEmpty else { fatalError() }
  return list
}

enum CompareResult { case inOrder, outOfOrder, undetermined }

func compareContents(_ a: [List], _ b: [List]) -> CompareResult {
  for pair in zip(a, b) {
    let result = compare(pair.0, pair.1)
    if result != .undetermined {
      return result
    }
  }

  return a.count < b.count ? .inOrder : a.count > b.count ? .outOfOrder : .undetermined
}

func compare(_ a: List, _ b: List) -> CompareResult {
  switch (a, b) {
    case (.int(let i), .int(let j)):
      return i < j ? .inOrder : i > j ? .outOfOrder : .undetermined
    case (.int, .list):
      return compare(.list([a]), b)
    case (.list, .int):
      return compare(a, .list([b]))
    case (.list(let contentA), .list(let contentB)):
      return compareContents(contentA, contentB)

  }
}

public func partOne() {
  let pairs = input.split(separator: "\n\n").map {
    $0.split(separator: "\n").map(parseList)
  }

  var sum = 0
  for i in 0..<pairs.count {
    if compare(pairs[i][0], pairs[i][1]) == .inOrder {
      sum += i + 1
    }
  }

  print(sum)

}

public func partTwo() {
  var pairs = input.split(separator: "\n\n").flatMap {
    $0.split(separator: "\n").map(parseList)
  }

  let dividerPackets = [List.list([.list([.int(2)])]), .list([.list([.int(6)])])]
  pairs.append(contentsOf: dividerPackets)
  pairs.sort()
  let key = dividerPackets
    .map { pairs.firstIndex(of: $0)! + 1 }
    .reduce(1, *)

  print(key)
}
