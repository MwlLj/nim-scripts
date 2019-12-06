#[
## 使用 ; 号 分割命令
]#
proc split*(command: string): seq[string] =
    var world = ""
    for c in command:
        if c == ';':
            result.add(world)
            world = ""
        else:
            world.add(c)
    result.add(world)
