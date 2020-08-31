# 查找所有的 PID
import osproc
import strformat
import strutils

proc get_pid(cmd_ret: string): int =
    var index = 0
    # owner
    for c in cmd_ret:
        if c == ' ':
            break
        index += 1
    # owner 和 pid 之间的空格
    var length = len(cmd_ret)
    for i in index..length:
        var c = cmd_ret[i]
        if c != ' ':
            break
        index += 1
    var word = ""
    for i in index..length:
        var c = cmd_ret[i]
        if c == ' ':
            break
        else:
            word.add(c)
        index += 1
    return word.parseInt()

proc find_pids*(name: string): seq[int] =
    var pids = newSeq[int]()
    var exeResult = osproc.execCmdEx(fmt"ps -aux | grep {name}")
    if exeResult[1] != 0:
         #[
          # 命令执行失败
          ]#
         return pids
    #[
     # 命令执行成功
     ]#
    var results = exeResult[0].split("\n")
    for r in results:
        if len(r) == 0:
            continue
        var pid = get_pid(r)
        pids.add(pid)
        # echo(pid)
        # echo(r)
    return pids
