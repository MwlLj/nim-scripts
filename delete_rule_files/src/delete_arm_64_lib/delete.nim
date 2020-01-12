import "path/vertical_walk" as walk

import os
import re

proc delete*(root: string) =
    #[ 
    ## 遍历目录
    ]#
    proc iter(parent: string, name: string, path: string): walk.CbResult =
        let (dir, parentName, ext) = os.splitFile(parent)
        if parentName == "arm-none-linux-gnueabi-gcc_general":
            if name.contains(re"64"):
                os.removeFile(path)
        return walk.CbResult.Continue
    walk.walk(root, iter)
