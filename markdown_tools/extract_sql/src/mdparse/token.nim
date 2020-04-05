type
    TokenType* = enum
        ThreeBackticks,
        Id,
        StringBlock

type
    Token* = object
        tokenType*: TokenType
        value*: string

type
    TokenParse* = object
        stream: string
        length: int
        index: int
        tokens: seq[Token]

proc lookupNextOne(self: TokenParse): tuple[c: char, ok: bool]
proc lookupNextN(self: TokenParse, n: int): tuple[c: char, ok: bool]
proc takeNextOne(self: var TokenParse): tuple[c: char, ok: bool]
proc takeNextN(self: var TokenParse, n: int): tuple[c: char, ok: bool]
proc skipNextOne(self: var TokenParse)
proc handleBackticks(self: var TokenParse)
proc handleVar(self: var TokenParse, c: char)
proc handleN(self: var TokenParse)
proc handleR(self: var TokenParse)
proc findEndThirdBackticks(self: var TokenParse, stringBlock: var string)

proc isVar(self: TokenParse, c: char): bool
proc isNumber(self: TokenParse, c: char): bool

proc parse*(self: var TokenParse): seq[Token] =
    while true:
        let v = self.takeNextOne()
        if not v.ok:
            break
        if v.c == '`':
            self.handleBackticks()
        elif v.c == '#':
            discard
        elif self.isVar(v.c):
            self.handleVar(v.c)
        elif v.c == '\r':
            self.handleR()
        elif v.c == '\n':
            self.handleN()
        else:
            discard
    return self.tokens

proc handleVar(self: var TokenParse, c: char) =
    var id: string
    id.add(c)
    while true:
        let v = self.lookupNextOne()
        if not v.ok:
            return
        if self.isVar(v.c) or self.isNumber(v.c):
            id.add(v.c)
            self.skipNextOne()
        else:
            break
    self.tokens.add(Token(
        tokenType: TokenType.Id,
        value: id
    ))

proc handleBackticks(self: var TokenParse) =
    # 查看下一个字符是否是 `
    let v = self.lookupNextOne()
    if not v.ok:
        return
    if v.c == '`':
        self.skipNextOne()
        let v = self.lookupNextOne()
        if v.c == '`':
            self.skipNextOne()
            self.tokens.add(Token(
                tokenType: TokenType.ThreeBackticks,
            ))
            # 寻找 ```后面的单词
            let v = self.lookupNextOne()
            if not v.ok:
                return
            if v.c == '\r':
                self.handleR()
            elif v.c == '\n':
                self.handleN()
            elif self.isVar(v.c):
                self.skipNextOne()
                self.handleVar(v.c)
                let v = self.lookupNextOne()
                if not v.ok:
                    return
                if v.c == '\r':
                    self.handleR()
                elif v.c == '\n':
                    self.handleN()
            # 寻找连续三个 反引号
            var stringBlock: string
            self.findEndThirdBackticks(stringBlock)
            return
    return

proc handleN(self: var TokenParse) =
    self.skipNextOne()

proc handleR(self: var TokenParse) =
    self.skipNextOne()
    let v = self.lookupNextOne()
    if not v.ok:
        return
    if v.c == '\n':
        self.handleN()

proc findEndThirdBackticks(self: var TokenParse, stringBlock: var string) =
    while true:
        let v = self.takeNextOne()
        if not v.ok:
            return
        if v.c == '`':
            let v = self.lookupNextOne()
            if not v.ok:
                return
            if v.c == '`':
                self.skipNextOne()
                let v = self.lookupNextOne()
                if not v.ok:
                    return
                if v.c == '`':
                    # find ```
                    self.tokens.add(Token(
                        tokenType: TokenType.StringBlock,
                        value: stringBlock
                    ))
                    break
                else:
                    stringBlock.add(v.c)
            else:
                stringBlock.add(v.c)
        else:
            stringBlock.add(v.c)

proc lookupNextOne(self: TokenParse): tuple[c: char, ok: bool] =
    return self.lookupNextN(1)

proc lookupNextN(self: TokenParse, n: int): tuple[c: char, ok: bool] =
    let i = self.index + n
    if i > self.length - 1:
        return ((char)0, false)
    let c = self.stream[i]
    return (c, true)

proc takeNextOne(self: var TokenParse): tuple[c: char, ok: bool] =
    return self.takeNextN(1)

proc takeNextN(self: var TokenParse, n: int): tuple[c: char, ok: bool] =
    result = self.lookupNextN(n)
    if not result.ok:
        return
    self.index += 1

proc skipNextOne(self: var TokenParse) =
    self.index += 1

proc isVar(self: TokenParse, c: char): bool =
    if (c == '_') or (c >= 'a' and c <= 'z') or (c >= 'A' and c <= 'Z'):
        return true
    return false

proc isNumber(self: TokenParse, c: char): bool =
    if c >= '0' and c <= '9':
        return true
    return false

proc newTokenParse*(stream: string): TokenParse =
    let token = TokenParse(
        stream: stream,
        length: stream.len(),
        index: -1,
    )
    return token

proc newToken*(): Token =
    let t = Token()
    return t
