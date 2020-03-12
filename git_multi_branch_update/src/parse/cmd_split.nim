#[
## 使用 输入的字符 分割命令
]#
proc split*(sc: char, command: string): seq[string] =
    var world = ""
    for c in command:
        if c == sc:
            result.add(world)
            world = ""
        else:
            world.add(c)
    if world.len() > 0:
        result.add(world)
