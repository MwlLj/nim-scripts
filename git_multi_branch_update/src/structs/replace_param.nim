import "../parse/cmd_split"

type
    ReplaceParam* = object
        src*: string
        dst*: string
        filter*: seq[string]
        exclude*: seq[string]
        log*: string

proc newReplaceParam*(src: string, dst: string, filter: string, exclude: string, log: string): ReplaceParam =
    let f = cmd_split.split(',', filter)
    let e = cmd_split.split(',', exclude)
    result = ReplaceParam(
        src: src,
        dst: dst,
        filter: f,
        exclude: e,
        log: log
    )
