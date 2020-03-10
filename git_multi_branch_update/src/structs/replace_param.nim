type
    ReplaceParam* = object
        src*: string
        dst*: string

proc newReplaceParam*(src: string, dst: string): ReplaceParam =
    result = ReplaceParam(
        src: src,
        dst: dst
    )
