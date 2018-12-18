# Parameters
$folder = "C:\This\Is\A\Folder"                # Change this path to the folder where you want to save the wallpapers
$subreddits = @("wallpapers","wallpaper")      # List of subreddits to go through
$timeframe = "day"                             # Can be set to day, week, month, etc

# Initialise upvotes to 0 (variable to check which has more upvotes)
$upvotes = 0

# Loop through each subreddit
$subreddits | ForEach-Object{
    $json = Invoke-RestMethod -uri https://www.reddit.com/r/$_/top.json?t=$timeframe  # Get JSON file for the top posts
    $sub_upvotes = $json.data.children[0].data.ups                                    # Get number of upvotes for the top post
    
    # If the top post has more upvotes than the (current) most upvoted
    if($sub_upvotes -gt $upvotes){
        $upvotes = $sub_upvotes                                         # Set as most upvoted top post
        $url = $json.data.children[0].data.preview.images[0].source.url # Navigate through the JSON to get the URL
    }
}

# Replace &amp with & in the URL; More info : https://old.reddit.com/r/redditdev/comments/9ncg2r/changes_in_api_pictures/
$url = $url.Replace('&amp;', '&') 
                             
# Get the filename 
$todaydate = Get-Date -Format "yyyy-MM-dd"      # Get the date (file will be saved as date)
$extension = $url -replace '.*\.(.*?)\?.*','$1' # Get the file extension from the URL
$filename = "$todaysdate.$extension"            # Combine the date + the extension for the filename
$path = "$folder\$filename"                     # Complete outfile path (folder param + filename)


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
