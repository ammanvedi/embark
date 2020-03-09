import terminal

const COLOR_INFO = fgYellow
const COLOR_ERROR = fgRed
const COLOR_SUCCESS = fgGreen
const COLOR_GENERAL = fgWhite
const COLOR_STATUS = fgMagenta

proc logInfo*(
    message: string,
    newLine: bool,
    eraseCurrentLine: bool ) =
    if eraseCurrentLine:
        eraseLine()
    setForegroundColor(COLOR_INFO)
    writeStyled("INFO: ",{styleBright})
    setForegroundColor(COLOR_GENERAL)
    writeStyled(message,{})
    if newLine:
        writeStyled("\n", {})

proc logError*(
    message: string,
    newLine: bool,
    eraseCurrentLine: bool ) =
    if eraseCurrentLine:
        eraseLine()
    setForegroundColor(COLOR_ERROR)
    writeStyled("ERR:  ",{styleBright})
    setForegroundColor(COLOR_GENERAL)
    writeStyled(message,{})
    if newLine:
        writeStyled("\n", {})

proc logSuccess*(
    message: string,
    newLine: bool, 
    eraseCurrentLine: bool ) =
    if eraseCurrentLine:
        eraseLine()
    setForegroundColor(COLOR_SUCCESS)
    writeStyled("SUCC: ",{styleBright})
    setForegroundColor(COLOR_GENERAL)
    writeStyled(message,{})
    if newLine:
        writeStyled("\n", {})

proc logStatus*(
    message: string,
    newLine: bool, 
    eraseCurrentLine: bool ) =
    if eraseCurrentLine:
        eraseLine()
    setForegroundColor(COLOR_STATUS)
    writeStyled("STAT: ",{styleBright})
    setForegroundColor(COLOR_GENERAL)
    writeStyled(message,{})
    if newLine:
        writeStyled("\n", {})