--- quick test of screen.text_extents
-- e1: face
-- e2: size
-- e3: chars + rebuild
-- k3: rebuild

size = 12
nchars = 8
str = ""
x = 20
y = 40

font_sel = 1

rebuild = function()
   str = ""
   for char=1,nchars do
      byte = math.random(32, 126)
      str = str..string.char(byte)
   end
end

-- using coroutines 
text_extents = {
   bx=0, by=0,
   w=0, h=0,
   ax=0, ay=0
}

draw_cr = nil

   -- FIXME: this is evil, provide a better API
_norns.screen.text_extents = function(bearing_x, bearing_y,
				      width, height,
				      advance_x, advance_y)
   
   text_extents.bx = bearing_x
   text_extents.by = bearing_y
   text_extents.w = width
   text_extents.h = height
   text_extents.ax = advance_x
   text_extents.ay = advance_y

   print(" --- handling callback --- ")
   tab.print(text_extents)
   
   coroutine.resume(draw_cr)
end

redraw = function()
   draw_cr = coroutine.create(function()
	 screen.clear()
	 screen.move(x, y)
	 print(" --- requesting extents --- ")
	 print(str)
	 screen.font_size(size)
	 screen.font_face(font_sel)
	 screen.text_extents(str)
	 coroutine.yield(draw_cr)
	 
	 print(" --- resuming draw --- ")
	 print(str)
	 tab.print(text_extents)
	 screen.text(str)

	 screen.rect(x, y, text_extents.ax, text_extents.by)
	 screen.level(15)	 
	 screen.stroke()

	 local yhi = y + text_extents.by
	 local ylo = y + text_extents.by + text_extents.h
	 screen.move(4, yhi)
	 screen.line(4, ylo)
	 screen.move(x, ylo+4)
	 screen.line(x + text_extents.w, ylo+4) 
	 screen.level(15)
	 screen.stroke()	 
	 
	 screen.update()
	 print(" --- done drawing --- \n")
   end)
   coroutine.resume(draw_cr)
end


inc = {
   -- e1
   function(d)
      font_sel = font_sel + d
      if font_sel > screen.font_face_count then font_sel = screen.font_face_count end
      if font_sel < 1 then font_sel = 1 end
      redraw()
   end,
   -- e2
   function(d)
      size = size + d
      if size > 60 then size = 60 end
      if size < 1 then size = 1 end
      redraw()
   end,
   -- e3
   function(d)   
      nchars = nchars + d
      if nchars > 32 then nchars = 32 end
      if nchars < 1 then nchars = 1 end
      rebuild()
      redraw()
   end,
}

enc = function(n,d) inc[n](d) end

key = function(n,z)
   if n==3 and z>0 then rebuild(); redraw() end
end

init = function() rebuild() end
