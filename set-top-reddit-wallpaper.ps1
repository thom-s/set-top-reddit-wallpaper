# Parameters
$folder = "C:\This\Is\A\Folder" # Change this path to the folder where you want to save the wallpapers


# Find URL of image in the reddit JSON API
$json = Invoke-RestMethod -uri https://www.reddit.com/r/wallpapers/.json?t=day  # Get JSON file for the top posts of the day in /r/wallpaper
$url = $json.data.children[0].data.preview.images[0].source.url                 # Navigate through the JSON to get the URL
$url = $url.Replace('amp;s', 's')                                               # More info : https://old.reddit.com/r/redditdev/comments/9ncg2r/changes_in_api_pictures/


# Get the filename 
$todaydate = Get-Date -Format "yyyy-MM-dd" # Get the date (file will be saved as date)

If($url -contains "png"){                  # Check whether to save as PNG or JPG
    $filename = "$todaydate.png"       
}
Else{ 
    $filename = "$todaydate.jpg"
}

$path = "$folder\$filename"                # Complete outfile path


# Download and save the file
Invoke-WebRequest $url -OutFile $path


# Set the wallpaper - stolen from : https://stackoverflow.com/questions/43187787/change-wallpaper-powershell
$setwallpapersrc = @"
using System.Runtime.InteropServices;
public class wallpaper
{
public const int SetDesktopWallpaper = 20;
public const int UpdateIniFile = 0x01;
public const int SendWinIniChange = 0x02;
[DllImport("user32.dll", SetLastError = true, CharSet = CharSet.Auto)]
private static extern int SystemParametersInfo (int uAction, int uParam, string lpvParam, int fuWinIni);
public static void SetWallpaper ( string path )
{
SystemParametersInfo( SetDesktopWallpaper, 0, path, UpdateIniFile | SendWinIniChange );
}
}
"@

Add-Type -TypeDefinition $setwallpapersrc

[wallpaper]::SetWallpaper($path) 
