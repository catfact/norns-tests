init = function()
   clk = clock.run(function()
	 while true do
	    print("bang")
	    clock.sync(1)	    
	    print("!")
	    clock.sync(1)
	 end
   end)
end

enc = function(n,d)
   if n == 2 then
      params:delta("clock_tempo", d)
      print('new tempo: '..params:get("clock_tempo"))
   end
end
