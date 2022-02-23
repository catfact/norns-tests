--- k2: start/stop
--- k3: reset pos

--file = '/home/we/dust/audio/zebra/dont_explain_48k.wav'
file = '/home/we/dust/audio/zebra/blue-light-sweet.wav'

cut = softcut
state = { playing = false }
t0 = 10

toggle_play = function()
   if state.playing then
      state.playing = false
      --cut.enable(1, 0)
      cut.play(1, 0)
   else
      state.playing = true
      --cut.enable(1, 1)
      cut.play(1, 1)
   end
end

reset_pos = function()
   cut.position(1, t0)
end

init = function()
   cut.buffer_read_stereo(file)
   cut.buffer(1, 1)
   cut.level(1, 1)
   cut.loop(1, 1)
   cut.loop_start(1, t0)
   cut.loop_end(1, 200)
   cut.position(1, 0)
   --cut.play(1, 1)
   cut.enable(1, 1)
end

key = function(n,z)
   if z ~= 1 then return end
   if n == 2 then
      toggle_play(); redraw()
   elseif n == 3 then
      reset_pos(); redraw()
   end   
end

enc = function(n,d)
end

redraw = function()
   screen.clear()
   screen.move(0, 10)
   if state.playing then
      screen.text('playing')
   else
      screen.text('stopped')
   end
   screen.update()
end
