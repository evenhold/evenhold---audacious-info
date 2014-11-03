#!/bin/bash
# -*- coding: utf-8 -*-


## Author: Franz Victorio
## E-Mail: evenhold@gmail.com
## Version: 1.0


## Feature(s):
## *) The conky window disappears when audacious is not playing.

## **************************************************************************


Corners=10
Opacity=0.0
BGColor='grey' 




CharLength=7
StaticWidth=127
MinWidth=335
Height=118
WordCount=0

ListPosition=$(audtool playlist-position)
Status=$(audtool playback-status)
EchoStatus="Audacious is $Status" 

Title=$(audtool playlist-tuple-data title "$ListPosition")
if [ -z "$Title" ];then
    Title=$(basename "$(audtool playlist-song-filename \
            "$ListPosition")" .mp3 | sed 's/%20/ /g')
fi
TitleCount=$(echo "Title: "$Title"" | wc -m)

Album=$(audtool playlist-tuple-data album "$ListPosition")
AlbumCount=$(echo "Album: "$Album"" | wc -m)

Artist=$(audtool playlist-tuple-data artist "$ListPosition")
ArtistCount=$(echo "Artist: "$Artist"" | wc -m)

for varcount in $TitleCount $AlbumCount $ArtistCount 
do
    if [ $varcount -gt $WordCount ];then
        WordCount=$varcount
    fi
done

VarWidth=$(echo "${WordCount}*${CharLength}" | bc)
Width=$(echo ""$StaticWidth"+"$VarWidth"" | bc)

if [ $Width -le $MinWidth ];then
    Width=$MinWidth
fi






GetProgress(){
    CurrLen=$(audtool current-song-output-length-seconds)
    TotLen=$(audtool current-song-length-seconds)
    if (( $TotLen )); then
        ProgLen=$(expr $CurrLen \* 100  / $TotLen)
    fi
}

AudaciousInfo(){
    case "$1" in
        bg)         DrawBG ;;
        art)        GetArt ;;
        status)     echo "$EchoStatus" ;;
        title)      echo "$Title" ;;
        artist)     echo "$Artist" ;;
        album)      echo "$Album" ;;
        progress)   GetProgress ;;
    esac
}


    echo -n "               "
    echo "\${color #00D5FF}$EchoStatus" 
  
    echo "\${color #004765}  __________________________________________________"

    
    echo -n "    "
    echo -n "\${color #2BC4FF}Title: "
    echo -n "\${color #74D8FF}"
    AudaciousInfo title
    echo -n "    "

    echo -n "\${color #2BC4FF}Artist: "
    echo -n "\${color #74D8FF}"
    AudaciousInfo artist
 
    echo -n "    "
    echo -n "\${color #2BC4FF}Album: "
    echo -n "\${color #74D8FF}"
    AudaciousInfo album
    AudaciousInfo progress
 
    echo -n "  "
    echo "\${color #0092D0}\${execbar echo "$ProgLen"}"

