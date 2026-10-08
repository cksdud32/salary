Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase

[xml]$xaml = @'
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="월급시계" Width="410" Height="304" MinWidth="340" MinHeight="304"
        WindowStyle="None" AllowsTransparency="True" Background="Transparent"
        Topmost="True" ResizeMode="CanResizeWithGrip" ShowInTaskbar="True">
  <Window.Resources>
    <Style TargetType="TextBlock"><Setter Property="Foreground" Value="#B8C0C5"/><Setter Property="Effect"><Setter.Value><DropShadowEffect Color="#000000" BlurRadius="3" ShadowDepth="0" Opacity="1"/></Setter.Value></Setter></Style>
  </Window.Resources>
  <Border CornerRadius="22" Background="#660B1014" BorderBrush="#8A4B5A64" BorderThickness="1" Padding="20">
    <Border.Effect><DropShadowEffect BlurRadius="28" ShadowDepth="7" Opacity="0.52" Color="#000000"/></Border.Effect>
    <Grid>
      <Grid.RowDefinitions><RowDefinition Height="Auto"/><RowDefinition Height="*"/><RowDefinition Height="Auto"/><RowDefinition Height="Auto"/><RowDefinition Height="Auto"/></Grid.RowDefinitions>
      <Border Grid.Row="0" Background="#99141B20" BorderBrush="#8834424B" BorderThickness="1" CornerRadius="11" Padding="9,7">
        <Grid Name="DragBar" Background="Transparent">
          <Grid.ColumnDefinitions><ColumnDefinition/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
          <StackPanel Orientation="Horizontal" VerticalAlignment="Center">
            <Border Width="29" Height="29" CornerRadius="9" Background="#102019" BorderBrush="#31503F" BorderThickness="1"><TextBlock Text="₩" Foreground="#6EE7A8" FontSize="17" FontWeight="Bold" HorizontalAlignment="Center" VerticalAlignment="Center"/></Border>
            <StackPanel Margin="10,0,0,0"><TextBlock Text="월급시계" FontSize="14" FontWeight="Bold" Foreground="#C7CDD0"/><TextBlock Name="StatusText" Text="계산 중" FontSize="11" Foreground="#AAB2B7" Margin="0,2,0,0"/></StackPanel>
          </StackPanel>
          <StackPanel Grid.Column="1" Orientation="Horizontal">
            <Button Name="SettingsButton" Content="⚙" Width="30" Height="30" Margin="0,0,5,0" FontSize="15" Foreground="#C7CDD0" Background="#B0171E24" BorderBrush="#4F5A62" Cursor="Hand" ToolTip="근무 설정"/>
            <Button Name="MinButton" Content="—" Width="30" Height="30" Margin="0,0,5,0" FontSize="14" Foreground="#C7CDD0" Background="#B0171E24" BorderBrush="#4F5A62" Cursor="Hand" ToolTip="최소화"/>
            <Button Name="CloseButton" Content="×" Width="30" Height="30" FontSize="17" Foreground="#C7CDD0" Background="#B0171E24" BorderBrush="#4F5A62" Cursor="Hand" ToolTip="닫기"/>
          </StackPanel>
        </Grid>
      </Border>
      <StackPanel Grid.Row="1" VerticalAlignment="Center" Margin="0,6,0,0">
          <TextBlock Text="오늘 지금까지 쌓인 예상 급여" Foreground="#AAB2B7" FontSize="12" HorizontalAlignment="Center" Margin="0,1,0,5"/>
          <StackPanel Name="DigitsPanel" Orientation="Horizontal" HorizontalAlignment="Center" Height="56"><StackPanel.Effect><DropShadowEffect Color="#000000" BlurRadius="4" ShadowDepth="0" Opacity="1"/></StackPanel.Effect></StackPanel>
          <Border Background="#9410181E" BorderBrush="#55374249" BorderThickness="1" CornerRadius="9" Padding="8,7" Margin="0,7,0,0">
            <StackPanel><Grid><Grid.ColumnDefinitions><ColumnDefinition/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions><TextBlock Name="PercentText" Text="0%" Foreground="#72DCA2" FontSize="11"/><TextBlock Grid.Column="1" Name="RemainText" Text="근무 전" Foreground="#A1AAB0" FontSize="11"/></Grid><Border Height="7" Background="#20282E" CornerRadius="4" Margin="0,6,0,0" ClipToBounds="True"><Grid HorizontalAlignment="Left" Name="ProgressFill" Background="#54DB96" Width="0"/></Border></StackPanel>
          </Border>
      </StackPanel>
      <Border Grid.Row="2" Background="#99141B20" BorderBrush="#8834424B" BorderThickness="1" CornerRadius="10" Padding="11,8" Margin="0,7,0,0">
        <Grid><Grid.ColumnDefinitions><ColumnDefinition/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
          <StackPanel><TextBlock Text="이번 달 누적 예상 급여" Foreground="#B8C0C5" FontSize="11"/><TextBlock Name="MonthlyBasisText" Text="월말 예상액 계산 중" Foreground="#939DA3" FontSize="9" Margin="0,2,0,0"/></StackPanel>
          <StackPanel Grid.Column="1" Name="MonthlyDigitsPanel" Orientation="Horizontal" Height="25" VerticalAlignment="Center"/>
        </Grid>
      </Border>
      <Border Grid.Row="3" Name="HolidayPayPanel" Visibility="Collapsed" Background="#991B1710" BorderBrush="#8A58422A" BorderThickness="1" CornerRadius="10" Padding="11,7" Margin="0,7,0,0">
        <Grid><Grid.ColumnDefinitions><ColumnDefinition/><ColumnDefinition Width="Auto"/></Grid.ColumnDefinitions>
          <StackPanel><TextBlock Text="예상 주휴수당" Foreground="#B8C0C5" FontSize="11"/><TextBlock Name="HolidayPayBasisText" Text="정확하지 않을 수 있어요" Foreground="#939DA3" FontSize="9" Margin="0,2,0,0"/></StackPanel>
          <TextBlock Grid.Column="1" Name="HolidayPayText" Text="₩0" Foreground="#F7C66B" FontSize="17" FontWeight="Bold" VerticalAlignment="Center"/>
        </Grid>
      </Border>
      <TextBlock Grid.Row="4" Text="실제 입금액이 아닌 참고용 추정치 · v2.4" Foreground="#A0A8AD" FontSize="10" HorizontalAlignment="Center" Margin="0,8,0,0"/>
    </Grid>
  </Border>
</Window>
'@

$reader = New-Object System.Xml.XmlNodeReader $xaml
$window = [Windows.Markup.XamlReader]::Load($reader)
$digitsPanel = $window.FindName('DigitsPanel')
$statusText = $window.FindName('StatusText')
$percentText = $window.FindName('PercentText')
$remainText = $window.FindName('RemainText')
$progressFill = $window.FindName('ProgressFill')
$monthlyDigitsPanel = $window.FindName('MonthlyDigitsPanel')
$monthlyBasisText = $window.FindName('MonthlyBasisText')
$holidayPayPanel = $window.FindName('HolidayPayPanel')
$holidayPayText = $window.FindName('HolidayPayText')
$holidayPayBasisText = $window.FindName('HolidayPayBasisText')
$dragBar = $window.FindName('DragBar')
$settingsButton = $window.FindName('SettingsButton')
$minButton = $window.FindName('MinButton')
$closeButton = $window.FindName('CloseButton')

$configDir = Join-Path ([Environment]::GetFolderPath('LocalApplicationData')) 'SalaryClock'
$configPath = Join-Path $configDir 'settings.json'
$defaults = [ordered]@{ Hourly = 12000; Start = '09:30'; End = '17:00'; BreakStart = '12:30'; BreakEnd = '13:30'; WorkDays = 'Monday,Tuesday,Wednesday,Thursday,Friday'; MonthlyWorkdays = ''; MonthlyWorkdaysMonth = ''; HolidayPayEnabled = $false }
$script:config = [ordered]@{}

function Load-Config {
  foreach ($key in $defaults.Keys) { $script:config[$key] = $defaults[$key] }
  if (Test-Path -LiteralPath $configPath) {
    try { $saved = Get-Content -Raw -LiteralPath $configPath | ConvertFrom-Json; foreach ($key in $defaults.Keys) { if ($null -ne $saved.$key) { $script:config[$key] = $saved.$key } } } catch {}
  }
}
function Save-Config {
  if (!(Test-Path -LiteralPath $configDir)) { New-Item -ItemType Directory -Path $configDir -Force | Out-Null }
  [pscustomobject]$script:config | ConvertTo-Json | Set-Content -LiteralPath $configPath -Encoding UTF8
}
function Minutes([string]$value) { $parts = $value.Split(':'); return ([int]$parts[0] * 60 + [int]$parts[1]) }
function Duration-Text([double]$minutes) {
  $m = [Math]::Max(0, [Math]::Ceiling($minutes)); $h = [Math]::Floor($m / 60); $r = $m % 60
  if ($h -gt 0) { if ($r -gt 0) { return "${h}시간 ${r}분" }; return "${h}시간" }; return "${r}분"
}
function Get-MonthWorkdayCount {
  $today = Get-Date; $monthKey = $today.ToString('yyyy-MM')
  if ($script:config.MonthlyWorkdaysMonth -eq $monthKey -and "$($script:config.MonthlyWorkdays)" -match '^\d+$') { return [int]$script:config.MonthlyWorkdays }
  $first = Get-Date -Year $today.Year -Month $today.Month -Day 1
  $selected = @($script:config.WorkDays -split ','); $days = [DateTime]::DaysInMonth($today.Year,$today.Month); $count = 0
  for ($day=0; $day -lt $days; $day++) { $date=$first.AddDays($day); if ($selected -contains $date.DayOfWeek.ToString()) { $count++ } }
  return $count
}
function Get-CompletedWorkdayCount {
  $today = (Get-Date).Date; $first = Get-Date -Year $today.Year -Month $today.Month -Day 1
  $selected = @($script:config.WorkDays -split ','); $count = 0
  for ($date=$first; $date -lt $today; $date=$date.AddDays(1)) { if ($selected -contains $date.DayOfWeek.ToString()) { $count++ } }
  return $count
}
function Get-WorkState {
  $now = Get-Date; $nowMin = $now.Hour * 60 + $now.Minute + $now.Second / 60.0 + $now.Millisecond / 60000.0
  [double]$start = Minutes $script:config.Start; [double]$end = Minutes $script:config.End; [double]$bs = Minutes $script:config.BreakStart; [double]$be = Minutes $script:config.BreakEnd
  [double]$overlap = [Math]::Max(0.0, [Math]::Min($end, $be) - [Math]::Max($start, $bs)); [double]$total = [Math]::Max(0.0, $end - $start - $overlap)
  [double]$clampedNow = [Math]::Min([double]$nowMin, $end)
  [double]$raw = [Math]::Max(0.0, $clampedNow - $start)
  [double]$breakElapsed = [Math]::Max(0.0, [Math]::Min($clampedNow, $be) - [Math]::Max($start, $bs))
  [double]$elapsed = [Math]::Max(0.0, [Math]::Min($total, $raw - $breakElapsed)); [double]$progress = if ($total -gt 0) { $elapsed / $total } else { 0.0 }
  $daily = [double]$script:config.Hourly * $total / 60.0; $earned = $daily * $progress
  $isWorkday = @($script:config.WorkDays -split ',') -contains $now.DayOfWeek.ToString()
  if (!$isWorkday) { $earned = 0.0; $progress = 0.0; $status = '오늘은 출근 없는 날'; $remaining = '다음 출근일에 시작' }
  elseif ($nowMin -ge $end) { $status = '오늘 근무 완료'; $remaining = '퇴근 완료' }
  elseif ($nowMin -ge $bs -and $nowMin -lt $be) { $status = '휴게 중'; $remaining = "$(Duration-Text ($end-$nowMin)) 후 퇴근" }
  elseif ($nowMin -ge $start) { $status = '근무 중'; $remaining = "$(Duration-Text ($end-$nowMin)) 후 퇴근" }
  else { $status = '근무 전'; $remaining = '근무 전' }
  return [pscustomobject]@{ Earned=$earned; Daily=$daily; Progress=$progress; Status=$status; Remaining=$remaining }
}

$script:previousMoney = ''
$script:previousMonthly = ''
$script:lastDisplaySecond = ''
function New-DigitText([string]$char) {
  $text = New-Object Windows.Controls.TextBlock
  $text.Text = $char; $text.FontFamily = New-Object Windows.Media.FontFamily('Cascadia Mono, Consolas')
  $text.FontSize = if ($char -eq ',') { 34 } else { 47 }; $text.FontWeight = 'Bold'; $text.Foreground = '#F3F7F5'
  $text.Effect = New-Object Windows.Media.Effects.DropShadowEffect -Property @{Color=[Windows.Media.Colors]::Black;BlurRadius=3;ShadowDepth=0;Opacity=1}
  $text.HorizontalAlignment = 'Center'; $text.VerticalAlignment = 'Center'; $text.TextAlignment = 'Center'
  return $text
}
function Update-RollingMoney([double]$amount) {
  $value = '₩' + ([Math]::Floor($amount)).ToString('N0')
  if ($value -eq $script:previousMoney) { return }
  $oldValue = $script:previousMoney; $digitsPanel.Children.Clear()
  for ($i=0; $i -lt $value.Length; $i++) {
    $ch = $value.Substring($i,1); $oldCh = if ($i -lt $oldValue.Length) { $oldValue.Substring($i,1) } else { '' }
    $cell = New-Object Windows.Controls.Grid; $cell.Height = 56; $cell.Width = if ($ch -eq ',') { 18 } elseif ($ch -eq '₩') { 35 } else { 31 }; $cell.ClipToBounds = $true
    $newText = New-DigitText $ch; if ($ch -eq '₩') { $newText.Foreground = '#6EE7A8'; $newText.FontSize = 31 }
    if ($oldCh -ne '' -and $oldCh -ne $ch -and $ch -match '[0-9]') {
      $oldText = New-DigitText $oldCh; $oldTransform = New-Object Windows.Media.TranslateTransform; $oldText.RenderTransform = $oldTransform
      $newTransform = New-Object Windows.Media.TranslateTransform; $newTransform.Y = 56; $newText.RenderTransform = $newTransform
      $cell.Children.Add($oldText) | Out-Null; $cell.Children.Add($newText) | Out-Null
      $ease = New-Object Windows.Media.Animation.SineEase; $ease.EasingMode = 'EaseInOut'
      $upOld = New-Object Windows.Media.Animation.DoubleAnimation(0,-56,[TimeSpan]::FromMilliseconds(820)); $upOld.EasingFunction = $ease
      $upNew = New-Object Windows.Media.Animation.DoubleAnimation(56,0,[TimeSpan]::FromMilliseconds(820)); $upNew.EasingFunction = $ease
      $oldTransform.BeginAnimation([Windows.Media.TranslateTransform]::YProperty,$upOld); $newTransform.BeginAnimation([Windows.Media.TranslateTransform]::YProperty,$upNew)
    } else { $cell.Children.Add($newText) | Out-Null }
    $digitsPanel.Children.Add($cell) | Out-Null
  }
  $script:previousMoney = $value
}
function New-MonthDigitText([string]$char) {
  $text = New-Object Windows.Controls.TextBlock; $text.Text=$char; $text.FontFamily=New-Object Windows.Media.FontFamily('Cascadia Mono, Consolas'); $text.FontSize=17; $text.FontWeight='Bold'; $text.Foreground='#DDF9E9'; $text.Effect=New-Object Windows.Media.Effects.DropShadowEffect -Property @{Color=[Windows.Media.Colors]::Black;BlurRadius=3;ShadowDepth=0;Opacity=1}; $text.HorizontalAlignment='Center'; $text.VerticalAlignment='Center'; $text.TextAlignment='Center'; return $text
}
function Update-RollingMonthly([double]$amount) {
  $value='₩'+([Math]::Floor($amount)).ToString('N0'); if($value -eq $script:previousMonthly){return}; $oldValue=$script:previousMonthly; $monthlyDigitsPanel.Children.Clear()
  for($i=0;$i -lt $value.Length;$i++){
    $ch=$value.Substring($i,1); $oldCh=if($i -lt $oldValue.Length){$oldValue.Substring($i,1)}else{''}; $cell=New-Object Windows.Controls.Grid; $cell.Height=25; $cell.Width=if($ch -eq ','){7}elseif($ch -eq '₩'){14}else{11}; $cell.ClipToBounds=$true; $newText=New-MonthDigitText $ch
    if($oldCh -ne '' -and $oldCh -ne $ch -and $ch -match '[0-9]'){$oldText=New-MonthDigitText $oldCh;$oldTransform=New-Object Windows.Media.TranslateTransform;$oldText.RenderTransform=$oldTransform;$newTransform=New-Object Windows.Media.TranslateTransform;$newTransform.Y=25;$newText.RenderTransform=$newTransform;$cell.Children.Add($oldText)|Out-Null;$cell.Children.Add($newText)|Out-Null;$ease=New-Object Windows.Media.Animation.SineEase;$ease.EasingMode='EaseInOut';$oldAnim=New-Object Windows.Media.Animation.DoubleAnimation(0,-25,[TimeSpan]::FromMilliseconds(820));$oldAnim.EasingFunction=$ease;$newAnim=New-Object Windows.Media.Animation.DoubleAnimation(25,0,[TimeSpan]::FromMilliseconds(820));$newAnim.EasingFunction=$ease;$oldTransform.BeginAnimation([Windows.Media.TranslateTransform]::YProperty,$oldAnim);$newTransform.BeginAnimation([Windows.Media.TranslateTransform]::YProperty,$newAnim)}else{$cell.Children.Add($newText)|Out-Null};$monthlyDigitsPanel.Children.Add($cell)|Out-Null
  }; $script:previousMonthly=$value
}
function Refresh-UI {
  $state = Get-WorkState
  $secondKey = (Get-Date).ToString('yyyyMMddHHmmss')
  $displayTick = $false
  if ($secondKey -ne $script:lastDisplaySecond) {
    $script:lastDisplaySecond = $secondKey
    $displayTick = $true
    Update-RollingMoney $state.Earned
  }
  $statusText.Text = $state.Status; $percentText.Text = "{0}%" -f [Math]::Round($state.Progress*100); $remainText.Text = $state.Remaining
  $workdays = Get-MonthWorkdayCount; $completedDays = [Math]::Min((Get-CompletedWorkdayCount),$workdays); $monthlyTotal = $state.Daily * $workdays; $monthlyAccrued = [Math]::Min($monthlyTotal, $state.Daily * $completedDays + $state.Earned); if($displayTick){Update-RollingMonthly $monthlyAccrued}; $manualMonth=((Get-Date).ToString('yyyy-MM') -eq $script:config.MonthlyWorkdaysMonth -and "$($script:config.MonthlyWorkdays)" -match '^\d+$'); $basis=if($manualMonth){"직접 설정 ${workdays}일"}else{"선택 요일 ${workdays}일"}; $monthlyBasisText.Text = "$basis · 월말 예상 ₩$(([Math]::Round($monthlyTotal)).ToString('N0'))"
  $selectedDayCount=@($script:config.WorkDays -split ',' | Where-Object {$_}).Count; $dailyHours=if([double]$script:config.Hourly -gt 0){$state.Daily/[double]$script:config.Hourly}else{0}; $weeklyHours=$dailyHours*$selectedDayCount; $eligible=($weeklyHours -ge 15 -and $selectedDayCount -gt 0); $weekUnits=if($selectedDayCount -gt 0){$workdays/$selectedDayCount}else{0}; $holidayHours=[Math]::Min(8.0,$weeklyHours/5.0); $rawHoliday=[double]$script:config.Hourly*$holidayHours*$weekUnits; $holidayEstimate=if($eligible){[Math]::Max(0,[Math]::Floor($rawHoliday-15000))}else{0}; $holidayPayText.Text='₩'+$holidayEstimate.ToString('N0'); $holidayPayBasisText.Text=if($eligible){"주 $(('{0:N1}' -f $weeklyHours))시간 · 보수적으로 15,000원 낮춤"}else{"주 15시간 미만이면 발생하지 않을 수 있어요"}; $holidayPayPanel.Visibility=if([bool]$script:config.HolidayPayEnabled){'Visible'}else{'Collapsed'}; $requiredHeight=if([bool]$script:config.HolidayPayEnabled){366}else{304}; $window.MinHeight=$requiredHeight; if($window.ActualHeight -lt $requiredHeight){$window.Height=$requiredHeight}
  $maxWidth = [Math]::Max(0,$window.ActualWidth-46); $progressFill.Width = $maxWidth * $state.Progress
  $statusText.Foreground = '#AAB2B7'
}

function Show-Settings {
  [xml]$settingsXaml = @'
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" Title="근무 설정" Width="380" Height="650" WindowStartupLocation="CenterOwner" ResizeMode="NoResize" Background="#10161B" Foreground="#F3F7F5">
 <Grid Margin="24"><Grid.RowDefinitions><RowDefinition Height="Auto"/><RowDefinition Height="*"/><RowDefinition Height="Auto"/></Grid.RowDefinitions>
  <StackPanel><TextBlock Text="근무 설정" FontSize="21" FontWeight="Bold"/><TextBlock Text="비콘 기록과 다르면 인정 시간을 직접 맞춰 주세요." Foreground="#8F9CA5" FontSize="11" Margin="0,6,0,18"/></StackPanel>
  <Grid Grid.Row="1"><Grid.ColumnDefinitions><ColumnDefinition/><ColumnDefinition Width="12"/><ColumnDefinition/></Grid.ColumnDefinitions><Grid.RowDefinitions><RowDefinition/><RowDefinition/><RowDefinition/><RowDefinition Height="Auto"/><RowDefinition Height="Auto"/><RowDefinition Height="Auto"/></Grid.RowDefinitions>
   <StackPanel Grid.ColumnSpan="3"><TextBlock Text="시급 (원)" Margin="0,0,0,6"/><TextBox Name="HourlyBox" Height="35" Padding="9,6" Background="#0A0F13" Foreground="White" BorderBrush="#35424C"/></StackPanel>
   <StackPanel Grid.Row="1"><TextBlock Text="출근 시각" Margin="0,12,0,6"/><TextBox Name="StartBox" Height="35" Padding="9,6" Background="#0A0F13" Foreground="White" BorderBrush="#35424C"/></StackPanel>
   <StackPanel Grid.Row="1" Grid.Column="2"><TextBlock Text="퇴근 시각" Margin="0,12,0,6"/><TextBox Name="EndBox" Height="35" Padding="9,6" Background="#0A0F13" Foreground="White" BorderBrush="#35424C"/></StackPanel>
   <StackPanel Grid.Row="2"><TextBlock Text="휴게 시작" Margin="0,12,0,6"/><TextBox Name="BreakStartBox" Height="35" Padding="9,6" Background="#0A0F13" Foreground="White" BorderBrush="#35424C"/></StackPanel>
   <StackPanel Grid.Row="2" Grid.Column="2"><TextBlock Text="휴게 종료" Margin="0,12,0,6"/><TextBox Name="BreakEndBox" Height="35" Padding="9,6" Background="#0A0F13" Foreground="White" BorderBrush="#35424C"/></StackPanel>
   <StackPanel Grid.Row="3" Grid.ColumnSpan="3" Margin="0,15,0,0"><TextBlock Text="출근 요일" Margin="0,0,0,8"/><UniformGrid Columns="5"><CheckBox Name="MondayBox" Content="월"/><CheckBox Name="TuesdayBox" Content="화"/><CheckBox Name="WednesdayBox" Content="수"/><CheckBox Name="ThursdayBox" Content="목"/><CheckBox Name="FridayBox" Content="금"/></UniformGrid></StackPanel>
   <StackPanel Grid.Row="4" Grid.ColumnSpan="3" Margin="0,15,0,0"><TextBlock Text="이번 달 실제 출근 예정일 (선택)" Margin="0,0,0,6"/><TextBox Name="MonthlyWorkdaysBox" Height="35" Padding="9,6" Background="#0A0F13" Foreground="White" BorderBrush="#35424C"/><TextBlock Text="비워두면 선택한 요일로 자동 계산합니다." Foreground="#71808A" FontSize="10" Margin="0,4,0,0"/></StackPanel>
   <Border Grid.Row="5" Grid.ColumnSpan="3" Background="#181710" BorderBrush="#4B422C" BorderThickness="1" CornerRadius="9" Padding="11" Margin="0,14,0,0"><StackPanel><CheckBox Name="HolidayPayBox" Content="주휴수당 예상 계산 ON / OFF" FontWeight="Bold" Foreground="#F7C66B"/><TextBlock Name="HolidayWarning" Text="주휴수당은 계약·개근 여부에 따라 달라 정확하지 않을 수 있습니다. 계산값은 보수적으로 15,000원 낮게 표시합니다." TextWrapping="Wrap" Foreground="#B5A784" FontSize="10" Margin="0,7,0,0" Visibility="Collapsed"/></StackPanel></Border>
  </Grid>
  <StackPanel Grid.Row="2" Orientation="Horizontal" HorizontalAlignment="Right" Margin="0,20,0,0"><Button Name="CancelButton" Content="취소" Width="76" Height="36" Margin="0,0,8,0"/><Button Name="SaveButton" Content="저장" Width="76" Height="36" Background="#6EE7A8" Foreground="#062013" FontWeight="Bold"/></StackPanel>
 </Grid>
</Window>
'@
  $r = New-Object System.Xml.XmlNodeReader $settingsXaml; $dialog = [Windows.Markup.XamlReader]::Load($r); $dialog.Owner = $window
  $hourlyBox=$dialog.FindName('HourlyBox');$startBox=$dialog.FindName('StartBox');$endBox=$dialog.FindName('EndBox');$breakStartBox=$dialog.FindName('BreakStartBox');$breakEndBox=$dialog.FindName('BreakEndBox');$monthlyWorkdaysBox=$dialog.FindName('MonthlyWorkdaysBox');$holidayPayBox=$dialog.FindName('HolidayPayBox');$holidayWarning=$dialog.FindName('HolidayWarning')
  $hourlyBox.Text=$script:config.Hourly;$startBox.Text=$script:config.Start;$endBox.Text=$script:config.End;$breakStartBox.Text=$script:config.BreakStart;$breakEndBox.Text=$script:config.BreakEnd
  $dayBoxes=[ordered]@{Monday=$dialog.FindName('MondayBox');Tuesday=$dialog.FindName('TuesdayBox');Wednesday=$dialog.FindName('WednesdayBox');Thursday=$dialog.FindName('ThursdayBox');Friday=$dialog.FindName('FridayBox')}; $selectedDays=@($script:config.WorkDays -split ','); foreach($day in $dayBoxes.Keys){$dayBoxes[$day].IsChecked=($selectedDays -contains $day)}
  $monthlyWorkdaysBox.Text = if($script:config.MonthlyWorkdaysMonth -eq (Get-Date).ToString('yyyy-MM')){"$($script:config.MonthlyWorkdays)"}else{''}
  $holidayPayBox.IsChecked=[bool]$script:config.HolidayPayEnabled; $holidayWarning.Visibility=if($holidayPayBox.IsChecked){'Visible'}else{'Collapsed'}; $holidayPayBox.Add_Checked({$holidayWarning.Visibility='Visible'}); $holidayPayBox.Add_Unchecked({$holidayWarning.Visibility='Collapsed'})
  $dialog.FindName('CancelButton').Add_Click({$dialog.DialogResult=$false;$dialog.Close()})
  $dialog.FindName('SaveButton').Add_Click({
    $hourly=0; $validHourly=[int]::TryParse($hourlyBox.Text,[ref]$hourly); $timePattern='^([01]\d|2[0-3]):[0-5]\d$'
    if(!$validHourly -or $hourly -le 0 -or $startBox.Text -notmatch $timePattern -or $endBox.Text -notmatch $timePattern -or $breakStartBox.Text -notmatch $timePattern -or $breakEndBox.Text -notmatch $timePattern){[Windows.MessageBox]::Show('시급과 시간을 확인해 주세요. 시간은 09:30 형식으로 입력합니다.','입력 확인')|Out-Null;return}
    if((Minutes $endBox.Text) -le (Minutes $startBox.Text) -or (Minutes $breakEndBox.Text) -le (Minutes $breakStartBox.Text)){[Windows.MessageBox]::Show('종료 시각은 시작 시각보다 늦어야 합니다.','입력 확인')|Out-Null;return}
    $chosen=@($dayBoxes.Keys | Where-Object {$dayBoxes[$_].IsChecked -eq $true}); if($chosen.Count -eq 0){[Windows.MessageBox]::Show('출근 요일을 하나 이상 선택해 주세요.','입력 확인')|Out-Null;return}
    $manualDays=$monthlyWorkdaysBox.Text.Trim(); if($manualDays -ne '' -and ($manualDays -notmatch '^\d+$' -or [int]$manualDays -gt 31)){[Windows.MessageBox]::Show('이번 달 출근일은 0~31 사이 숫자로 입력하거나 비워 주세요.','입력 확인')|Out-Null;return}
    $script:config.Hourly=$hourly;$script:config.Start=$startBox.Text;$script:config.End=$endBox.Text;$script:config.BreakStart=$breakStartBox.Text;$script:config.BreakEnd=$breakEndBox.Text;$script:config.WorkDays=($chosen -join ',');$script:config.MonthlyWorkdays=$manualDays;$script:config.MonthlyWorkdaysMonth=if($manualDays -ne ''){(Get-Date).ToString('yyyy-MM')}else{''};$script:config.HolidayPayEnabled=[bool]$holidayPayBox.IsChecked;Save-Config;$script:previousMoney='';$script:previousMonthly='';$script:lastDisplaySecond='';Refresh-UI;$dialog.DialogResult=$true;$dialog.Close()
  })
  $dialog.ShowDialog() | Out-Null
}

Load-Config
$dragBar.Add_MouseLeftButtonDown({ if ($_.ButtonState -eq 'Pressed') { $window.DragMove() } })
$settingsButton.Add_Click({ Show-Settings }); $minButton.Add_Click({ $window.WindowState='Minimized' }); $closeButton.Add_Click({ $window.Close() })
$window.Add_SizeChanged({ Refresh-UI })
$timer = New-Object Windows.Threading.DispatcherTimer([Windows.Threading.DispatcherPriority]::Render)
$timer.Interval=[TimeSpan]::FromMilliseconds(100)
$timer.Add_Tick({Refresh-UI})
$timer.Start()
$window.Add_Loaded({ Refresh-UI })
$window.ShowDialog() | Out-Null

