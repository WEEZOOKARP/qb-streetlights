# qb-streetlights

# Compacted
This is a compacted version of the original resource that allows you to just slot it into qb-smallresources/client to reduce the number of resources on your server and therefore make it less daunting for new players who see your resource count.

# Police
Police have the ability to press G (while in an emergency vehicle) to draw a line which must be hovered over the traffic light pole. This will change the traffic light to green.

<i>It <b>DOES NOT</b> change the NPC traffic patterns.</i>

# Automatic Object Deletion
This is done by the QBCore.Functions.GetObjects() function. Every 2 seconds it runs a check and will delete any object that has less than 1000 health (which is max health). The <b><i>blacklist.lua</i></b> file is a list of items you <b>DO NOT</b> want to be deleted.
