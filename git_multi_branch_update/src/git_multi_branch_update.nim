import "replace/replace"
import "structs/replace_param"

import "cmd/go_style"

import os

proc main() =
    #[
    ## 解析命令行参数
    ]#
    var cmdHandler = go_style.newCmd()
    let src = cmdHandler.registerWithDesc("-src", "", "file path to be copied")
    let dst = cmdHandler.registerWithDesc("-dst", "", "update root path")
    let filter = cmdHandler.registerWithDesc("-filter", "", "filter branch, use , split; example: alpha,v1.6")
    let log = cmdHandler.registerWithDesc("-log", "update", "commit log info")
    cmdHandler.parse()
    replace.replace(replace_param.newReplaceParam(src[], dst[], filter[], log[]))

when isMainModule:
    main()
