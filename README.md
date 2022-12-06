# Spoty 
 <h3>Basic Mac Terminal Spotify Controler zsh</h3>
 
 ![Alt text](/demo/demo.gif?raw=true "demo")
 
 > <h4>Be Gentle</h4>
 
 This was originally built for personal use because i was getting tired of switching to the application mid coding session 
 and is sharing here because of intrest from friends code needs clean up be gentle 
 
 
 
 > <h4>Usage:</h4>
 
add ```source ~/Path/To/Spoty.zsh``` to your  ```.zshrc``` file and should be able to start using it
e.g. ```source ~/Desktop/spoty/Spoty.zsh ```


 
 > <h4>Planned Feature:</h4>
 
 * Play music by giving it song name or song name & artist name and pulling the track id using Spotify API and passing it to the application or calling the API to directly play (tho id figure this would cause some problems)
 another issue is that if i use the API friends and what not would have to go thru the whole proccess of setting up the API on their own machine
 
 * returns a artist top songs and lets u pick what to play (same issue as above would need to use API)



 
 > <h3>Commands</h3>

  If `spoty` is runned with out an argument it will toggle Play/Pause or if the application is close it will open it 
 
  
| Basic Play Commands  | Details |
| ------------- | :-------------: |
| `spoty` | Must call the commands below with spoty in front e.g. ```spoty -n ```|
| ```-t ```  | Quits/Activates Spotify.  |
| ```-n ``` | Changes to Next Song. |
| ```-b ``` | Changes to Previous Song |
| ```-c ``` | Shows Current Song Playing. |
| ```-s ``` | Toggles shuffle on and off. |
| ```-r ``` | Toggles repeat on and off. |
| ``` -sp [song URI]```  | Play URI link song (Track ID) |


 Controls Spotify Application Volume


| Volume Commands  | Details |
| :------------- | :-------------: |
|  `-v up`  | incearse volume by default 10  |
|  `-v up`  [number]  | increase volume by number inputed  |
|  `-v down` | decreases volume by default 10 |
|  `-v down` [number] | decrease volume by number inputed |
|  `-m` |  toggles mute/unmute |

Other Commands 

| Misc Commands  | Details |
| :------------- | :-------------: |
|`-art`| Opens the current song artwork in chrome|