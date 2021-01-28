# Teams
updated to work on Dev 1.03 build 6778

changed some references from agent2/5man to get it to work on Dev 1.03 - might work on 1.02, haven't tested it tho

waiting to see what teams api will do - only thing i see atm with :AddTeam[json] is id,display_name,virtual files - tried to add a team name to no avail....    
can't find much on schema, only see a reference in the agent schema to teams...so not sure how it works yet     

did mess around and put in teams with slots,layout,relaygroup changes     
* using team1,2 -rest just examples i'll put up a vid to show it    
    
revamped RR to work with mouse/modifiers in combination with addon clique....have to set each clique to global for it to work   
* couple small changes in RR made this agent much more reliable - have a hard time breaking it now     
* running thru full dungeons without getting the "Error #132" from spamming RR too fast or switching layouts to and fro quickly
* caveat if you end up using this with clique - start out RR with Mouse1/modifier for a few presses
* starting out RR with Mouse2/modifier sometimes throws the window layout willy-nilly...work in progress
     
most functions are the same as agent2, agent 5man - buttons/mouse to change layouts,RR    
cleaned up how vfx layouts start up - previous agents skipped hiding/destroying videofeeds     
started to see if I could do anything with Flipper Agent - but with modifiers/mouse - its easy to heal any char now without swapping out of RR    
so i'm only utilizing half of the flipper code atm for a quick switch to heals, shift global hotkey is also for quick switch to heal/layout swap

still messing with obs settings - little blurry yet - if anyone has any clear settings for 2 monitor wide recording down to typical aspect ratio let me know     
in the consoles-I was showing relaygroups switch with team selection     
https://youtu.be/dOl1vqRCN-4
