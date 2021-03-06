-- Name: TAD-A2G-021 - AREAS - Remain BAI as AI
-- Author: FlightControl
-- Date Created: 20 Dec 2017
--
-- This mission demonstrates the dynamic task dispatching for Air to Ground operations.
-- This test is about checking that if a player in the air is approaching a BAI task zone, that the task is not converted to a CAS!
-- Jump into the su-25T. The AI Helicopter Attack will fly to the detected blue targets. They won't fire at the helicopters.
-- The su-34 will detect the blue targets, but will report a BAI task, even if the AI helicopters is near the targets.
-- This is a very important aspect of BAI. 
-- Only ground units should be considered as friendlies and would convert a task in CAS if near the enemy.

-- Declare the Command Center 
local HQ = GROUP
  :FindByName( "HQ", "Bravo HQ" )

local CommandCenter = COMMANDCENTER
  :New( HQ, "Lima" ) -- Create the CommandCenter.
  
-- Declare the Mission for the Command Center.
local Mission = MISSION
  :New( CommandCenter, "Overlord", "High",
        "This mission demonstrates the dynamic task dispatching for Air to Ground operations. " ..
        "This test is about a SEAD task, dispatched, that is split into a SEAD and BAI task, when units are moving away from the zone. " ..
        "While the units are moving away, monitor if the task is correctly split into a SEAD and BAI task! " ..
        "This is only applicable for AREA detections. Other detection methods won't have this dynamic.",
        coalition.side.RED ) -- Create the Mission.

-- Define the RecceSet that will detect the enemy.
local RecceSet = SET_GROUP
  :New()  -- Create the RecceSet, which is the set of groups detecting the enemy locations.
  :FilterPrefixes( "Recce" ) -- All Recce groups start with the name "Recce".
  :FilterCoalitions("red") -- only the red coalition.
  :FilterStart() -- Start the dynamic building of the set.

-- Setup the detection. We use DETECTION_AREAS to detect and group the enemies.
local DetectionAreas = DETECTION_AREAS
  :New( RecceSet, 3000 )  -- The RecceSet will detect the enemies, and group them into areas of a 3 km radius.

-- Setup the AttackSet, which is a SET_GROUP.
-- The SET_GROUP is a dynamic collection of GROUP objects.  
local AttackSet = SET_GROUP
  :New()  -- Create the SET_GROUP object.
  :FilterCoalitions( "red" ) -- Only incorporate the RED coalitions.
  :FilterPrefixes( "Attack" ) -- Only incorporate groups that start with the name Attack.
  :FilterStart() -- Start the dynamic building of the set.
  
-- Now we have everything to setup the main A2G TaskDispatcher.
TaskDispatcher = TASK_A2G_DISPATCHER
  :New( Mission, AttackSet, DetectionAreas ) -- We assign the TaskDispatcher under Mission. The AttackSet will engage the enemy and will recieve the dispatched Tasks. The DetectionAreas will report any detected enemies to the TaskDispatcher.

-- We use the MISSILETRAINER for demonstration purposes.
MissileTrainer = MISSILETRAINER:New( 100, "Missiles will be destroyed for training when they reach your plane." )
