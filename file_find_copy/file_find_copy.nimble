# Package

version       = "0.1.0"
author        = "MwlLj"
description   = "A new awesome nimble package"
license       = "MIT"
srcDir        = "src"
bin           = @["file_find_copy"]



# Dependencies

requires "nim >= 0.20.2"

requires "https://github.com/MwlLj/nim-parse"

# import os
task cr, "Testing `nimble c -r src/file_find_copy.nim` via setCommand":
    # var args = "src/file_find_copy.nim "
    # for cmd in os.commandLineParams():
    #     args.add(cmd)
    #     args.add(" ")
    # nim.exe c -r args
    --r
    # var args = "src/file_find_copy.nim "
    # for cmd in os.commandLineParams():
    #     args.add(cmd)
    #     args.add(" ")
    # echo(args)
    setCommand "c", "src/file_find_copy.nim"
