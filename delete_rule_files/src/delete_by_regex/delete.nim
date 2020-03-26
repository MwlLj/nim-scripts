import "path/vertical_walk" as walk

import os
import re
import strformat

proc delete*(root: string, match: string) =
    #[ 
    ## 遍历目录
    ]#
    proc iter(parent: string, name: string, path: string): walk.CbResult =
        let (dir, parentName, ext) = os.splitFile(parent)
        if name.contains(re(fmt"{match}")):
            os.removeFile(path)
        return walk.CbResult.Continue
    walk.walk(root, iter)
