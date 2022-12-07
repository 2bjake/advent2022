//
//  FileSystem.swift
//  
//
//  Created by Jake Foster on 12/7/22.
//

private class Directory {
  var subDirs = [String: Directory]()
  var files = [String: Int]()

  lazy var size: Int  = {
    subDirs.values.map(\.size).reduce(0, +) + files.values.reduce(0, +)
  }()
}

struct FileSystem {
  private var allDirs = [Directory()]
  private var dirStack = [Directory]()

  private var rootDir: Directory { allDirs.first! }
  private var curDir: Directory { dirStack.last! }

  var unusedSpace: Int { 70000000 - rootDir.size }
  var sizes: [Int] { allDirs.map(\.size) }

  mutating func cd(_ dir: String) {
    switch dir {
      case "..":
        dirStack.removeLast()
      case "/":
        dirStack = [rootDir]
      default:
        dirStack.append(curDir.subDirs[dir]!)
    }
  }

  mutating func makeDir(_ dir: String) {
    guard curDir.subDirs[dir] == nil else { return }
    let newDir = Directory()
    curDir.subDirs[dir] = newDir
    allDirs.append(newDir)
  }

  mutating func makeFile(_ name: String, size: Int) {
    curDir.files[name] = size
  }
}
