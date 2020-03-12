import "../path/change"

import strformat

proc handleFile(f: string): bool =
    for c in f:
        if c == '[' or c == ']' or c == '!':
            discard

proc joinFiles*(cmd: var string, src: string, files: seq[string]): bool =
    for f in files:
        cmd.add(fmt" {f}")
    return true

