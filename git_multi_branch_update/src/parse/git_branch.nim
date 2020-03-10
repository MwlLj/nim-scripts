import osproc
import strutils

proc deletePrefix(s: var string) =
    var last = 0
    for c in s:
        if c == ' ' or c == '*':
            last += 1
        else:
            break
    s.delete(0, last - 1)

proc getGitBranchs*(path: string): tuple[bs: seq[string], ok: bool] =
    var bs = newSeq[string]()
    let r = osproc.execCmdEx("git branch")
    if r[1] != 0:
        return (bs, false)
    let branchs = strutils.splitLines(r[0])
    for branch in branchs:
        if branch.len() > 0:
            var b = string(branch)
            b.deletePrefix()
            bs.add(b)
    return (bs, true)
