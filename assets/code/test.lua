myState = "random_walk"
state = {}

function state.random_walk()
       -- Behavior

	sumForce = { x = 0, y = 0}
	-- Random force
   randomForce = randForce(35)
	sumForce.x = sumForce.x + randomForce.x
	sumForce.y = sumForce.y + randomForce.y

	-- Avoiding physical object
	avoidanceForce = avoidForce()
	sumForce.x = sumForce.x + avoidanceForce.x
	sumForce.y = sumForce.y + avoidanceForce.y

	speedFromForce(sumForce)

   -- Transition
    if(#robot.colored_blob_omnidirectional_camera > 0 and
        robot.colored_blob_omnidirectional_camera[1].distance > 50) then
        myState = "lover"
    end

end

function state.lover()
       -- Behavior

	sumForce = { x = 0, y = 0}
	-- Light force
	camForce = cameraForce(true,true)
	sumForce.x = sumForce.x + camForce.x
   sumForce.y = sumForce.y + camForce.y

	-- Avoiding physical object
	avoidanceForce = avoidForce()
	sumForce.x = sumForce.x + avoidanceForce.x
	sumForce.y = sumForce.y + avoidanceForce.y

	speedFromForce(sumForce)

   -- Transition
    if(#robot.colored_blob_omnidirectional_camera == 0) then
        myState = "random_walk"
    elseif(robot.colored_blob_omnidirectional_camera[1].distance <20) then
        myState = "coward"
    end
end

function state.coward()
       -- Behavior

	sumForce = { x = 0, y = 0}
	-- Light force
	camForce = cameraForce(true,true)
	sumForce.x = sumForce.x + camForce.x
   sumForce.y = sumForce.y + camForce.y

	-- Avoiding physical object
	avoidanceForce = avoidForce()
	sumForce.x = sumForce.x + avoidanceForce.x
	sumForce.y = sumForce.y + avoidanceForce.y

	speedFromForce(sumForce)

   -- Transition
    if(#robot.colored_blob_omnidirectional_camera == 0) then
        myState = "random_walk"
    else
	     if(robot.colored_blob_omnidirectional_camera[1].distance > 80) then
            myState = "random_walk"
        end
    end
end


function init()
	robot.colored_blob_omnidirectional_camera.enable()
end



function step()

    log(myState)
state[myState]()
--[[
    if(myState == "random_walk") then
	    state.random_walk()
	 elseif(myState == "lover") then
	    state.lover()
	 elseif(myState == "coward") then
	    state.coward()
    end
]]--
end



function reset()
end

function destroy()
end



function cameraForce(attraction, strong)
    camForce = {x = 0, y = 0}

    if(#robot.colored_blob_omnidirectional_camera == 0) then
        return camForce
    end

    dist = robot.colored_blob_omnidirectional_camera[1].distance
    angle = robot.colored_blob_omnidirectional_camera[1].angle

    -- Cap at 80 cm.
	 if(dist > 80) then
        return camForce
    end

--    log("dist: " .. dist)
--    log("angle: " .. angle)

    -- Strong or Weak reaction
    if(strong) then
        val = 35 * dist/80
    else
        val = 35 * (1 - dist/80)
    end

	 -- Attraction or Repulsion
    if(not attraction) then
        val = - val
    end

    camForce.x = val * math.cos(angle)
    camForce.y = val * math.sin(angle)     	
    return camForce

end


function speedFromForce(f)
    forwardSpeed = f.x * 1.0
    angularSpeed = f.y * 0.3

    leftSpeed  = forwardSpeed - angularSpeed
    rightSpeed = forwardSpeed + angularSpeed

    robot.wheels.set_velocity(leftSpeed,rightSpeed)
end

function randForce(val)
    angle = robot.random.uniform(- math.pi/2, math.pi/2)
    randomForce = {x = val * math.cos(angle), y = val * math.sin(angle) }
    return randomForce
end

function lightForce()
    valMax = 0.4
    lightAttractionForce = {x = 0, y = 0}

    for i = 1,24 do
        -- We cap the value if too low
        -- you can modify the threshold
        val = robot.light[i].value

        if(val < valMax) then
            val = 0
        end

        v = 30 * val 
        a = robot.light[i].angle

        sensorForce = {x = v * math.cos(a), y = v * math.sin(a)}
        lightAttractionForce.x = lightAttractionForce.x + sensorForce.x
        lightAttractionForce.y = lightAttractionForce.y + sensorForce.y
    end
    return lightAttractionForce
end

function avoidForce()
    avoidanceForce = {x = 0, y = 0}
    for i = 1,24 do
        -- "-100" for a strong repulsion 
        v = -100 * robot.proximity[i].value 
        a = robot.proximity[i].angle

        sensorForce = {x = v * math.cos(a), y = v * math.sin(a)}
        avoidanceForce.x = avoidanceForce.x + sensorForce.x
        avoidanceForce.y = avoidanceForce.y + sensorForce.y
    end
    return avoidanceForce
end
