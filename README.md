# set-top-reddit-wallpaper
PowerShell script to set the wallpaper as the top post of the day from /r/wallpapers and /r/wallpaper.

You can change the subreddits to look through and the timeframe.

You can run this script as a scheduled task, or whenever you want to change your wallpaper.

## Parameters
`$folder`     : The folder where the script will save wallpapers, make sure to edit it before running the script.

`$subreddits` : List of subreddits to look through for wallpapers, set by default to `@("wallpapers","wallpaper")`.

`$timeframe`  : Timeframe to look for, set by default to `"day"` but can bet set to `"week"`, `"month"`, etc.
