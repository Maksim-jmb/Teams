# Teams
updated to work on Dev 1.03 build 6781

looks like some cool things coming - mess around with them this week...MasterSlot, TeamSlots, new Master event

teams menu with slots,layout,relaygroup changes     
* using team1,2 -rest just examples i'll put up a vid to show it    
    
revamped RR to work with mouse/modifiers in combination with addon clique....     
set each clique spell to global for it to work without clicking on a frame  
* ~~couple small changes in RR made this agent much more reliable - have a hard time breaking it now
* ~~running thru full dungeons without getting the WoW "Error #132" from spamming RR too fast or switching layouts to and fro quickly
* looks like there was some update to help crashes in 6781 - i switched back to dx12 and haven't had any crashes since...
* caveat if you end up using this with clique - start out RR with Mouse1/modifier for a few presses     
* starting out RR with Mouse2/modifier sometimes throws the window layout willy-nilly...work in progress     
example: main dps rotation i use shift+mouse1 so i usually start out with mouse1....mouse2/mod i have setup to heal specific chars     
     
most functions are the same as agent2, agent 5man - buttons/mouse to change layouts,RR    
cleaned up how vfx layouts start up - previous agents skipped hiding/destroying videofeeds     
 

progression from agent2/5man more details/explanations how i play and use this agent start in agent2

gui/startup video https://youtu.be/pcDT4U06MCE    
short gameplay video for driver/main focusing agent https://youtu.be/EUK8_EBAwOE     
selective healing in RR - better example then above https://youtu.be/7XA8OvVRe1g
* notes - have to mindful of your postion with main, if using just mouse+mod for RR you can select a char in the middle of the screen
* targeted the warlock in the beginning of the last video until the main was moved     
* there are ways around that with cvar/macros just don't have them on atm - here are 2 that are handy /console ActionCam can move your character down from the center     
* and toggling /console deselectOnClick can lock your target from changing when clicking in an open area

current update:
* included FTL agent
* updated BRR to the best solution i have so far for swapping to heal every other
* should probably make a reference to designate slot to healer - hard coded for slot 2 atm for the 2 groups i play currently
* good info today i learned from Lax - not always the code - some ingame settings help out using mouse buttons for RR
* might be able to clear up that mouse right click issue from above now with mouselook
