import "search/replace_files"
import "search/replace_dir"

import "cmd/go_style"

import os

proc main() =
    #[
    ## 解析命令行参数
    ]#
    var cmdHandler = go_style.newCmd()
    let src = cmdHandler.registerWithDesc("-src", "", "file path to be copied")
    let root = cmdHandler.registerWithDesc("-root", ".", "search root path")
    let mode = cmdHandler.registerWithDesc("-mode", "file", "replace mode file/dir")
    let command = cmdHandler.registerWithDesc("-cmd", "git pull;git add {name};git commit -m \"update\";git push origin alpha", "execute command")
    cmdHandler.parse()
    case mode[]
    of "file":
        replace_files.replace(src[], root[], command[])
    of "dir":
        replace_dir.replace(src[], root[])

when isMainModule:
    main()
