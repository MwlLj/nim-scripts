import "delete_arm_64_lib/delete" as arm64lib_delete
import "delete_by_regex/delete" as byregex_delete

import "cmd/go_style"

proc main() =
    var cmdHandler = go_style.newCmd()
    let mode = cmdHandler.registerWithDesc("-mode", "delete-arm-64-lib", "select feature")
    let root = cmdHandler.registerWithDesc("-root", ".", "root")
    let match = cmdHandler.registerWithDesc("-match", "", "regex rule")
    cmdHandler.parse()
    case mode[]
    of "delete-arm-64-lib":
        arm64lib_delete.delete(root[])
    of "delete-by-regex":
        if match[] == "":
            echo("match is empty")
            return
        byregex_delete.delete(root[], match[])

when isMainModule:
    main()
