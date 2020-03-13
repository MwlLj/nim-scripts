import "../structs/replace_param"
import "../parse/git_branch"
import "../parse/git_files_join"
import "../path/change"

import os
import osproc
import strformat

proc commit(src: string, dst: string, branch: string, log: string, files: seq[string]): bool =
    var fs: string = "git add "
    if not fs.joinFiles(src, files):
        return false
    let r = change.changeDir(dst)
    if not r[1]:
        return false
    var code: int
    # echo(fs)
    code = osproc.execCmd(fs)
    if code != 0:
        echo(fmt"exe git add error, code: {code}")
    code = osproc.execCmd(fmt"""git commit -m "{log}"""")
    if code != 0:
        echo(fmt"exe git commit error, code: {code}")
    code = osproc.execCmd(fmt"git push origin {branch}")
    if code != 0:
        echo(fmt"exe git push error, code: {code}")
        return false
    if not change.changeBackDir(r[0]):
        return false
    return true

proc replace*(param: replace_param.ReplaceParam) =
    let branchs = git_branch.getGitBranchs(param.dst, param.filter, param.exclude)
    if branchs.ok == false:
        return
    let bs = branchs.bs
    var curBranch = branchs.curBranch
    for b in bs:
        let o = change.changeDir(param.dst)
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
        if not change.changeBackDir(o[0]):
            continue
        # 拷贝文件
        try:
            os.copyDir(param.src, param.dst)
        except OSError:
            echo(fmt"copy dir error, src: {param.src}, dst: {param.dst}")
        # 提交
        discard commit(param.src, param.dst, b, param.log, param.files)
    if bs.len() > 1:
        # 如果 bs.len() == 0 => 说明不需要切换回原来的分支
        # let code = osproc.execCmd(fmt"git checkout {curBranch}")
        echo(fmt"git checkout {curBranch}")
