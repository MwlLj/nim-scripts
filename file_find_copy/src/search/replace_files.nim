import "path/vertical_walk" as walk

import "../parse/cmd_replace"
import "../parse/cmd_split"
import "../parse/path_split"

import os
import strformat
import system.nimscript
import osproc

proc replace*(srcPath: string, root: string, command: string) =
    let srcs = path_split.split(srcPath)
    echo(srcs)
    var srcNames = newSeq[string](srcs.len())
    for s in srcs:
        let (_, srcName) = os.splitPath(s)
        srcNames.add(srcName)
    let currentDir = os.getCurrentDir()
    #[
    ## 遍历目录
    ]#
    proc fn(parent: string, name: string, path: string): walk.CbResult =
        var isContinue = true
        for src in srcs:
            # echo(fmt"{src}, {path}")
            if os.sameFile(src, path):
                echo(fmt"self: {src} {path}")
                isContinue = false
                break
        if not isContinue:
            return walk.CbResult.Continue
        let (dir, findedName) = os.splitPath(path)
        # echo(fmt"first: {first}, findedName: {findedName}")
        if not srcNames.contains(findedName):
            return walk.CbResult.Continue
        #[
        ## 1. 切换目录
        ## 2. 执行命令
        ## 3. 切换回原来的目录
        ]#
        echo(fmt"cd: {dir}")
        try:
            os.setCurrentDir(dir)
        except OSError:
            echo("cd error")
        let cur = os.getCurrentDir()
        echo(cur)
        let cmd = cmd_replace.replace(command, findedName)
        let cmds = cmd_split.split(cmd)
        for c in cmds:
            echo(fmt"exe: {c}")
            # nimscript.exec(c)
            discard osproc.execCmd(c)
        os.setCurrentDir(currentDir)
        for src in srcs:
            let (d, s) = os.splitPath(src)
            if s == findedName:
                echo(fmt"copy: {d/s} => {path}")
                os.copyFile(d/s, path)
        result = walk.CbResult.Continue
    walk.walk(root, fn)
