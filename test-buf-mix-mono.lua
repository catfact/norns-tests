-- tests mix_buffer_mono()

local file1 = _path.dust.."audio/zebra/dregs-1.wav"
local file2 = _path.dust.."audio/zebra/dregs-2.wav"
local rate = 1.0
local preserve = 1.0
local mix = 1.0

function init()
    print_info(file1)

    softcut.buffer_clear()
    -- buffer_mix_mono (file, start_src, start_dst, dur, preserve, mix, ch_src, ch_dst)
    softcut.buffer_mix_mono(file1,0,1,-1,0,1,1,1)

    softcut.enable(1,1)
    softcut.buffer(1,1)
    softcut.level(1,1.0)
    softcut.loop(1,1)
    softcut.loop_start(1,1)
    softcut.loop_end(1,5)
    softcut.position(1,1)
    softcut.rate(1,1.0)
    softcut.play(1,1)
end

function enc(n,d)
    if n == 1 then
        rate = util.clamp(rate+d/100,-4,4)
        softcut.rate(1,rate)
    elseif n == 2 then
        preserve = util.clamp(preserve + d/100,0,1)
    elseif n == 3 then
        mix = util.clamp(mix + d/100,0,1)
    end
    redraw()
end

function key(n,z)
    if n == 3 and z == 1 then
        print_info(file2)
        softcut.buffer_mix_mono(file2,0,1,-1,preserve,mix,1,1)
    elseif n == 2 and z == 1 then
        print_info(file1)
        softcut.buffer_mix_mono(file1,0,1,-1,0,1,1,1)
    end
end


function redraw()
    screen.clear()
    screen.move(10,30)
    screen.text("rate: ")
    screen.move(118,30)
    screen.text_right(string.format("%.2f",rate))
    screen.move(10,40)
    screen.text("preserve: ")
    screen.move(118,40)
    screen.text_right(string.format("%.2f",preserve))
    screen.move(10,50)
    screen.text("mix: ")
    screen.move(118,50)
    screen.text_right(string.format("%.2f",mix))
    screen.update()
end

function print_info(file)
    if util.file_exists(file) == true then
        local ch, samples, samplerate = audio.file_info(file)
        local duration = samples/samplerate
        print("loading file: " ..file)
        print("  channels:\t"..ch)
        print("  duration:\t"..duration.." sec")
    else print "file not found" end
end
