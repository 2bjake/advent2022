import Algorithms

func findMarker(size: Int) -> Int? {
  var i = size
  for window in input.windows(ofCount: size) {
    if Set(window).count == size {
      return i
    }
    i += 1
  }
  return nil
}

public func partOne() {
  print(findMarker(size: 4)!) // 1876
}

public func partTwo() {
  print(findMarker(size: 14)!) // 2202
}
