import "../parse/cmd_split"

import strformat

type
    ReplaceParam* = object
        src*: string
        dst*: string
        filter*: seq[string]
        exclude*: seq[string]
        log*: string
        files*: seq[string]

proc newReplaceParam*(src: string, dst: string, filter: string, exclude: string, log: string, files: string): ReplaceParam =
    let f = cmd_split.split(',', filter)
    let e = cmd_split.split(',', exclude)
    let fs = cmd_split.split(',', files)
    # echo(fmt"{f}, {e}, {fs}")
    result = ReplaceParam(
        src: src,
        dst: dst,
        filter: f,
        exclude: e,
        log: log,
        files: fs
    )
