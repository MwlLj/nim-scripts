import "cmd/go_style"
import "export_picture/export" as ep
import "consts/error"

const
    modeExportPicture = "export-picture"

proc main() =
    var cmdHandler = go_style.newCmd()
    let mode = cmdHandler.registerWithDesc("-mode", "", "exp: export-picture")
    let targetDir = cmdHandler.registerWithDesc("-target-dir", "./target", "target dir")
    let dbPath = cmdHandler.registerWithDesc("-db-path", "", "db path")
    cmdHandler.parse()
    case mode[]
        of modeExportPicture:
            let e = ep.newExport(targetDir[], dbPath[])
            let code = e.exec()
            case code
            of error.Success:
                echo("success")
            of error.NotExistError:
                echo("notExistError")
                return
        else:
            echo("mode is not support")
            return

when isMainModule:
    main()
