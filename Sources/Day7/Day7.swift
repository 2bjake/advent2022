import RegexBuilder

let stringCapture = Capture { OneOrMore(.any) } transform: { String($0) }

let cdRegex = Regex {
  "$ cd "
  stringCapture
}

let dirRegex = Regex {
  "dir "
  stringCapture
}

let fileRegex = Regex {
  TryCapture { OneOrMore(.digit) } transform: { Int($0) }
  " "
  stringCapture
}

func buildFileSystem() -> FileSystem {
  var fs = FileSystem()
  var lines = input.split(separator: "\n")

  func handleLS() {
    lines.removeFirst()
    while let line = lines.first, line.first != "$" {
      if let (_, dir) = line.wholeMatch(of: dirRegex)?.output {
        fs.makeDir(dir)
      } else if let (_, size, name) = line.wholeMatch(of: fileRegex)?.output {
        fs.makeFile(name, size: size)
      } else {
        fatalError()
      }
      lines.removeFirst()
    }
  }

  while let line = lines.first {
    if let (_, dir) = line.wholeMatch(of: cdRegex)?.output {
      fs.cd(dir)
      lines.removeFirst()
    } else if line == "$ ls" {
      handleLS()
    } else {
      fatalError()
    }
  }
  return fs
}

public func partOne() {
  let fs = buildFileSystem()
  let sum = fs.sizes.filter { $0 <= 100000 }.reduce(0, +)
  print(sum) // 1778099
}

public func partTwo() {
  let fs = buildFileSystem()
  let neededSpace = 30000000 - fs.unusedSpace
  let sizeOfDirToDelete = fs.sizes.filter { $0 >= neededSpace }.min()!
  print(sizeOfDirToDelete) // 1623571
}
