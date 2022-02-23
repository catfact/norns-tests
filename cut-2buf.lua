local sc = softcut

init = function()

   -- mixer settings
   audio.level_cut(1.0)
   audio.level_adc_cut(1)

   -- voice 1: input from ADC channel 1 only, pan hard left
   sc.level_input_cut(1, 1, 1.0)
   sc.pan(1, -1)
   
   -- voice 2: input from ADC channel 2 only, pan hard right
   sc.level_input_cut(2, 2, 1.0)
   sc.pan(2, 1)

   -- set parameters for both voices
   for i=1,2 do
	sc.loop(i, 1)
	sc.fade_time(i, 0.1)
	sc.rec_level(i, 1)
	sc.pre_level(i, 0.75)
	sc.position(i, 0)
	
	sc.rec(i, 1)
	sc.play(i, 1)
	sc.enable(i, 1)

	sc.level(i, 1)
	sc.filter_dry(i, 1)
	sc.filter_lp(i, 0)
	sc.filter_bp(i, 0.0)
	sc.filter_rq(i, 0.0)

	sc.play(i, 1)
	sc.rec(i, 1)
   end

   -- give voices 1/2 separate loop points and different rates
   sc.loop_start(1, 0)
   sc.loop_end(1, 1.5)
   sc.rate(1, 1.5);
   
   sc.loop_start(2, 0.777)
   sc.loop_end(2, 1.7777)
   sc.rate(2, 1.5 * 5/4)

   -- assign voice 1 to buffer 1
   sc.buffer(1, 1)
   
   -- add a parameter to switch buffer assignment of voice 2
   params:add_number("voice_2_buf", "voice_2_buf", 1, 2, 2)
   params:set_action("voice_2_buf", function(value) sc.buffer(2, value) end)

    -- add a parameter to read a soundfile into each buffer
    params:add_file("file_1", "file_1")
    params:set_action("file_1", function(f) sc.buffer_read_mono(f, 0, 0, -1, 1, 1) end)

    params:add_file("file_2", "file_2")
    params:set_action("file_2", function(f) sc.buffer_read_mono(f, 0, 0, -1, 1, 2) end)
							

end
