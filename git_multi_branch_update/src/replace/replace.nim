import "../structs/replace_param"
import "../parse/git_branch"

import os

proc replace*(param: replace_param.ReplaceParam) =
    try:
        os.setCurrentDir(param.dst)
    except OSError:
        echo("cd error, please make sure -dst is true")
        return
    let branchs = git_branch.getGitBranchs(param.dst)
    echo(branchs)
