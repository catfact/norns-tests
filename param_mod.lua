local scale_options = {"none", "semitones", "fifths"}

local scale_specs = {
   controlspec.new(-1.0,1.0,"lin", 0, 0,""),
   controlspec.new(-1.0,1.0,"lin", 1/12, 0,""),
   controlspec.new(-1.75,1.75,"lin", 7/12, 0,"")
}

init = function()

   -- this method can only work
   params:add_option("scale", "scale", scale_options, 1)
   params:set_action("scale", function(n) 
			print('setting spec: '..n)
			-------  this is the hacky part....
			-- get the actual param table out of the paramset
			local p = params:lookup_param("value")
			print(p)
			-- with that we can change the spec...
			p.controlspec = scale_specs[n]
			-- .. and trigger the action which (i think?) should apply the new spec ranges
			p:bang()
   end)

   params:add_control("value", "value", scale_specs[1])
   params:set_action("value", function(value) 
			print("new value: "..value) 
   end)
   
   
end 

enc = function(n, d)
   if n == 2 then
      params:delta("value", d)
   end 
   if n == 3 then
      params:delta("scale", d) 
   end 
end 
