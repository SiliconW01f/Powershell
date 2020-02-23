Function Start-Countdown 
{
    Param(
        [Int32]$Seconds = 1,
        [string]$Message = "Message Here"
    )

    $tsTotal =  [timespan]::fromseconds(($Seconds - $Seconds))
    $Total = ("{0:hh\:mm\:ss}" -f $tsCount)

    ForEach ($Count in (1..$Seconds))
    {
        $tsCount =  [timespan]::fromseconds(($Seconds - $Count))
        $Remaining = ("{0:hh\:mm\:ss}" -f $tsCount)
        Write-Progress -Id 1 -Activity $Message -Status "$Remaining Remaining" -PercentComplete (($Count / $Seconds) * 100)
        Start-Sleep -Seconds 1
    }

    Write-Progress -Id 1 -Activity $Message -Status "Completed" -PercentComplete 100 -Completed
}

Function Start-Work 
{
    Add-Type -AssemblyName "System.Speech"
    $Speech = New-Object System.Speech.Synthesis.SpeechSynthesizer
    $WorkSession = $WorkCount + 1
    $Speech.Speak("Work Time Session $WorkSession, $Work Minutes, Starting Now")
    Start-Countdown -Seconds ($Work * 60) -Message "Work Time - Session $WorkSession"
}

Function Start-Break 
{   
    Add-Type -AssemblyName "System.Speech"
    $Speech = New-Object System.Speech.Synthesis.SpeechSynthesizer
    $Speech.Speak("Break Time, $Break Minutes, Starting Now")
    Start-Countdown -Seconds ($Break * 60) -Message "Break Time"
}

Function Start-BigBreak 
{      
    Add-Type -AssemblyName "System.Speech"
    $Speech = New-Object System.Speech.Synthesis.SpeechSynthesizer   
    $Speech.Speak("Big Break Time, $BigBreak Minutes, Starting Now")
    Start-Countdown -Seconds ($BigBreak * 60) -Message "Big Break Time"   
}

function Start-Pomodoro
{
    Param
    (
        [Parameter(Mandatory=$false)][single]$Work = "25",
        [Parameter(Mandatory=$false)][single]$Break = "5",
        [Parameter(Mandatory=$false)][single]$BigBreak = "15",
        [Parameter(Mandatory=$false)][int32]$WorkPeriods = "4"
    )

    Clear-Host

    if ($Work -le 0) {Write-Error -Message "Work time variable is =< 0" -ErrorAction Stop}
    if ($Break -le 0) {Write-Error -Message "Break time variable is =<0" -ErrorAction Stop}
    if ($BigBreak -le 0) {Write-Error -Message "Big break time variable is =< 0" -ErrorAction Stop}
    if ($WorkPeriods -le 0) {Write-Error -Message "Work periods variable is =< 0" -ErrorAction Stop}

    $WorkCount = 0

    while ($true) 
    {
        Start-Work 
        $WorkCount += 1
        if ($WorkCount -eq [math]::Round($WorkPeriods))
        {
            Start-BigBreak
            $WorkCount = 0
        }
        else
        {
            Start-Break
        }
    }
}
