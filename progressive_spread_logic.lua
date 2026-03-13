local M = {}

function M.calcSpread(api, ammoCnt, basicInaccuracy)
    -- Load or init cache
    local cache = api:getCachedScriptData()
    if cache == nil then
        cache = { shots = 0 , mult = -1}
    end

    local util = api:getEntityUtil()

    -- Parameters
    local params = api:getScriptParams()
    local maxShots = params.max_shots

    local baseRadius = params.base_radius
    local maxRadius = params.max_radius_spray_penalty

    local baseRadiusAds = params.base_radius_ads
    local maxRadiusAds = params.max_radius_spray_penalty_ads

    local resetTime = params.reset_time_per_shot
    local upward = params.upward
    local sideway = params.sideway
    
    
    if (api:getAimingProgress()>0) then
        maxRadius = params.max_radius_spray_penalty_ads
        baseRadius = params.base_radius_ads
        upward = 0
        sideway = 0
    end
    
    
    


    -- Timing check
    local lastShot = api:getLastShootTimestamp()
    local now = api:getCurrentTimestamp()
    local interval = api:getShootInterval()

    if (now - lastShot) > (resetTime + interval) then
        cache.shots = math.max(cache.shots - math.floor((now - lastShot)/(resetTime + interval)), 0)
    else
        cache.shots = math.min(cache.shots + 1, maxShots)
    end

    -- Spread growth
    local ramp = cache.shots / maxShots
    local effectiveRadius = (ramp * maxRadius) + baseRadius
    local effectiveUpward = ramp * upward
    local randomSideway = sideway * math.random() * cache.mult * ramp

    if (not api:isOnGround()) then
       effectiveRadius = effectiveRadius + params.jump_penalty
    elseif api:isMoving() and api:isCrouching() then
       effectiveRadius = effectiveRadius + params.sneak_walk_penalty
    elseif api:isMoving() and not api:isCrouching() then
        effectiveRadius = effectiveRadius + params.move_penalty
    end
    if api:isCrouching() then
        effectiveRadius = effectiveRadius * params.sneak_reward
        effectiveUpward = effectiveUpward * params.sneak_reward
        randomSideway = randomSideway * params.sneak_reward
    end


    -- Random point within a circle
    local angle = math.random() * 2 * math.pi
    local sidewayChance = params.sideway_chance
    if sidewayChance >= math.random() then
        cache.mult = cache.mult * -1
    end

    local r = math.sqrt(math.random()) * effectiveRadius  
    local x = 0
    local y = 0
    if cache.shots <= 2 then
        x = math.cos(angle) * r
        y = math.sin(angle) * r + effectiveUpward / 2.5
    else
        x = math.cos(angle) * r + randomSideway
        y = math.sin(angle) * r + effectiveUpward
    end
    

    -- local util = api:getEntityUtil()
    -- util:sendActionBar(util:literal(tostring(cache.shots)))

    -- Save cache
    api:cacheScriptData(cache)
    return { x, y }

end

return M
