import "../parse/cmd_split"

type
    ReplaceParam* = object
        src*: string
        dst*: string
        filter*: seq[string]
        log*: string

proc newReplaceParam*(src: string, dst: string, filter: string, log: string): ReplaceParam =
    let f = cmd_split.split(',', filter)
    result = ReplaceParam(
        src: src,
        dst: dst,
        filter: f,
        log: log
    )
