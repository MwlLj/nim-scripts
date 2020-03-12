# Package

version       = "0.1.0"
author        = "MwlLj"
description   = "A new awesome nimble package"
license       = "MIT"
srcDir        = "src"
bin           = @["git_multi_branch_update"]



# Dependencies

requires "nim >= 0.20.2"

requires "https://github.com/MwlLj/nim-parse#191e503"

import strformat
task run, "Run":
    var target = "target"
    let t = target
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
        cd t
        echo("***start exec***")
        exec(fmt"{name} -dst dst -src src -filter master -exclude alpha,v1.7 -log update_test")
        # exec(fmt"{name} -dst dst -src src -filter master")
        echo("***exec end***")
    except:
        echo("unknow except")

task b, "Build":
    var target = "target"
    let t = target
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
    except:
        echo("unknow except")

task clear, "Clear":
    rmDir("target")
