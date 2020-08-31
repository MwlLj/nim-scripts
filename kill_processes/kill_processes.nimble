# Package

version       = "0.1.0"
author        = "MwlLj"
description   = "A new awesome nimble package"
license       = "MIT"
srcDir        = "src"
bin           = @["kill_processes"]



# Dependencies

requires "nim >= 1.0.6"

requires "https://github.com/MwlLj/nim-parse#191e503"

task run, "run":
  exec "nim c -r --outdir:target/run src/kill_processes.nim --name pgpool"

task build, "build":
  exec "nim c -r -d:release --outdir:target/build/release src/kill_processes.nim"

task build_debug, "build debug":
  exec "nim c -r -d:debug --outdir:target/build/debug src/kill_processes.nim"
