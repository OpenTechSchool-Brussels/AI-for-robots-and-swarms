-- Put your global variables here



--[[ This function is executed every time you press the 'execute'
     button ]]
function init()
   -- put your code here
end

function dump(o)
	if type(o) == 'table' then
		local s = '{ '
		for k,v in pairs(o) do
			if type(k) ~= 'number' then k = '"'..k..'"' end
			s = s .. '['..k..'] = ' .. dump(v) .. ','
		end
		return s .. '} '
	else
		return tostring(o)
	end
end

--[[ This function is executed at each time step
     It must contain the logic of your controller ]]
function step()

--[[	
    sumForce = { x = 0, y = 0}
    for i = 1,24 do
        -- A "-" because it's repulsion force
        -- and "* 10" to make the force stronger
        v = - robot.proximity[i].value * 10
        a = robot.proximity[i].angle

        fAvoidance = {x = v * math.cos(-a), y = v * math.sin(-a)}
        sumForce.x = sumForce.x + fAvoidance.x
        sumForce.y = sumForce.y + fAvoidance.y
    end

    randomForce = randForce(35)
    sumForce.x = sumForce.x + randomForce.x
    sumForce.y = sumForce.y + randomForce.y

    speedFromForce(sumForce)
]]--

    sumForce = { x = 0, y = 0}

    for i = 1,24 do
        -- Same than previously, without the minus
        v = - robot.light[i].value * 10
        a = robot.light[i].angle

        fLight = {x = v * math.cos(-a), y = v * math.sin(-a)}
        sumForce.x = sumForce.x + fLight.x
        sumForce.y = sumForce.y + fLight.y
    end

    randomForce = randForce(5)
    sumForce.x = sumForce.x + randomForce.x
    sumForce.y = sumForce.y + randomForce.y

    speedFromForce(sumForce)


end

function randForce(val)
    angle = robot.random.uniform(- math.pi/2, math.pi/2)
    randomForce = {x = val * math.cos(angle), y = val * math.sin(angle) }
    return randomForce
end

function speedFromForce(f)
	kF = 1.0
	kA = 1.0

	forward = math.abs( f.x * kF )
	angular = f.y * kA

	leftSpeed = forward + angular
	rightSpeed = forward - angular

	robot.wheels.set_velocity(leftSpeed,rightSpeed)
end


--[[ This function is executed every time you press the 'reset'
     button in the GUI. It is supposed to restore the state
     of the controller to whatever it was right after init() was
     called. The state of sensors and actuators is reset
     automatically by ARGoS. ]]
function reset()
   -- put your code here
end



--[[ This function is executed only once, when the robot is removed
     from the simulation ]]
function destroy()
   -- put your code here
end

function my_add(a, b)
   return a + b
end