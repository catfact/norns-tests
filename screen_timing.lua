--- test timing of metro
--- with heavy screen use
musicutil = require 'musicutil'

--------------------------------
------------------
--- sound

engine.name = 'Boomtick'

-- two 16-note patterns
-- should be independent but synchronized

pattern_1 = {4, 4, 4, 1, 1, 1, 1}
pattern_2 = {2, 2, 2, 2}
bpm = 120

state_1 = { 
  stage= 1,
  count= 0,
  nstages = #pattern_1
}

state_2 = { 
  stage= 1,
  count= 0,
  nstages = #pattern_2
}

function update_sequence(state, pattern, action)
  if state.count == 0 then action() end
  state.count = state.count + 1
  if state.count == pattern[state.stage] then
    state.count = 0
    state.stage = state.stage + 1
    if state.stage > state.nstages then 
      state.stage = 1
    end
  end
  return state
end

main = function()
  state_1 = update_sequence(state_1, pattern_1, function() engine.boom() end)
  state_2 = update_sequence(state_2, pattern_2, function() engine.tick() end)
end

--------------------------------
------------------
--- screen


redraw_metro = nil

dt = nil

pix_size = 2
pix_idx_wr = 2
pix_idx_rd = 1

function init_pixels()
  print("init_pixels")
  pixels = {}
  pix_count = 128 * 64 / (pix_size*pix_size)
  a = 3.77 + math.random() * 0.02
  x = 0.7 + math.random() * 0.15
  for i=1,pix_count do
    x = a*x*x*x + (1-a)*x
    val = (x + 1) * 8
    val = math.floor(val or 0)
    if val < 0 then val = 0 end
    if val > 15 then val = 15 end
    pixels[i] = val
  end 
  pix_idx = 1
end

function draw_pixels()
  screen.line_width(1)
  local idx = pix_idx_rd
  local x = 0
  local y = 0
  local n = pix_count
  for i=1,n do
    x = x + pix_size
    if x >= 128 then
      x = 0
      y = y + pix_size
    end
    screen.level( pixels[idx])
    -- this seems odd, according to:
    -- https://www.cairographics.org/FAQ/#sharp_lines
    screen.rect(x, y, pix_size, pix_size)
    screen.fill()
    idx = idx + 1
    while idx > n do idx = idx - n end
  end
  -- pixels[pix_idx_wr] = map:iterate()
  -- pix_idx_wr = pix_idx_wr + 1
  -- while pix_idx_wr > n do pix_idx_wr = pix_idx_wr - n end
  pix_idx_rd = pix_idx_rd + 1
  while pix_idx_rd > n do pix_idx_rd = pix_idx_rd - n end
end


square_level = 1
function draw_square()
   screen.level(square_level)
   screen.rect(10, 10, 44, 44)
   screen.fill()
   
   screen.move(20, 20)
   if dt ~= nil then
     screen.font_size(10)
     screen.blend_mode(1)
    screen.text(dt)
   end
   
   square_level = square_level + 1
   if square_level > 15 then square_level = 0 end
end

circle_width = 1
circle_inc = 1
function draw_circle()
   screen.level(15)
   circle_width = circle_width + circle_inc
   if circle_width < 2 then
      circle_inc = 1
   end
   if circle_width > 31 then
      circle_inc = -1
   end
   screen.circle(96, 32, circle_width)
   screen.line_width(4)
   screen.stroke()
end

number = 0
number_tick_count = 5
number_ticks = 0
function draw_number()
   number_ticks = number_ticks + 1
   if number_ticks >= number_tick_count then
      number_ticks = 0 
      number = number + 1
      if number > 9 then number = 0 end
   end
   screen.blend_mode(1)
   screen.level(10)
   screen.move(50, 60)
   screen.font_size(60)
   screen.text(number)
end


function redraw()
   screen.clear()
   screen.blend_mode(0)
   draw_pixels()
   draw_square()
   draw_circle()
   draw_number()
   screen.update()
end


-----------------------------
------------------------------
----- UI
run_screen = true
run_sound = true
key_fn = {
  function()
  -- k1: nothing
  end,
  function() 
    -- k2: toggle drawing
    if run_screen then run_screen= false; screen_metro:stop() 
    else run_screen = true; screen_metro:start() end
  end,
  function()
    -- k3: toggle sound
    if run_sound then run_sound= false; sound_metro:stop() 
    else run_screen = true; sound_metro:start() end
  end
}

key = function(n, z)
  if z > 0 then key_fn[n]() end
end 

------------------------------
----------------------
--- ye init

function init()
  init_pixels()
  screen_metro = metro.init({
	event = function()
	   local t = util.time()
	   redraw() 
	   dt = util.time() - t
	 end,
	 time = 1/12
   }):start()
 
  midi_device = midi.connect()
  midi_device.event = function(data)
    msg = midi.to_msg(data)
    if msg.type == "note_on" then
      engine.ping(musicutil.note_num_to_freq(msg.note))
    end
  end

  params:set("reverb", 1)
  local sound_metro = metro.init(main, 60 / (bpm * 4), -1)
  sound_metro:start()
end
