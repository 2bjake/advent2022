import Algorithms
import AdventUtilities
import RegexBuilder

//// parsing with splits ////

func range(from str: Substring) -> ClosedRange<Int> {
  let parts = str.split(separator: "-")
  return Int(parts[0])!...Int(parts[1])!
}

func ranges() -> [(ClosedRange<Int>, ClosedRange<Int>)] {
  input.split(separator: "\n").map {
    let parts = $0.split(separator: ",")
    return (range(from: parts[0]), range(from: parts[1]))
  }
}

//// parsing with RegexBuilder ////

func regexRanges() -> [(ClosedRange<Int>, ClosedRange<Int>)] {
  let int = Capture {
    OneOrMore(.digit)
  } transform: {
    Int($0)!
  }

  let rangeRegex = Regex {
    int
    "-"
    int
  }

  let lineRegex = Regex {
    Anchor.startOfLine
    rangeRegex
    ","
    rangeRegex
    Anchor.endOfLine
  }

  return input.matches(of: lineRegex).map { output in
    (output.1...output.2, output.3...output.4)
  }
}

func count(using predicate: (ClosedRange<Int>, ClosedRange<Int>) -> Bool) -> Int {
  ranges().count { predicate($0, $1) || predicate($1, $0) }
}


public func partOne() {
  let result = count { $0.contains($1) }
  print(result) //456
}

public func partTwo() {
  let result = count { $0.overlaps($1) }
  print(result) //808
}
