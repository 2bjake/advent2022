import Algorithms
import AdventUtilities

let partOneGameScores = [
  "A X": 1 + 3,
  "A Y": 2 + 6,
  "A Z": 3 + 0,
  "B X": 1 + 0,
  "B Y": 2 + 3,
  "B Z": 3 + 6,
  "C X": 1 + 6,
  "C Y": 2 + 0,
  "C Z": 3 + 3
]

public func partOne() {
  let score = input.split(separator: "\n").map(String.init).compactMap(partOneGameScores).reduce(0, +)
  print(score)
}

enum Outcome: Character {
  case lose = "X"
  case draw = "Y"
  case win = "Z"

  var score: Int {
    switch self {
      case .lose: return 0
      case .draw: return 3
      case .win: return 6
    }
  }
}

enum Play: Character {
  case rock = "A"
  case paper = "B"
  case scissors = "C"

  var score: Int {
    switch self {
      case .rock: return 1
      case .paper: return 2
      case .scissors: return 3
    }
  }

  func playForOutcome(_ outcome: Outcome) -> Play {
    switch (self, outcome) {
      case (.rock, .lose): return .scissors
      case (.rock, .win): return .paper
      case (.paper, .lose): return .rock
      case (.paper, .win): return .scissors
      case (.scissors, .lose): return .paper
      case (.scissors, .win): return .rock
      case (_, .draw): return self
    }
  }
}

public func partTwo() {
  let finalScore = input.split(separator: "\n").map {
    let outcome = Outcome(rawValue: $0.last!)!
    let play = Play(rawValue: $0.first!)!.playForOutcome(outcome)
    return outcome.score + play.score
  }.reduce(0, +)
  print(finalScore)
}
