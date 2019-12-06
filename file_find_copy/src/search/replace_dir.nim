import os

proc replace*(src: string, root: string) =
    #[
    ## 遍历目录
    ]#
    for path in os.walkDirRec(root, yieldFilter={pcDir}):
        echo(path)
