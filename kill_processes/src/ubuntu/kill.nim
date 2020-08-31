import osproc
import strformat
import "find_pids"

proc exec_kill(pid: int) =
    var ret = osproc.execCmdEx(fmt"sudo kill -9 {pid}")
    echo(fmt"exe result code: {ret[1]}")

proc kill*(name: string) =
    var pids = find_pids.find_pids(name)
    for pid in pids:
        # echo(pid)
        exec_kill(pid)
