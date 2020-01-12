import "delete_arm_64_lib/delete"

import "cmd/go_style"

proc main() =
    var cmdHandler = go_style.newCmd()
    let mode = cmdHandler.registerWithDesc("-mode", "delete-arm-64-lib", "select feature")
    let root = cmdHandler.registerWithDesc("-root", ".", "root")
    cmdHandler.parse()
    case mode[]
    of "delete-arm-64-lib":
        delete.delete(root[])

when isMainModule:
    main()
