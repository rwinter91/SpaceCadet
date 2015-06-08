-- Space Cadet
-- Created By: Ryan Winter
-- Copyright 2013
--[[
>Greet Player
	- See if Player needs rules, else skip
>Rules
	- Goal
		- Reach space station Reactor to Detonate
	- Enemies
		- Blazog
	- Player Abilities
		- Move
		- Shoot
	- Items
		- Rubble
		- Health
		- Doors
		- Damage Obstacle
>Builds Space Station based on preset rooms
	- Pre-set Tables within Tables for rooms
		+ Bigger table for overall Station
>Pre-filled Space Station with enemies, player, items
>Player starts in loading bay
	- Player can shoot
		+ Shooting is unlimited
		+ Kills enemy in 1 hit
		+ Destroys Rubble
>Enemies
	- Blazog
		+ Move towards player (can move diagonally)
		+ Shoot Randomly
		+ Damages player on collision (resets player at door)
>Items
	- Rubble
		+ Blocks player movement
		+ Can be destroyed by player shooting
	- Health
		+ Activates once on pickup
		+ Restores 2 health
	- Door transfers from 1 room to another
	- Damage obstacle does 1 damage and resets player at door
> If player dies or wins
	-Print results then Exit
	
-------------------
To Add
- More enemies
- Teleporters
- Bombs
- Extra Art

]]--
--Global Variables
	-- Map --
numMapWidth = 3
numMapHeight = 2
	
	-- Rooms --
numArenaLength = 24
numArenaWidth = 40
strArenaTexture = " "
strArenaWall = string.char( 219 )
strArenaDoor = "0"
strObstacle = "%"
strEmptySpace = " "
strObjective = "$"

	-- Player --
isPlayerAlive = true
isWon = false
isAtDoor = false
numPlayerLives = 5
numPlayerSpeed = 1 
strPlayerIcon = string.char( 232 )
numPlayerX = 5
numPlayerY = 8
numPreviousX = 0
numPreviousY = 0
numPlayerRoomY = 2
numPlayerRoomX = 1

	-- Bullet --
numBulletY = 0
numBulletX = 0
strBullet = '~'

	-- Items --
strHealth = "+"
numHealthRegen = 2
strTeleporter = "#"

	-- Blazog --
strBlazogIcon = string.char( 234 )
strBlazogDead = "*"
numBlazogX = 20
numBlazogY = 10

	-- BlazogBullet --
isBlazogAlive = true
numBlazogBulletY = 0
numBlazogBulletX = 0
strBlazogBullet = '"'

	-- Mechanical --
isWantRules = false
isWantToPlay = true


	
--Functions
function initRNG()
	math.randomseed(os.time())
	math.random()
	math.random()
	math.random()
	math.random()
	math.random()
	math.random()
end

function greetPlayer()
	os.execute( "cls" )

	print( "Space Cadet!!!" )
	print( "----------------------------------" )
	print( "Do you want to hear the rules? y/n" )

	repeat
		strWantRules = io.read()
		
		if( strWantRules == "y" )then
			isWantRules = true
			
		elseif( strWantRules == "n" )then
			isWantRules = false
			
		else
			isWantRules = nil
			print( "-Press 'y' then 'ENTER' if you want to hear the rules")
			print( "-Press 'n' then 'ENTER' otherwise")
			
		end
		
	until( isWantRules ~= nil )

end

function tellRules()

	os.execute( "cls" )

	print( "Prepare to save the world!" )
	print( "--------------------------------------" )
	print( "1) The goal is to reach the the reactor core" )
	print( "	- It is made up of these: [ "..strObjective.." ]" )
	print( "	- You have only "..numPlayerLives.." health to get there" )
	print()
	print( "2) You control the player [ "..strPlayerIcon.." ]" )
	print( "	-Type 'w' then 'enter' to move up" )
	print( "	-Type 's' then 'enter' to move down" )
	print( "	-Type 'a' then 'enter' to move left" )
	print( "	-Type 'd' then 'enter' to move right" )
	print()
	print( "2) You can shoot your phaser by typing 'l' and a directional button" )
	print( "	-Type 'lw' then 'enter' to shoot up" )
	print( "	-Type 'ls' then 'enter' to shoot down" )
	print( "	-Type 'la' then 'enter' to shoot left" )
	print( "	-Type 'ld' then 'enter' to shoot right" )
	print()
	print( "3) The Blazog will try to attack you" )
	print( "	-The Blazog,[ "..strBlazogIcon.." ], move towards you and shoot their lasers randomly" )
	print( "\n--Press Enter to continue" )
	io.read()
	
	os.execute( "cls" )

	print( "4) Avoid super-heated pipes [ "..strObstacle.." ] and enemies, [ "..strBlazogIcon.." ]"  )
	print( "	-If you run into these, you will lose 1 health")
	print()
	print( "5) Med-packs, [ "..strHealth.." ], regenerate "..numHealthRegen.." health" )
	print()
	print( "6) Use your phasers to blast through rubble, [ "..strBlazogDead.." ], and open new pathways" )
	print()
	print( "7) Use doors, [ "..strArenaDoor.." ], to move from room to room" )
	print( "	-Hint: the Reactor is in the upper left room" )
	print()
	print( "**Type 'rules' while playing to see these rules again**" )
	print( "\n--Press Enter to continue" )
	
	io.read()
	
end

function buildMap()
	tblMap = {}
	
	for i = 1 , numMapHeight do
		tblMap[ i ] = {}
		
		for j = 1 , numMapWidth do
			tblMap[ i ][ j ] = {}
			insertRoom( tblMap , i , j )
		end
	end
	
	return( tblMap )
end

--This is where the room maps live
function insertRoom( tblMap , i , j )
	tblRoom = {}
	--Makes icons easier to put into tables (MUST REFER TO STRINGS)
	X = strArenaWall
	H = strArenaTexture
	O = strArenaDoor
	E = strEmptySpace
	B = strBlazogIcon
	U = strHealth
	K = strObstacle
	R = strBlazogDead
	Y = strObjective
	
	if( i == 1 )and( j == 1 )then
	--Top Left( Final Room - Reactor Core)
		tblRoom[ 1 ] =	{ E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E }
		tblRoom[ 2 ] =	{ E , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , E }
		tblRoom[ 3 ] =	{ E , X , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , R , H , H , H , H , H , H , H , H , H , H , H , H , H , H , X , E }
		tblRoom[ 4 ] =	{ E , X , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , R , H , H , H , H , H , H , H , H , H , H , H , H , H , H , X , E }
		tblRoom[ 5 ] =	{ E , X , H , H , H , H , H , H , H , H , H , K , H , H , H , H , H , H , H , H , H , H , H , K , K , H , H , H , H , H , H , H , H , H , H , H , H , H , X , E }
		tblRoom[ 6 ] =	{ E , X , H , H , H , H , H , H , H , H , H , K , H , H , H , H , H , H , H , H , H , H , H , K , K , H , H , H , H , H , H , H , H , H , H , H , H , H , X , E }
		tblRoom[ 7 ] =	{ E , X , H , H , H , H , H , H , H , H , H , K , H , H , H , H , H , H , H , H , H , H , H , K , K , H , H , H , H , H , H , H , H , H , H , H , H , H , X , E }
		tblRoom[ 8 ] =	{ E , X , H , H , H , H , H , H , H , H , H , K , H , H , H , H , H , H , H , H , H , H , H , R , H , H , H , H , H , H , H , H , H , H , H , H , H , H , X , E }
		tblRoom[ 9 ] =	{ E , X , H , H , Y , Y , Y , Y , Y , H , H , K , H , H , H , H , H , H , H , H , H , H , H , R , H , H , H , H , H , H , H , H , H , H , H , H , H , H , X , X }
		tblRoom[ 10 ] =	{ E , X , H , H , Y , Y , Y , Y , Y , H , H , K , H , H , H , H , H , H , H , H , H , B , H , R , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , O }
		tblRoom[ 11 ] =	{ E , X , H , H , Y , Y , Y , Y , Y , H , H , K , H , H , H , H , H , H , H , H , H , H , H , K , K , H , H , H , H , H , H , H , H , H , H , H , H , H , H , O }
		tblRoom[ 12 ] =	{ E , X , H , H , Y , Y , Y , Y , Y , H , H , K , H , H , H , H , H , H , H , H , H , H , H , K , K , H , H , H , H , H , H , H , H , H , H , H , H , H , X , X }
		tblRoom[ 13 ] =	{ E , X , H , H , H , H , H , H , H , H , H , K , H , H , H , H , H , H , H , H , H , H , H , K , K , H , H , H , H , H , H , H , H , H , H , H , H , H , X , E }
		tblRoom[ 14 ] =	{ E , X , H , H , H , H , H , H , H , H , H , K , H , H , H , H , H , H , H , H , H , H , H , K , K , H , H , H , H , H , H , H , H , H , H , H , H , H , X , E }
		tblRoom[ 15 ] =	{ E , X , H , H , H , H , H , H , H , H , H , K , H , H , H , H , H , H , H , H , H , H , H , K , K , H , H , H , H , H , H , H , H , H , H , H , H , H , X , E }
		tblRoom[ 16 ] =	{ E , X , H , H , H , H , H , H , H , H , H , K , H , H , H , H , H , H , H , H , H , H , H , K , K , H , H , H , H , H , H , H , H , H , H , H , H , H , X , E }
		tblRoom[ 17 ] =	{ E , X , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , K , K , H , H , H , H , H , H , H , H , H , H , H , H , H , X , E }
		tblRoom[ 18 ] =	{ E , X , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , R , H , H , H , H , H , H , H , H , H , H , H , H , H , X , E }
		tblRoom[ 19 ] =	{ E , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , E }
		tblRoom[ 20 ] =	{ E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E }
	
	elseif( i == 1 )and( j == 2 )then
	--Top Middle(Teleportation Bay)
		tblRoom[ 1 ] =	{ E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E }
		tblRoom[ 2 ] =	{ E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E }
		tblRoom[ 3 ] =	{ E , E , E , E , E , E , E , E , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , E , E , E , E , E , E , E , E , E , E }
		tblRoom[ 4 ] =	{ E , E , E , E , E , E , E , E , X , H , H , H , H , R , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , X , E , E , E , E , E , E , E , E , E , E }
		tblRoom[ 5 ] =	{ E , E , E , E , E , E , E , E , X , H , H , H , H , R , H , H , H , H , H , H , H , H , H , H , H , H , U , H , H , X , E , E , E , E , E , E , E , E , E , E }
		tblRoom[ 6 ] =	{ E , E , E , E , E , E , E , E , X , H , H , H , H , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , E , E , E , E , E , E , E , E , E , E }
		tblRoom[ 7 ] =	{ E , E , E , E , E , E , E , E , X , H , H , H , H , X , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E }
		tblRoom[ 8 ] =	{ E , E , E , E , E , E , E , E , X , H , H , H , H , X , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E }
		tblRoom[ 9 ] =	{ X , X , X , X , X , X , X , X , X , H , H , H , H , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X }
		tblRoom[ 10 ] =	{ O , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , O }
		tblRoom[ 11 ] =	{ O , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , X , X , X , X , X , X , X , X , X }
		tblRoom[ 12 ] =	{ X , X , X , X , X , X , X , X , X , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , X , E , E , E , E , E , E , E , E }
		tblRoom[ 13 ] =	{ E , E , E , E , E , E , E , E , X , H , H , H , H , K , K , H , H , H , H , H , H , H , K , K , H , H , H , H , H , H , H , X , E , E , E , E , E , E , E , E }
		tblRoom[ 14 ] =	{ E , E , E , E , E , E , E , E , X , H , H , H , H , K , K , H , H , H , H , H , H , H , K , K , H , H , H , H , H , H , H , X , E , E , E , E , E , E , E , E }
		tblRoom[ 15 ] =	{ E , E , E , E , E , E , E , E , X , H , H , H , H , K , K , H , H , H , H , H , H , H , K , K , H , H , H , H , H , H , H , X , E , E , E , E , E , E , E , E }
		tblRoom[ 16 ] =	{ E , E , E , E , E , E , E , E , X , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , X , X , X , X , X , X , X , X , X }
		tblRoom[ 17 ] =	{ E , E , E , E , E , E , E , E , X , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , O }
		tblRoom[ 18 ] =	{ E , E , E , E , E , E , E , E , X , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , X , X , X , X , X , X , X , X , X }
		tblRoom[ 19 ] =	{ E , E , E , E , E , E , E , E , X , H , H , H , H , H , H , H , H , H , H , B , H , H , H , H , H , H , H , H , H , H , H , X , E , E , E , E , E , E , E , E }
		tblRoom[ 20 ] =	{ E , E , E , E , E , E , E , E , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , E , E , E , E , E , E , E , E }
	
	elseif( i == 1 )and( j == 3 )then
	--Top Right(Weapons)
		tblRoom[ 1 ] =	{ E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E }
		tblRoom[ 2 ] =	{ E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E }
		tblRoom[ 3 ] =	{ X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E }
		tblRoom[ 4 ] =	{ X , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , U , X , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E }
		tblRoom[ 5 ] =	{ X , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , X , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E }
		tblRoom[ 6 ] =	{ X , H , H , H , H , H , H , H , R , H , H , H , H , H , H , H , H , X , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E }
		tblRoom[ 7 ] =	{ X , H , H , H , H , H , H , H , H , H , R , H , H , H , B , H , H , X , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E }
		tblRoom[ 8 ] =	{ X , H , H , H , R , H , H , H , H , H , H , H , H , H , H , H , H , X , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E }
		tblRoom[ 9 ] =	{ X , H , H , H , H , R , H , H , R , H , H , H , H , H , H , H , H , X , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E }
		tblRoom[ 10 ] =	{ O , H , H , H , H , R , H , H , H , H , R , H , R , H , H , H , H , X , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E }
		tblRoom[ 11 ] =	{ X , H , H , H , H , H , R , H , H , H , H , H , H , H , H , H , H , X , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E }
		tblRoom[ 12 ] =	{ X , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , X , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E }
		tblRoom[ 13 ] =	{ X , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , X , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E }
		tblRoom[ 14 ] =	{ X , X , X , X , X , X , X , X , X , X , H , H , X , X , X , X , X , X , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E }
		tblRoom[ 15 ] =	{ E , E , E , E , E , E , E , E , E , X , H , H , X , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E }
		tblRoom[ 16 ] =	{ X , X , X , X , X , X , X , X , X , X , H , H , X , X , X , X , X , X , X , X , X , X , X , X , X , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E }
		tblRoom[ 17 ] =	{ O , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , X , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E }
		tblRoom[ 18 ] =	{ X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , H , H , X , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E }
		tblRoom[ 19 ] =	{ E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , X , H , H , X , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E }
		tblRoom[ 20 ] =	{ E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , X , O , O , X , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E }
	
	elseif( i == 2 )and( j == 1 )then
	--Bottom Left(Beginning Room - Storage Room)
		tblRoom[ 1 ] =	{ E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E }
		tblRoom[ 2 ] =	{ E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E }
		tblRoom[ 3 ] =	{ X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , E , E , E , E , E , E , E , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X }
		tblRoom[ 4 ] =	{ X , H , H , H , H , H , H , H , H , H , H , H , H , H , X , E , E , E , E , E , E , E , X , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , X }
		tblRoom[ 5 ] =	{ X , H , H , H , H , H , H , H , H , H , H , H , H , H , X , E , E , E , E , E , E , E , X , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , X }
		tblRoom[ 6 ] =	{ X , H , H , H , H , H , H , H , H , H , H , H , H , H , X , E , E , E , E , E , E , E , X , H , H , H , H , H , K , K , H , H , H , H , H , H , H , H , H , O }
		tblRoom[ 7 ] =	{ X , H , H , H , H , H , H , H , H , H , H , H , H , H , X , X , X , X , X , X , X , X , X , H , H , H , H , H , K , K , H , H , H , H , H , H , H , H , H , X }
		tblRoom[ 8 ] =	{ X , H , H , H , H , H , H , H , H , H , H , H , H , H , R , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , X }
		tblRoom[ 9 ] =	{ X , H , H , H , H , H , H , H , H , H , H , H , H , H , R , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , K , K , H , H , H , H , X }
		tblRoom[ 10 ] =	{ X , H , H , H , H , H , H , H , H , H , H , H , H , H , X , X , X , X , X , X , X , X , X , H , H , H , H , H , H , H , H , H , H , K , K , H , H , H , H , X }
		tblRoom[ 11 ] =	{ X , H , H , H , H , H , H , H , H , H , H , H , H , H , X , E , E , E , E , E , E , E , X , H , H , H , H , H , H , H , H , H , H , K , K , H , H , H , H , X }
		tblRoom[ 12 ] =	{ X , H , H , H , H , H , H , H , H , H , H , H , H , H , X , E , E , E , E , E , E , E , X , H , H , H , H , H , H , B , H , H , H , H , H , H , H , H , H , X }
		tblRoom[ 13 ] =	{ X , H , H , H , H , H , H , H , H , H , H , H , H , H , X , E , E , E , E , E , E , E , X , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , X }
		tblRoom[ 14 ] =	{ X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , E , E , E , E , E , E , E , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X }
		tblRoom[ 15 ] =	{ E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E }
		tblRoom[ 16 ] =	{ E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E }
		tblRoom[ 17 ] =	{ E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E }
		tblRoom[ 18 ] =	{ E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E }
		tblRoom[ 19 ] =	{ E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E }
		tblRoom[ 20 ] =	{ E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E }
	
	elseif( i == 2 )and( j == 2 )then
	--Bottom Middle (Damaged Room)
		tblRoom[ 1 ] =	{ E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , X , X , X , X , X , X , X , X , X , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E }
		tblRoom[ 2 ] =	{ E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , X , H , H , H , H , H , H , H , X , X , X , X , X , X , X , X , X , E , E , E , E , E , E , E , E }
		tblRoom[ 3 ] =	{ E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , X , H , H , H , H , H , H , H , R , H , H , H , H , H , U , H , X , E , E , E , E , E , E , E , E }
		tblRoom[ 4 ] =	{ E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , X , H , H , H , H , H , H , H , X , X , X , X , X , X , X , X , X , E , E , E , E , E , E , E , E }
		tblRoom[ 5 ] =	{ X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , H , H , H , H , H , H , H , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X }
		tblRoom[ 6 ] =	{ O , H , H , H , H , H , H , H , H , K , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , K , H , H , H , H , H , H , H , H , H , H , X }
		tblRoom[ 7 ] =	{ X , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , X }
		tblRoom[ 8 ] =	{ X , H , H , H , H , H , H , H , H , H , K , H , H , H , H , H , H , H , B , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , O }
		tblRoom[ 9 ] =	{ X , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , K , H , H , H , H , H , H , H , H , H , H , H , H , H , X }
		tblRoom[ 10 ] =	{ X , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , X }
		tblRoom[ 11 ] =	{ X , H , H , H , H , H , H , H , H , H , H , K , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , X }
		tblRoom[ 12 ] =	{ X , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , X }
		tblRoom[ 13 ] =	{ X , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , K , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , X }
		tblRoom[ 14 ] =	{ X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X }
		tblRoom[ 15 ] =	{ E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , X , H , H , H , H , H , H , H , H , H , X }
		tblRoom[ 16 ] =	{ E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , X , H , H , H , U , H , H , H , H , H , X }
		tblRoom[ 17 ] =	{ E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , X , H , H , H , H , H , H , H , H , H , O }
		tblRoom[ 18 ] =	{ E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , X , H , H , H , H , H , H , H , H , H , X }
		tblRoom[ 19 ] =	{ E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , X , X , X , X , X , X , X , X , X , X , X }
		tblRoom[ 20 ] =	{ E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E }
	
	elseif( i == 2 )and( j == 3 )then
	--Bottom Right(Cockpit)
		tblRoom[ 1 ] =	{ E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , X , O , X , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E }
		tblRoom[ 2 ] =	{ X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , H , X , X , X , X , X , X , X , X , E , E , E , E , E , E , E , E , E }
		tblRoom[ 3 ] =	{ X , H , H , H , H , H , H , H , H , H , H , H , H , K , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , X , X , X , E , E , E , E , E , E , E }
		tblRoom[ 4 ] =	{ X , H , H , H , H , H , H , H , H , H , H , H , H , K , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , X , X , X , E , E , E , E , E }
		tblRoom[ 5 ] =	{ X , H , H , H , H , H , H , H , H , H , H , H , H , K , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , X , X , X , E , E , E }
		tblRoom[ 6 ] =	{ X , H , H , H , H , H , H , H , H , H , H , H , H , K , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , X , X , X , E }
		tblRoom[ 7 ] =	{ X , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , X , X }
		tblRoom[ 8 ] =	{ O , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , X , X }
		tblRoom[ 9 ] =	{ X , H , H , H , H , H , H , H , H , H , H , H , H , K , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , X , X , X , E }
		tblRoom[ 10 ] =	{ X , H , H , H , H , H , H , H , H , H , H , H , H , K , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , X , X , X , E , E , E }
		tblRoom[ 11 ] =	{ X , H , H , H , H , H , H , H , H , H , H , H , H , K , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , X , X , X , E , E , E , E , E }
		tblRoom[ 12 ] =	{ X , H , H , H , H , H , H , H , H , H , H , H , H , K , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , H , X , X , X , E , E , E , E , E , E , E }
		tblRoom[ 13 ] =	{ X , X , X , X , X , X , X , X , X , X , R , R , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , E , E , E , E , E , E , E , E , E }
		tblRoom[ 14 ] =	{ E , E , E , E , E , E , E , E , E , X , H , H , X , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E }
		tblRoom[ 15 ] =	{ E , E , E , X , X , X , X , X , X , X , H , H , X , X , X , X , X , X , X , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E }
		tblRoom[ 16 ] =	{ X , X , X , X , H , H , H , H , H , H , H , H , H , H , H , H , H , H , X , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E }
		tblRoom[ 17 ] =	{ O , H , H , H , H , H , H , H , H , H , H , H , H , H , B , H , H , H , X , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E }
		tblRoom[ 18 ] =	{ X , X , X , X , H , H , H , H , H , H , H , H , H , H , H , H , H , H , X , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E }
		tblRoom[ 19 ] =	{ E , E , E , X , H , H , H , H , H , H , H , H , H , H , H , H , H , H , X , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E }
		tblRoom[ 20 ] =	{ E , E , E , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , X , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E , E }
	end
	
	tblMap[ i ][ j ] = tblRoom
	
end

function printArena( tblArena )
	os.execute( "cls" )
	
	--Prints individual strings in tblArena as rows of strings
	for i = 1 , table.getn( tblArena )do
		strTempRow = ""
		
		for j = 1 , table.getn( tblArena[ i ] )do
			strTempRow = strTempRow..tblArena[ i ][ j ] 
		end
		
		print( strTempRow )
	end
	
end

--Transfers player from room to room after they reach a door
function changeRoom()
	tblCurrentRoom[ numPlayerY ][ numPlayerX ] = strArenaDoor
	
	if( numPlayerX == numArenaWidth )then
		numPlayerRoomX = numPlayerRoomX + 1
		numPlayerX = 2
	
	elseif( numPlayerX == 1 )then
		numPlayerRoomX = numPlayerRoomX - 1
		numPlayerX = numArenaWidth - 1
		
	elseif( numPlayerY == 1)then
		numPlayerRoomY = numPlayerRoomY - 1
		numPlayerY = numArenaLength - 1
	
	elseif( numPlayerY == numArenaLength )then
		numPlayerRoomY = numPlayerRoomY + 1
		numPlayerY = 2
		
	end

end

--Checks what the player collides with after moving and acts accordingly
function playerCollision(tblArena)
	-- Sees if player has reached a door
	if( tblArena[ numPlayerY ][ numPlayerX ] == strArenaDoor )then
		isAtDoor = true
		
	--Health Powerup	
	elseif( tblArena[ numPlayerY ][ numPlayerX ] == strHealth )then
		numPlayerLives = numPlayerLives + numHealthRegen
		tblArena[ numPlayerY ][ numPlayerX ] = strPlayerIcon
	
	--Prevents Players from moving over walls or corpses
	elseif( tblArena[ numPlayerY ][ numPlayerX ] == strArenaWall )or( tblArena[ numPlayerY ][ numPlayerX ] == strBlazogDead )then
		print( "-----You can't walk over that!-----" )
		numPlayerY = numPreviousY
		numPlayerX = numPreviousX
		tblArena[ numPlayerY ][ numPlayerX ] = strPlayerIcon
		
		numWait = os.clock() + 1
		while( os.clock() < numWait )do
		end
	
	--Checks to see if player has reached the goal
	elseif(	tblArena[ numPlayerY ][ numPlayerX ] == strObjective )then
		isWon = true
	
	-- Makes sure player is moving into a valid location, if not -1 life and player position resets
	elseif( tblArena[ numPlayerY ][ numPlayerX ] ~= strArenaTexture )and( tblArena[ numPlayerY ][ numPlayerX ] ~= strPlayerIcon )then
		numPlayerLives = numPlayerLives - 1
		numPlayerX = numStartX
		numPlayerY = numStartY
		tblArena[ numPlayerY ][ numPlayerX ] = strPlayerIcon
		
	else
		tblArena[ numPlayerY ][ numPlayerX ] = strPlayerIcon
	
	end
end

-- Allows the player to move or shoot
function playerMove( tblArena )
	--Indexes previous location in case player can't move to new location
	numPreviousX = numPlayerX
	numPreviousY = numPlayerY
	
	--Moves player to new location (WASD controls) or shoots ( "l" + WASD)
	repeat
		isMoved = false
		os.execute( "cls" )
		tblArena[ numPlayerY ][ numPlayerX ] = strPlayerIcon
		printArena( tblArena )
		
		--Gets Player's move
		io.write( "[Health: "..numPlayerLives.."] 		Player Move: " )
		strMove = io.read()
		
		if( strMove == "rules" )then
			tellRules()
		
		elseif( strMove == "w" )then
			tblArena[ numPlayerY ][ numPlayerX ] = strArenaTexture
			numPlayerY = numPlayerY - numPlayerSpeed
			isMoved = true
			
		elseif( strMove == "s" )then
			tblArena[ numPlayerY ][ numPlayerX ] = strArenaTexture
			numPlayerY = numPlayerY + numPlayerSpeed
			isMoved = true
			
		elseif( strMove == "a" )then
			tblArena[ numPlayerY ][ numPlayerX ] = strArenaTexture
			numPlayerX = numPlayerX - numPlayerSpeed
			isMoved = true
			
		elseif( strMove == "d" )then
			tblArena[ numPlayerY ][ numPlayerX ] = strArenaTexture
			numPlayerX = numPlayerX + numPlayerSpeed
			isMoved = true
			
		elseif( strMove == "lw" )then
			playerShoot( tblArena , "up" )
			tblArena[ numPlayerY ][ numPlayerX ] = strPlayerIcon
			isMoved = true
			
		elseif( strMove == "ls" )then
			playerShoot( tblArena , "down" )
			tblArena[ numPlayerY ][ numPlayerX ] = strPlayerIcon
			isMoved = true
			
		elseif( strMove == "la" )then
			playerShoot( tblArena , "left" )
			tblArena[ numPlayerY ][ numPlayerX ] = strPlayerIcon
			isMoved = true
			
		elseif( strMove == "ld" )then
			playerShoot( tblArena , "right" )
			tblArena[ numPlayerY ][ numPlayerX ] = strPlayerIcon
			isMoved = true
			
		else
			repeat
				tblArena[ numPlayerY ][ numPlayerX ] = strArenaTexture
				io.write( "Are you sure you don't want to move?(y/n)" )
				strNoMove = io.read() 
				
			until( strNoMove == "y" )or( strNoMove == "n" )
			
		end
		
	until( strNoMove == "y" )or( isMoved )
	
	playerCollision( tblArena )
	
end

--strDirection must be a string of: up, down, left, or right
function playerShoot( tblArena , strDirection )
	isHit = false
	numBulletY = numPlayerY
	numBulletX = numPlayerX
	
	repeat
		--shoots bullet in direction passed in by player
		if( strDirection == "up" )then
			tblArena[ numBulletY ][ numBulletX ] = strArenaTexture
			numBulletY = numBulletY - 1
			
		elseif( strDirection == "down" )then
			tblArena[ numBulletY ][ numBulletX ] = strArenaTexture
			numBulletY = numBulletY + 1
		
		elseif( strDirection == "left" )then
			tblArena[ numBulletY ][ numBulletX ] = strArenaTexture
			numBulletX = numBulletX - 1
		
		elseif( strDirection == "right" )then
			tblArena[ numBulletY ][ numBulletX ] = strArenaTexture
			numBulletX = numBulletX + 1
		
		end
		
		tblArena[ numPlayerY ][ numPlayerX ] = strPlayerIcon
		
		-- See if bullet hits Blazog
		if( tblArena[ numBulletY ][ numBulletX ] == strBlazogIcon )then
			tblArena[ numBulletY ][ numBulletX ] = strBlazogDead
			
			isBlazogAlive = false
			isHit = true
		
		--Player can rubble to destroy it
		elseif( tblArena[ numBulletY ][ numBulletX ] == strBlazogDead )then
			tblArena[ numBulletY ][ numBulletX ] = strBullet
			
		-- stops bullet if it hits a wall or the top
		elseif( tblArena[ numBulletY ][ numBulletX ] ~= strArenaTexture )then
			isHit = true
		
		else
			tblArena[ numBulletY ][ numBulletX ] = strBullet
			
		end
		
		printArena( tblArena )
		numWait = os.clock() + 0.03
		while( os.clock() < numWait )do
		end
	
	until( isHit )
	
end

--Like playermove, but automated
function blazogMove( tblArena )
	--Checks if enemy is alive
	if( isBlazogAlive )then
		
		--Indexes previous location
		numBlazogPreviousX = numBlazogX
		numBlazogPreviousY = numBlazogY
	
		--Moves blazog towards player (can move diagonally)
		if( numPlayerY < numBlazogY )and( tblArena[ numBlazogY - 1 ][ numBlazogX ] == strArenaTexture )then
			tblArena[ numBlazogY ][ numBlazogX ] = strArenaTexture
			numBlazogY = numBlazogY - 1
			
		end
		if( numPlayerY > numBlazogY )and( tblArena[ numBlazogY + 1 ][ numBlazogX ] == strArenaTexture )then
			tblArena[ numBlazogY ][ numBlazogX ] = strArenaTexture
			numBlazogY = numBlazogY + 1
		
		end
		if( numPlayerX < numBlazogX )and( tblArena[ numBlazogY ][ numBlazogX - 1 ] == strArenaTexture )then
			tblArena[ numBlazogY ][ numBlazogX ] = strArenaTexture
			numBlazogX = numBlazogX - 1
		
		end
		if( numPlayerX > numBlazogX )and( tblArena[ numBlazogY ][ numBlazogX + 1 ] == strArenaTexture )then
			tblArena[ numBlazogY ][ numBlazogX ] = strArenaTexture
			numBlazogX = numBlazogX + 1
		
		end
		
		-- See if blazog hit player
		if( tblArena[ numBlazogY ][ numBlazogX ] == strPlayerIcon )then
			numPlayerX = numStartX
			numPlayerY = numStartY
			tblArena[ numPlayerY ][ numPlayerX ] = strPlayerIcon
			
			numPlayerLives = numPlayerLives - 1
		
		-- Makes sure character is moving into a valid location, if not the character just waits
		elseif( tblArena[ numBlazogY ][ numBlazogX ] ~= strArenaTexture )then
			numBlazogX = numBlazogPreviousX
			numBlazogY = numBlazogPreviousY
		
		end
		
		tblArena[ numBlazogY ][ numBlazogX ] = strBlazogIcon
		printArena( tblArena )
		
		blazogShoot( tblArena )
		tblArena[ numBlazogY ][ numBlazogX ] = strBlazogIcon
	end
end

--like playerShoot, but automated and random
function blazogShoot( tblArena )
	initRNG()
	randomShoot = math.random( 1 , 20 )
	isHit = false
	numBlazogBulletY = numBlazogY
	numBlazogBulletX = numBlazogX
	
	repeat
		--shoots bullet in Random Direction
		if( randomShoot <= 5 )then
			tblArena[ numBlazogBulletY ][ numBlazogBulletX ] = strArenaTexture
			numBlazogBulletY = numBlazogBulletY - 1
			
		elseif( randomShoot >= 6 )and( randomShoot <= 10 )then
			tblArena[ numBlazogBulletY ][ numBlazogBulletX ] = strArenaTexture
			numBlazogBulletY = numBlazogBulletY + 1
		
		elseif( randomShoot >= 11 )and( randomShoot <= 15 )then
			tblArena[ numBlazogBulletY ][ numBlazogBulletX ] = strArenaTexture
			numBlazogBulletX = numBlazogBulletX - 1
		
		elseif( randomShoot >= 16 )then
			tblArena[ numBlazogBulletY ][ numBlazogBulletX ] = strArenaTexture
			numBlazogBulletX = numBlazogBulletX + 1
		
		end
		
		tblArena[ numBlazogY ][ numBlazogX ] = strBlazogIcon
		
		-- See if bullet hits player
		if( tblArena[ numBlazogBulletY ][ numBlazogBulletX ] == strPlayerIcon )then
			numPlayerX = numStartX
			numPlayerY = numStartY
			tblArena[ numPlayerY ][ numPlayerX ] = strPlayerIcon
			tblArena[ numBlazogBulletY ][ numBlazogBulletX ] = strArenaTexture
			
			numPlayerLives = numPlayerLives - 1
			isHit = true
			
		-- stops bullet if it hits a wall or the Door
		elseif( tblArena[ numBlazogBulletY ][ numBlazogBulletX ] ~= strArenaTexture )then
			isHit = true
		
		else
			tblArena[ numBlazogBulletY ][ numBlazogBulletX ] = strBlazogBullet
			
		end
		
		printArena( tblArena )
		numWait = os.clock() + 0.03
		while( os.clock() < numWait )do
		end
	
	until( isHit )
	
end

-- Finds enemy in the room, sets coordinates accordingly, and places in room
function findBlazog( tblArena )
	isBlazogInArena = false

	for i = 1 , table.getn( tblArena ) do
		for j = 1 , table.getn( tblArena[ i ] ) do
			if tblArena[ i ][ j ] == strBlazogIcon then
				numBlazogY = i
				numBlazogX = j
				isBlazogInArena = true
				isBlazogAlive = true
				tblArena[ numBlazogY ][ numBlazogX ] = strBlazogIcon
				
			elseif( isBlazogInArena == false )then
				isBlazogAlive = false
				
			end
		end
	end
end

function playerWon()
	os.execute( "cls" )
	print()
	print( "\\\\\\||||///" )
	print( "-You Win!-" )
	print( "///||||\\\\\\" )
	print()
	print( "Congratulations Cadet! You've saved planet earth." )
	print()
	print( "--Press Enter" )
	io.read()
end

function playerLost()
	os.execute( "cls" )
	print()
	print( "##########" )
	print( "#You Lose#" )
	print( "##########" )
	print()
	print( "The world is doomed because of your failure." )
	print()
	print( "--Press Enter" )
	io.read()
end

--Main Block
do
	greetPlayer()
	
	if( isWantRules )then
		tellRules()
	end
	
	tblSpaceStation = buildMap()
	repeat
		--Takes out current room
		tblCurrentRoom = tblSpaceStation[ numPlayerRoomY ][ numPlayerRoomX ]
		
		--These help reset player
		numStartX = numPlayerX
		numStartY = numPlayerY
		
		--places characters in room and resets variables
		tblCurrentRoom[ numPlayerY ][ numPlayerX ] = strPlayerIcon
		findBlazog( tblCurrentRoom )
		isAtDoor = false
		
		numArenaLength = table.getn( tblCurrentRoom )
		numArenaWidth = table.getn( tblCurrentRoom[ 1 ] )
		
		--Playing in room happens here
		repeat
			playerMove( tblCurrentRoom )
			printArena( tblCurrentRoom )
			blazogMove( tblCurrentRoom )
			
			if( numPlayerLives < 1 )then
				isPlayerAlive = false
			end
			
		until( isPlayerAlive == false )or( isAtDoor )or( isWon )
		
		--Puts current room back in
		tblSpaceStation[ numPlayerRoomY ][ numPlayerRoomX ] = tblCurrentRoom
		
		--Detects which wall door is on and moves player to adjacent room
		if( isAtDoor )then
			
			changeRoom()
			
		end
	
	until( isPlayerAlive == false )or( isWon )
	
	if( isWon )then
		playerWon()
		
	else
		playerLost()
		
	end
	
end
