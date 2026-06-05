function Get-AcerBatteryLimit {
    $inst = Get-WmiObject -Namespace root\WMI -Class BatteryControl

    $r = $inst.GetBatteryHealthControlStatus(
        [byte]1,
        [byte]1,
        [byte[]](0,0)
    )

    [PSCustomObject]@{
        HealthMode      = [bool]$r.uFunctionStatus[0]
        CalibrationMode = [bool]$r.uFunctionStatus[1]
        RawStatus       = $r.uFunctionStatus
        FunctionList    = $r.uFunctionList
    }
}

function Set-AcerBatteryLimit {
    param(
        [Parameter(Mandatory)]
        [bool]$Enabled
    )

    $inst = Get-WmiObject -Namespace root\WMI -Class BatteryControl

    $inst.SetBatteryHealthControl(
        [byte]1,                  # BatteryNo
        [byte]1,                  # HEALTH_MODE
        [byte]$Enabled,           # 1=on, 0=off
        [byte[]](0,0,0,0,0)
    ) | Out-Null

    Start-Sleep -Milliseconds 500

    Get-AcerBatteryLimit
}
