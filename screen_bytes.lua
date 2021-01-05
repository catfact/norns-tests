--- screen bytes
--- draw repetaed [0,15] value sequences
--- using literal values to screen.poke()
--- 
--- E2: set width, redarw
--- E3: set height, redraw
--- K2 (hold): save on redraw

w = 128
h = 64

clear = true

function enc(n, d)
  if n == 1 then
    return
  elseif n == 2 then
    w = util.clamp(w + d, 0, 128)
  elseif n == 3 then
    h = util.clamp(h + d, 0, 64)
  end
  redraw()
end

function key(n,z)
  if n == 2 then clear = (z==0) end
end

function init()
  print('ok')
end

function redraw()
  if clear then screen.clear() end
  local n = w * h
  local chars = {}
  local val = 0
  for i=1, n do
    table.insert(chars, string.char(val))
    val = (val + 1) % 16
  end
  local str = table.concat(chars)
  screen.poke(0, 0, w, h, str)
  screen.update()
end