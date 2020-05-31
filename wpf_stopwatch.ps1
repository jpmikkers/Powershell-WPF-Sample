using assembly PresentationFramework    #Add-Type -AssemblyName PresentationFramework
using namespace System.Windows
using namespace System.Windows.Controls
using namespace System.Windows.Media

$mainWindow = [Window]::new()
$mainWindow.Title = "Powershell WPF Stopwatch"
$mainWindow.SizeToContent = [SizeToContent]::WidthAndHeight

$stackPanel = [StackPanel]::new()
$stackPanel.Orientation = [Orientation]::Vertical
$stackPanel.Background = [Brushes]::AliceBlue

$stopWatch = [System.Diagnostics.Stopwatch]::new()

$label = [Label]::new() 
$label.HorizontalAlignment        = [HorizontalAlignment]::Stretch
$label.HorizontalContentAlignment = [HorizontalAlignment]::Center
$label.Content                    = "00:00:00.000"
$label.FontSize                   = 60
$label.Background                 = [Brushes]::Black
$label.Foreground                 = [Brushes]::LightGreen
$stackPanel.Children.Add($label)| Out-Null

$buttonMargin = [Thickness]::new(4.0,2.0,4.0,2.0)

$buttonStart = [Button]::new()
$buttonStart.ClickMode = [ClickMode]::Press
$buttonStart.Content = "_Start"
$buttonStart.Margin  = $buttonMargin
$buttonStart.Add_Click( { $stopWatch.Start() } )
$stackPanel.Children.Add($buttonStart) | Out-Null

$buttonStop = [Button]::new()
$buttonStop.ClickMode = [ClickMode]::Press
$buttonStop.Content = "S_top"
$buttonStop.Margin  = $buttonMargin
$buttonStop.Add_Click( { $stopWatch.Stop() } )
$stackPanel.Children.Add($buttonStop)| Out-Null

$buttonReset = [Button]::new()
$buttonReset.ClickMode = [ClickMode]::Press
$buttonReset.Content = "_Reset"
$buttonReset.Margin  = $buttonMargin
$buttonReset.Add_Click( { $stopWatch.Reset() } )
$stackPanel.Children.Add($buttonReset)| Out-Null

$mainWindow.Content = $stackPanel

$dispatcherTimer = [System.Windows.Threading.DispatcherTimer]::new()
$dispatcherTimer.Interval = [timespan]::FromMilliseconds(50)
$dispatcherTimer.Add_Tick( { 
    if($mainWindow.SizeToContent -ne [SizeToContent]::Manual)
    {
        $mainWindow.MinHeight = $mainWindow.Height
        $mainWindow.MinWidth = $mainWindow.Width
        $mainWindow.SizeToContent = [SizeToContent]::Manual
    }
    $label.Content = ('{0:hh}:{0:mm}:{0:ss}.{0:fff}' -f $stopWatch.Elapsed)
} )


try
{
    $dispatcherTimer.Start()
    $mainWindow.ShowDialog() | Out-Null
}
finally
{
    $dispatcherTimer.Stop()
}

$stopWatch.Elapsed
