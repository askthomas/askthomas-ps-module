# ======================================================
#  Update wallpaper from script
#
#  (C) Thomas Ljunggren, 2020-10-15
#
# ======================================================

<#
	.SYNOPSIS
		Set wallpaper from script

	.Example
		set-preffered-wallpaper.ps1 c:\temp\wallpaper.jpg
		
   .NOTES
    Author: Thomas Ljunggren
    Github: askthomas
    1.0 - 2020-10-15, First Version
    1.1 - 2021-00-00, Auto show wallpaper without logout
    1.2 - 2021-00-00, Added paramter (force)
    1.3 - 2021-00-00, Adder prameter -wallpaper
    1.4 - 2021-11-20, Changed to Function
#>

function FunctionName {
   param (
      [string]$wallpaper = "C:\Users\ThomasLjunggren\OneDrive - Visolit\Pictures\Wallpapers\pexels-andy-vu-3244513.jpg"
   )
     
   $src_images = $wallpaper
   $dst_images = $env:APPDATA + "\Microsoft\Windows\Themes\TranscodedWallpaper"
  
   # Compare Files
   $src_info = Get-ChildItem $src_images
   $dst_info = Get-ChildItem $dst_images
   
$code = @' 
using System.Runtime.InteropServices; 
namespace Win32{ 
     public class Wallpaper{ 
        [DllImport("user32.dll", CharSet=CharSet.Auto)] 
         static extern int SystemParametersInfo (int uAction , int uParam , string lpvParam , int fuWinIni) ; 
         
         public static void SetWallpaper(string thePath){ 
            SystemParametersInfo(20,0,thePath,3); 
         }
      }
   } 
'@

   add-type $code 

   if ($src_info.LastWriteTime -ne $dst_info.LastWriteTime -or $args -eq "force") {

      write-host "Preffered Wallpaper updated. :-)"
      if ($args -eq "force") { write-host "Forced run..."}
      
      #Apply the Change on the system 
      Copy-Item $src_images $dst_images #Copy new images
      #Remove-Item $CachedFiles -Recurse
      [Win32.Wallpaper]::SetWallpaper($src_images)
      
   }

}
