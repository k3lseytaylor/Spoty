#!/usr/bin/env bash

function spoty(){
    
    White='\033[0;37m'
   
    ################################################################################
    # Help                                                                         #
    ################################################################################
    Help(){
	echo -ne "\e]1;Spotify Help page\a"
        # Display Help
        echo
        echo
        echo "A Simple Bash Script to control Spotify."
        echo "From the Terminal."
        echo
        echo "If spoty is runned with out an argument it will toggle Play/Pause"
        echo 
        echo "Options:"
        echo "-sp [song URI]      Play URI link song"
        echo "-t                  Quits/Activates Spotify."
        echo "-n                  Changes to Next Song."
        echo "-b                  Changes to Previous Song"
        echo "-c                  Shows Current Song Playing."
        echo "-s                  Toggles shuffle on and off"
        echo "-r                  Toggles repeat on and off"
        echo 
        echo "Volume Controls:"
        echo "-v up               incearse volume by default 10"
        echo "-v up [number]      increase volume by number inputed"
        echo "-v down             decreases volume by default 10"
        echo "-v down [number]    decrease volume by number inputed"
        echo "-m                  toggles mute/unmute"
        echo
        echo "Example:"
        echo "spoty -v up 30"
        echo "↑ This command will increase volume by 30"
        echo
        echo
    }
    _current(){
        echo "\033[0;31m Currently Playing"
        sleep 0.3s
        echo '                                                 '
        echo -n "    ${White} Song: " ;  spoty_command "get name of current track"
        echo -n "    ${White} Artist: ";  spoty_command "get artist of current track"
        echo -n "    ${White} Played Count: "; spoty_command "get played count of current track"
        echo '                                                 '  
        echo -n "    ${White} Track ID: "; spoty_command "get id of current track"
        echo -n "    ${White} Artwork ID: "; spoty_command "get artwork url of current track"
        echo '                                                 '  
    }
#Main Command
    spoty_command(){
         osascript -e "tell application \"Spotify\"" -e "$1" -e"end tell"
    }

#OS Volume Controls

    os_vol_ctrl(){

    }
#Mute
#Need to add check value before muting saving that value 
#when resuming resume to that value
    spoty_mute_toggle(){ #toggles mute/unmute
        osascript -e"
        tell application \"Spotify\"
            set currentvol to get sound volume
            -- volume wraps at 0 to 100
            if currentvol = 0 then
                set sound volume to 50
                return \"🔈  unmuted\"
            else
                set sound volume to 0
                return \"🔇  muted\"
            end if
        end tell"       
    }
#Spotify Volume Controll
    spoty_vol_ctrl(){ #sets Volume up on spotify by 10 if no input
    RED='\033[0;31m'
    default=10 #Change this value for Default increase 
    vol="${2:-$default}"
    dir=
    num=
    sign=
    ntf=
    case $1 in
        "up")
            dir=">"
            num=90
            sign='+'
            moved="increased"
            ;;
        "down")
            dir="<"
            num=10
            sign='-'
            moved='decreased'
            ;;
        *)
            echo -n "unknown command"
            ;;
    esac
    # echo $vol $dir $num $sign
    echo "${RED}Volume ${moved} by $vol "
        osascript -e"
        tell application \"Spotify\"
            set currentvol to get sound volume
            if currentvol $dir $num then 
                set sound volume to 100
            else
                set sound volume to currentvol $sign $vol
            end if
        end tell"    
}

#Add Shuffle control - set shuffling to false
    spoty_shuffle(){
        osascript -e"
            tell application \"Spotify\"
                if shuffling = true then
                    set shuffling to false
                    return \"shuffle off\"
                else
                    set shuffling to true
                    return \"shuflle on\"
                end if
            end tell"  
    }

    spoty_repeat(){
        osascript -e"
            tell application \"Spotify\"
                if repeating = true then
                    set repeating to false
                    return \"repeat off\"
                else
                    set repeating to true
                    return  \"repeat on\"
                end if
            end tell"  
    }

    update_tab(){
        while true;
         do  output="$(spoty_command "get name of current track" )";
             echo -ne "\e]1;Playing <<$output>>...\a"; sleep 300;
             sleep 180; done
    }
    

    api_intergration(){
        #pull songs from api 
        #	https://api.spotify.com/v1/tracks/{id} GET // gets track with track ID
    }


    
#Opens Artwork or Song in defualt browser
    pull_art(){
        URL="$(spoty_command "get artwork url of current track")"
        osascript -e"open location \"${URL}\""
    }
    
    pull_song(){
        URL="$(spoty_command "get id of current track")"
        TRIM_URL=${URL##*:}
        osascript -e"open location \"https://open.spotify.com/track/${TRIM_URL}\""
    }

    
    case $1 in
        "-sp")
            echo $2
            # if [ -z "$2" ] //checks lenght of arg 2
            # then
            #     echo "\033[0;31m ERROR:  MISSING URI";
            # else
                #echo "\033[0;31m $2" just checking $2 arugument
                
                spoty_command "play track \"$2\""
                #sleep 0.5s #need delay or it doesnt display correctly
                _current
               echo "Feature under construction"
            # fi
            ;;
        "-r")
            spoty_repeat
            ;;
        "-s")
            spoty_shuffle
            ;;
        "-h")
            Help
            ;;
        "-t")
            if pgrep -x "Spotify" > /dev/null #Checks if Spotify is running or not
            then
                spoty_command "quit"
                wait
                echo "Quit"
            else
                spoty_command "activate"
                wait
                echo "Activated"
            fi
            ;;
        "")
            spoty_command "playpause"
            wait
            output="$(spoty_command "get player state" )"
            echo -e '✨' $output
            echo -ne "\e]1;Spoty $output...\a"
             if [ $output = 'playing' ]
             then
               sleep 0.7s #needs to wait for player to set current song || it will reply an empty output when using the command spoty after the app has closed
                _current
             fi
            ;;
        "-n")
            spoty_command "next track"
            _current
            ;;
        "-b")
            spoty_command "previous track" #only going back once will start at the start of the current song
                wait
            spoty_command "previous track"
            _current
            ;;
        "-c")
            _current 
            output="$(spoty_command "get name of current track" )";
            echo -ne "\e]1;Playing <<$output>>...\a"; #update Terminal tab name                            
            ;;
        "-v")
            spoty_vol_ctrl $2 $3
            ;;
        "-m")
            spoty_mute_toggle
            ;; 
        "-art")
            pull_art
            ;;
        "-song")
            pull_song
            ;;
        *)
            echo -n "unknown command"
            ;;
    esac
}