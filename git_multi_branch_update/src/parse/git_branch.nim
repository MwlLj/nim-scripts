import os
import osproc
import strutils

proc deletePrefix(s: var string): bool =
    var last = 0
    var isCur = false
    for c in s:
        if c == ' ' or c == '*':
            if c == '*':
                isCur = true
            last += 1
        else:
            break
    s.delete(0, last - 1)
    return isCur

proc getGitBranchs*(path: string, filter: seq[string], exclude: seq[string]): tuple[bs: seq[tuple[isCur: bool, b: string]], ok: bool] =
    var bs = newSeq[tuple[isCur: bool, b: string]]()
    var currentDir: string
    try:
        currentDir = os.getCurrentDir()
    except OSError:
        echo("get current dir error")
        return (bs, false)
    try:
        os.setCurrentDir(path)
    except OSError:
        echo("cd error, please make sure -dst is true")
        return (bs, false)
    let r = osproc.execCmdEx("git branch")
    if r[1] != 0:
        return (bs, false)
    var branchs: seq[string]
    if filter.len() == 0:
        branchs = strutils.splitLines(r[0])
    else:
        branchs = filter
    # echo(filter.len(), branchs, exclude)
    for branch in branchs:
        if branch.len() > 0:
            var b = string(branch)
            let isCur = b.deletePrefix()
            if b in exclude:
                continue
            bs.add((isCur, b))
    try:
        os.setCurrentDir(currentDir)
    except OSError:
        echo("cd current error")
        return (bs, false)
    return (bs, true)
