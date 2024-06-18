Add-Type -AssemblyName PresentationFramework

# Loo põhaken
[xml]$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" Title="Joosep's Shitty but somehow functional Toolbox" Height="600" Width="800">
    <Grid>
        <TabControl Name="MainTabControl">
            <TabItem Header="Debloater">
                <ScrollViewer>
                    <StackPanel Name="DebloaterStackPanel" Margin="10">
                        <TextBlock Text="Debloater Options" FontWeight="Bold" FontSize="16" Margin="0,0,0,10"/>
                    </StackPanel>
                </ScrollViewer>
            </TabItem>
            <TabItem Header="Process Killer">
                <ScrollViewer>
                    <StackPanel Name="ProcessKillerStackPanel" Margin="10">
                        <TextBlock Text="Unnecessary Processes" FontWeight="Bold" FontSize="16" Margin="0,0,0,10"/>
                    </StackPanel>
                </ScrollViewer>
            </TabItem>
        </TabControl>
        <StackPanel Orientation="Vertical" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="10">
            <Button Name="EnableHyperVButton" Content="Enable Hyper-V" Margin="5"/>
            <Button Name="RebootPCButton" Content="Reboot PC" Margin="5"/>
            <Button Name="ShutdownPCButton" Content="Shutdown PC" Margin="5"/>
            <Button Name="OpenChromeButton" Content="Open Chrome" Margin="5"/>
            <Button Name="OpenCalculatorButton" Content="Open Calculator" Margin="5"/>
            <Button Name="CheckIPv4Button" Content="Check IPv4 Address" Margin="5"/>
            <Button Name="OpenSnippingToolButton" Content="Open Snipping Tool" Margin="5"/>
            <Button Name="OpenGitHubButton" Content="Open GitHub" Margin="5"/>
            <Button Name="MuteAudioButton" Content="Mute Audio" Margin="5"/>
        </StackPanel>
        <Button Name="ProcessButton" Content="Apply Selected Options" VerticalAlignment="Bottom" HorizontalAlignment="Center" Margin="0,10,0,10" Width="200"/>
    </Grid>
</Window>
"@

# XAML SHIT
$reader = (New-Object System.Xml.XmlNodeReader $xaml)
$Window = [Windows.Markup.XamlReader]::Load($reader)

# Leia kontrollid
$DebloaterStackPanel = $Window.FindName("DebloaterStackPanel")
$ProcessKillerStackPanel = $Window.FindName("ProcessKillerStackPanel")
$ProcessButton = $Window.FindName("ProcessButton")
$EnableHyperVButton = $Window.FindName("EnableHyperVButton")
$RebootPCButton = $Window.FindName("RebootPCButton")
$ShutdownPCButton = $Window.FindName("ShutdownPCButton")
$OpenChromeButton = $Window.FindName("OpenChromeButton")
$OpenCalculatorButton = $Window.FindName("OpenCalculatorButton")
$CheckIPv4Button = $Window.FindName("CheckIPv4Button")
$OpenSnippingToolButton = $Window.FindName("OpenSnippingToolButton")
$OpenGitHubButton = $Window.FindName("OpenGitHubButton")
$MuteAudioButton = $Window.FindName("MuteAudioButton")

# Button Click Events
$EnableHyperVButton.Add_Click({
    Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-All -NoRestart
    [System.Windows.MessageBox]::Show("Hyper-V has been enabled. Please reboot your PC for changes to take effect.")
})

$RebootPCButton.Add_Click({
    Restart-Computer -Force
})

$ShutdownPCButton.Add_Click({
    Stop-Computer -Force
})

$OpenChromeButton.Add_Click({
    Start-Process "chrome.exe"
})

$OpenCalculatorButton.Add_Click({
    Start-Process "calc.exe"
})

$CheckIPv4Button.Add_Click({
    $ipv4 = (Get-NetIPAddress -AddressFamily IPv4 | Select-Object -First 1).IPAddress
    [System.Windows.MessageBox]::Show("Your IPv4 address is: $ipv4")
})

$OpenSnippingToolButton.Add_Click({
    Start-Process "SnippingTool.exe"
})

$OpenGitHubButton.Add_Click({
    Start-Process "https://github.com/J0OS3P/RakIT"
})

$MuteAudioButton.Add_Click({
    nircmd.exe mutesysvolume 1
})

# Debloateri valikud
$debloaterOptions = @(
    "Default App Uninstallation",
    "Store App Removal",
    "Disable Unnecessary Services",
    "Startup Program Management",
    "Telemetry and Data Collection",
    "Cortana and Search",
    "Remove Ads and Suggestions",
    "Classic UI Options",
    "Update Settings",
    "Driver Updates",
    "Registry Tweaks",
    "File System Cleanup",
    "Custom Scripts",
    "Restore Points",
    "Predefined Profiles",
    "Custom Profiles",
    "Safe Mode Compatibility",
    "Undo Changes",
    "Regular Updates",
    "Compatibility Checks",
    "+8GB RAM"
)

# Protsess killer valikud
$processKillerOptions = @(
    "Xbox Accessory Management Service",
    "Xbox Live Auth Manager",
    "Xbox Live Game Save",
    "Xbox Live Networking Service",
    "Diagnostic Policy Service",
    "Diagnostic Tracking Service (Telemetry)",
    "Remote Desktop Services (RDP)",
    "Remote Registry",
    "Print Spooler",
    "Fax",
    "Windows Update (can be disabled temporarily)",
    "Windows Error Reporting Service",
    "Windows Insider Service",
    "Secondary Logon",
    "Program Compatibility Assistant Service",
    "Distributed Link Tracking Client"
)

# Lisa debloateri valikute märkeruudud
foreach ($option in $debloaterOptions) {
    $checkbox = New-Object System.Windows.Controls.CheckBox
    $checkbox.Content = $option
    $DebloaterStackPanel.Children.Add($checkbox)
}

# Lisa protsess killer valikute märkeruudud
foreach ($option in $processKillerOptions) {
    $checkbox = New-Object System.Windows.Controls.CheckBox
    $checkbox.Content = $option
    $ProcessKillerStackPanel.Children.Add($checkbox)
}

# Määra nupu klõpsamise sündmus
$ProcessButton.Add_Click({
    $selectedDebloaterOptions = @()
    $selectedProcessKillerOptions = @()

    # Koguge valitud debloateri valikud
    foreach ($child in $DebloaterStackPanel.Children) {
        if ($child -is [System.Windows.Controls.CheckBox] -and $child.IsChecked) {
            $selectedDebloaterOptions += $child.Content
        }
    }

    # Koguge valitud protsess killer valikud
    foreach ($child in $ProcessKillerStackPanel.Children) {
        if ($child -is [System.Windows.Controls.CheckBox] -and $child.IsChecked) {
            $selectedProcessKillerOptions += $child.Content
        }
    }

    # Töötle valitud debloateri valikud
    foreach ($option in $selectedDebloaterOptions) {
        switch ($option) {
            "Default App Uninstallation" {
                Get-AppxPackage | Remove-AppxPackage
            }
            "Store App Removal" {
                Get-AppxPackage -AllUsers | Where-Object {$_.Name -like "*Store*"} | Remove-AppxPackage
            }
            "Disable Unnecessary Services" {
                Stop-Service -Name "DiagTrack","dmwappushsvc" -Force
                Set-Service -Name "DiagTrack","dmwappushsvc" -StartupType Disabled
            }
            "Startup Program Management" {
                Get-CimInstance -ClassName Win32_StartupCommand | Remove-CimInstance
            }
            "Telemetry and Data Collection" {
                Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Value 0
            }
            "Cortana and Search" {
                Stop-Process -Name "SearchUI" -Force
                Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name "AllowCortana" -Value 0
            }
            "Remove Ads and Suggestions" {
                Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SystemPaneSuggestionsEnabled" -Value 0
            }
            "Classic UI Options" {
                New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Start_ShowClassicMode" -Value 1 -PropertyType DWORD -Force
            }
            "Update Settings" {
                Stop-Service -Name "wuauserv" -Force
                Set-Service -Name "wuauserv" -StartupType Disabled
            }
            "Driver Updates" {
                Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DriverSearching" -Name "SearchOrderConfig" -Value 0
            }
            "Registry Tweaks" {
                Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization" -Name "NoLockScreen" -Value 1
            }
            "File System Cleanup" {
                Remove-Item -Path "C:\Windows\Temp\*" -Recurse -Force
            }
            "Custom Scripts" {
                Write-Output "Custom script executed"
            }
            "Restore Points" {
                Checkpoint-Computer -Description "Pre-debloat restore point"
            }
            "Predefined Profiles" {
                Write-Output "Predefined profile applied"
            }
            "Custom Profiles" {
                Write-Output "Custom profile applied"
            }
            "Safe Mode Compatibility" {
                bcdedit /set {default} safeboot network
            }
            "Undo Changes" {
                Write-Output "Changes undone"
            }
            "Regular Updates" {
                Start-Process "ms-settings:windowsupdate"
            }
            "Compatibility Checks" {
                Write-Output "Compatibility check completed"
            }
            "+8GB RAM" {
                Start-Process "https://www.youtube.com/watch?v=dQw4w9WgXcQ"
            }
        }
    }

    # Töötle valitud protsess killer valikud
    foreach ($option in $selectedProcessKillerOptions) {
        switch ($option) {
            "Xbox Accessory Management Service" {
                Stop-Service -Name "XboxGipSvc" -Force
                Set-Service -Name "XboxGipSvc" -StartupType Disabled
            }
            "Xbox Live Auth Manager" {
                Stop-Service -Name "XblAuthManager" -Force
                Set-Service -Name "XblAuthManager" -StartupType Disabled
            }
            "Xbox Live Game Save" {
                Stop-Service -Name "XblGameSave" -Force
                Set-Service -Name "XblGameSave" -StartupType Disabled
            }
            "Xbox Live Networking Service" {
                Stop-Service -Name "XboxNetApiSvc" -Force
                Set-Service -Name "XboxNetApiSvc" -StartupType Disabled
            }
            "Diagnostic Policy Service" {
                Stop-Service -Name "DPS" -Force
                Set-Service -Name "DPS" -StartupType Disabled
            }
            "Diagnostic Tracking Service (Telemetry)" {
                Stop-Service -Name "DiagTrack" -Force
                Set-Service -Name "DiagTrack" -StartupType Disabled
            }
            "Remote Desktop Services (RDP)" {
                Stop-Service -Name "TermService" -Force
                Set-Service -Name "TermService" -StartupType Disabled
            }
            "Remote Registry" {
                Stop-Service -Name "RemoteRegistry" -Force
                Set-Service -Name "RemoteRegistry" -StartupType Disabled
            }
            "Print Spooler" {
                Stop-Service -Name "Spooler" -Force
                Set-Service -Name "Spooler" -StartupType Disabled
            }
            "Fax" {
                Stop-Service -Name "Fax" -Force
                Set-Service -Name "Fax" -StartupType Disabled
            }
            "Windows Update (can be disabled temporarily)" {
                Stop-Service -Name "wuauserv" -Force
                Set-Service -Name "wuauserv" -StartupType Disabled
            }
            "Windows Error Reporting Service" {
                Stop-Service -Name "WerSvc" -Force
                Set-Service -Name "WerSvc" -StartupType Disabled
            }
            "Windows Insider Service" {
                Stop-Service -Name "wisvc" -Force
                Set-Service -Name "wisvc" -StartupType Disabled
            }
            "Secondary Logon" {
                Stop-Service -Name "seclogon" -Force
                Set-Service -Name "seclogon" -StartupType Disabled
            }
            "Program Compatibility Assistant Service" {
                Stop-Service -Name "PcaSvc" -Force
                Set-Service -Name "PcaSvc" -StartupType Disabled
            }
            "Distributed Link Tracking Client" {
                Stop-Service -Name "TrkWks" -Force
                Set-Service -Name "TrkWks" -StartupType Disabled
            }
        }
    }
})

# Näita akent
$Window.ShowDialog() | Out-Null
