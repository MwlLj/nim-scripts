import "../mdparse/token"
import options

type
    GenSql = object
        tokens: seq[token.Token]
        length: int
        index: int
        content: string

proc lookupNextN(self: GenSql, n: int): Option[token.Token]
proc lookupNextOne(self: GenSql): Option[token.Token]
proc takeNextN(self: var GenSql, n: int): Option[token.Token]
proc takeNextOne(self: var GenSql): Option[token.Token]
proc skipNextOne(self: var GenSql)

proc handleThreeBackticks(self: var GenSql)

proc parse*(self: var GenSql): string =
    while true:
        let v = self.takeNextOne()
        if v.isNone():
            break
        case v.get().tokenType
        of token.TokenType.ThreeBackticks:
            self.handleThreeBackticks()
        else:
            discard
    result = self.content

proc handleThreeBackticks(self: var GenSql) =
    # 查找下一个是否是 id == "sql"
    let v = self.lookupNextOne()
    if v.isNone():
        return
    case v.get().tokenType
    of token.TokenType.Id:
        if v.get().value == "sql":
            self.skipNextOne()
            let v = self.lookupNextOne()
            if v.isNone():
                return
            case v.get().tokenType
            of token.TokenType.StringBlock:
                self.content.add(v.get().value)
                self.content.add("\n")
            else:
                discard
    else:
        discard

proc lookupNextN(self: GenSql, n: int): Option[token.Token] =
    let index = self.index + n
    if index > self.length - 1:
        return none(token.Token)
    return some(self.tokens[index])

proc lookupNextOne(self: GenSql): Option[token.Token] =
    return self.lookupNextN(1)

proc takeNextN(self: var GenSql, n: int): Option[token.Token] =
    result = self.lookupNextN(n)
    if result.isNone():
        return
    self.index += 1

proc takeNextOne(self: var GenSql): Option[token.Token] =
    return self.takeNextN(1)

proc skipNextOne(self: var GenSql) =
    self.index += 1

proc newGenSql*(tokens: seq[token.Token]): GenSql =
    let grammar = GenSql(
        tokens: tokens,
        length: tokens.len(),
        index: 0
    )
    return grammar
