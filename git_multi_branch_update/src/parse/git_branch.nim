import os
import osproc
import strutils
import strformat
import tables

proc deletePrefix(s: var string) =
    var last = 0
    for c in s:
        if c == ' ' or c == '*':
            last += 1
        else:
            break
    s.delete(0, last - 1)

proc branchTokens(b: string): seq[string] =
    var word: string
    var tokens: seq[string]
    for c in b:
        if c == ' ':
            if word.len() > 0:
                tokens.add(word)
            word = ""
        else:
            word.add(c)
    if word.len() > 0:
        tokens.add(word)
    return tokens

proc branchName(b: string): string =
    var name: string
    var word: string
    for c in b:
        if c == '/':
            if word.len() > 0:
                name = word
            word = ""
        else:
            word.add(c)
    if word.len() > 0:
        name = word
    return name

type
    TokenMode = enum
        TokenModeNormal,
        TokenModeRedir

proc parseBranch(b: string): string =
    let tokens = branchTokens(b)
    var tokenMode: TokenMode
    var branch: string
    for token in tokens:
        case tokenMode
        of TokenMode.TokenModeNormal:
            if token == "->":
                tokenMode = TokenMode.TokenModeRedir
            else:
                branch = token
        of TokenMode.TokenModeRedir:
            branch = token
            break
    return branchName(branch)

proc getAllBranch(s: string): tuple[bs: seq[string], ok: bool] =
    let branchs = strutils.splitLines(s)
    var bsMap = initTable[string, bool]()
    var bs: seq[string]
    for branch in branchs:
        if branch.len() == 0:
            continue
        let b = parseBranch(branch)
        if bsMap.hasKey(b):
            discard
        else:
            bsMap.add(b, true)
            bs.add(b)
    return (bs, true)

proc getGitBranchs*(path: string, filter: seq[string], exclude: seq[string]): tuple[bs: seq[string], curBranch: string, ok: bool] =
    var bs = newSeq[string]()
    var curBranch: string
    var currentDir: string
    try:
        currentDir = os.getCurrentDir()
    except OSError:
        echo("get current dir error")
        return (bs, curBranch, false)
    try:
        os.setCurrentDir(path)
    except OSError:
        echo("cd error, please make sure -dst is true")
        return (bs, curBranch, false)
    # 获取当前分支
    let curBranchRet = osproc.execCmdEx("git name-rev --name-only HEAD")
    if curBranchRet[1] != 0:
        return (bs, curBranch, false)
    curBranch = curBranchRet[0]
    let r = osproc.execCmdEx("git branch -r")
    if r[1] != 0:
        return (bs, curBranch, false)
    var branchs: seq[string]
    if filter.len() == 0:
        let allBranchRet = getAllBranch(r[0])
        if not allBranchRet.ok:
            return (bs, curBranch, false)
        branchs = allBranchRet.bs
    else:
        branchs = filter
    # echo(filter.len(), branchs, exclude)
    echo()
    for branch in branchs:
        if branch in exclude:
            continue
        bs.add(branch)
    # echo(fmt"{bs}, {curBranch}")
    echo("please confirm commit branches (yes/no):")
    for b in bs:
        echo(fmt"* {b}")
    let isTrue = readLine(stdin)
    try:
        os.setCurrentDir(currentDir)
    except OSError:
        echo("cd current error")
        return (bs, curBranch, false)
    if isTrue.toLowerAscii() == "yes":
        return (bs, curBranch, true)
    return (bs, curBranch, false)
