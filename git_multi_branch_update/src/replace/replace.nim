import "../structs/replace_param"
import "../parse/git_branch"

import os
import osproc
import strformat

proc changeDst(dst: string): tuple[curDir: string, ok: bool] =
    var currentDir: string
    try:
        currentDir = os.getCurrentDir()
    except OSError:
        echo("get current dir error")
        return (currentDir, false) 
    try:
        os.setCurrentDir(dst)
    except OSError:
        echo("set dst error")
        return (currentDir, false) 
    return (currentDir, true)

proc changeBackDst(curDir: string): bool =
    try:
        os.setCurrentDir(curDir)
    except OSError:
        echo("change back dst error")
        return false
    return true

proc commit(dst: string, branch: string, log: string): bool =
    let r = changeDst(dst)
    if not r[1]:
        return false
    var code: int
    code = osproc.execCmd("git add *")
    if code != 0:
        echo(fmt"exe git add error, code: {code}")
    code = osproc.execCmd(fmt"""git commit -m "{log}"""")
    if code != 0:
        echo(fmt"exe git commit error, code: {code}")
    code = osproc.execCmd(fmt"git push origin {branch}")
    if code != 0:
        echo(fmt"exe git push error, code: {code}")
        return false
    if not changeBackDst(r[0]):
        return false
    return true

proc replace*(param: replace_param.ReplaceParam) =
    let branchs = git_branch.getGitBranchs(param.dst, param.filter, param.exclude)
    if branchs[1] == false:
        return
    let bs = branchs[0]
    var curBranch: string
    for (isCur, b) in bs:
        if isCur:
            curBranch = b
        let o = changeDst(param.dst)
        if not o[1]:
            continue
        # 切换分支
        var code: int
        # echo(fmt"git checkout {b}")
        code = osproc.execCmd(fmt"git checkout {b}")
        if code != 0:
            echo(fmt"exec git checkout error, code: {code}")
        # 拉取代码
        # echo("git pull")
        code = osproc.execCmd("git pull")
        if code != 0:
            echo(fmt"exec git pull error, code: {code}")
        # 切回原来的目录
        if not changeBackDst(o[0]):
            continue
        # 拷贝文件
        try:
            os.copyDir(param.src, param.dst)
        except OSError:
            echo(fmt"copy dir error, src: {param.src}, dst: {param.dst}")
        # 提交
        discard commit(param.dst, b, param.log)
    if bs.len() > 1:
        # 如果 bs.len() == 0 => 说明不需要切换回原来的分支
        # let code = osproc.execCmd(fmt"git checkout {curBranch}")
        echo(fmt"git checkout {curBranch}")
