#Requires AutoHotkey v2
#SingleInstance Force

; --- Variables ---
LogFile := A_ScriptDir "\AppHistory.txt"
CurrentApp := ""
StartTick := 0
StartTime := ""

; --- Timer to check active window every 5 seconds ---
SetTimer CheckActiveWindow, 5000

CheckActiveWindow() {
    global CurrentApp, StartTick, StartTime, LogFile

    ActiveTitle := WinGetTitle("A")
    ActiveClass := WinGetClass("A")
    AppName := ActiveTitle " (" ActiveClass ")"

    nowTick := A_TickCount
    nowTime := A_Now  ; current datetime string YYYYMMDDHH24MISS

    ; If app changed, log previous app
    if (AppName != CurrentApp) {
        if (CurrentApp != "") {
            Duration := (nowTick - StartTick) / 1000 / 60  ; convert ms → minutes
            Duration := Round(Duration, 1)
            FileAppend(Format("{} - Started at {} - Estimated usage: {} minutes`n", CurrentApp, StartTime, Duration), LogFile)
        }
        CurrentApp := AppName
        StartTick := nowTick
        StartTime := nowTime
    }
}

; --- Exit hotkey ---
^Esc::ExitApp
