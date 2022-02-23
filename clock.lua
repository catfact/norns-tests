clock_1 = nil
clock_2 = nil

sync_1 = 1/4
sync_2 = 1

engine.name = 'PolyPerc'

init = function()
   engine.release(0.09);
   clock_1 = clock.run(clock_loop_1)
   clock_2 = clock.run(clock_loop_2)
end

function clock_loop_1()
  clock.sync(1) -- start on next beat to avoid excessive funkiness
  while true do
    -- prints take time
    --print('clk1')
    engine.pan(-0.5)
    engine.amp(0.2)
    engine.hz(110)
    clock.sync(sync_1)
  end
end


function clock_loop_2()
  local bop = function() engine.amp(0.16); engine.pan(0.5); engine.hz(660) end
  local i
  
  clock.sync(1) -- start on next beat to avoid excessive funkiness
  while true do
    for i=1,20 do bop(); clock.sync(sync_2 * 2/5) end
    for i=1,12 do bop(); clock.sync(sync_2 * 1/3) end
    for i=1,8 do bop(); clock.sync(sync_2) end
  end
end


function clock.transport.stop()
  clock.cancel(clock_1)
  clock.cancel(clock_2)
end


function clock.transport.start()
  clock_1 = clock.run(clock_loop_1)
  clock_2 = clock.run(clock_loop_2)
end
