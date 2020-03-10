#[
## 替换 command 中的变量
]#
type
    Mode = enum
        normal, variant

const var_name: string = "name"

proc replace*(command: string, name: string): string =
    result = ""
    var world = ""
    var mode = Mode.normal
    for c in command:
        case mode
        of Mode.normal:
            if c == '{':
                mode = Mode.variant
            else:
                result.add(c)
        of Mode.variant:
            if c == '}':
                if world == var_name:
                    result.add(name)
                mode = Mode.normal
                world = ""
            else:
                world.add(c)
