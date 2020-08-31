import "ubuntu/kill"
import "cmd/go_style"

proc main() =
    var cmdHandler = go_style.newCmd()
    let name = cmdHandler.registerWithDesc("-name", "", "be killed name")
    cmdHandler.parse()
    kill.kill(name[])

when isMainModule:
    main()
