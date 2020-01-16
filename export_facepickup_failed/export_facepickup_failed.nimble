# Package

version       = "0.1.0"
author        = "MwlLj"
description   = "A new awesome nimble package"
license       = "MIT"
srcDir        = "src"
bin           = @["export_facepickup_failed"]



# Dependencies

requires "nim >= 0.20.2"

requires "https://github.com/MwlLj/nim-parse >= 0.1.0"
# requires "https://github.com/status-im/nim-json-serialization"

import strformat
task run, "Run":
    var target = "target"
    var name = bin[0]
    mkdir target
    echo("build start")
    exec "nimble build"
    echo("build finish")
    when defined(windows):
        name.add(".exe")
    target.add("/")
    target.add(name)
    try:
        cpFile(name, target)
        rmFile(name)
        when defined(linux):
            exec(fmt"chmod +x {target}")
        echo("***start exec***")
        exec(fmt"{target} -root target/cbb")
        echo("***exec end***")
    except:
        echo("unknow except")

task clear, "Clear":
    rmDir("target")
