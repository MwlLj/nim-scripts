import "./mdparse/token"
import "./generate/sql"

import "cmd/go_style"

proc main() =
    var cmdHandler = go_style.newCmd()
    let mode = cmdHandler.registerWithDesc("-mode", "", "mode, gen-sql ...")
    let src = cmdHandler.registerWithDesc("-src", "", "src")
    let dst = cmdHandler.registerWithDesc("-dst", "", "dst")
    cmdHandler.parse()

    let stream = readFile(src[])
    var content: string
    case mode[]
    of "gen-sql":
        var t = token.newTokenParse(stream)
        let tokens = t.parse()
        # echo(tokens)
        var g = sql.newGenSql(tokens)
        content = g.parse()
    else:
        echo("please input mode, example: gen-sql ...")
        return
    writeFile(dst[], content)

when isMainModule:
    main()
