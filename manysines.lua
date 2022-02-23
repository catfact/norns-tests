-- stress test with panned sinewaves
-- K2: add 10x sines
-- K3: stop all sines
--
-- polls and prints audio load / xrun count
engine.name = 'ManySines'


tick = function()
    local cpu = _norns.audio_get_cpu_load()
    -- polling xrun count here messes up menu xrun status display
    -- make this false if you dont want that
    if true then
        local xruns = _norns.audio_get_xrun_count()
        print(tostring(cpu)..', \t'..xruns)
    else
        print(tostring(cpu))
    end

end

nsines = 0

init = function()
    m = metro.init(tick, 1)
    m:start()
end

function randhz()
    return 55.0 * math.pow(2.0, math.random()*4)
end

key = function(n, z)
    if z > 0 then 
        if n == 2 then
            local hz
            for i=1,10 do
                hz = randhz()
                --print(hz)
                engine.newsine(hz)
                nsines = nsines + 1
            end
            print('n = '.. nsines)
        elseif n == 3 then
            engine.clear()
            nsines = 0
            print(' n = '.. nsines)
        end
    end
end