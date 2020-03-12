import os

proc changeDir*(dir: string): tuple[curDir: string, ok: bool] =
    var currentDir: string
    try:
        currentDir = os.getCurrentDir()
    except OSError:
        echo("get current dir error")
        return (currentDir, false) 
    try:
        os.setCurrentDir(dir)
    except OSError:
        echo("set dir error")
        return (currentDir, false) 
    return (currentDir, true)

proc changeBackDir*(curDir: string): bool =
    try:
        os.setCurrentDir(curDir)
    except OSError:
        echo("change back dir error")
        return false
    return true

