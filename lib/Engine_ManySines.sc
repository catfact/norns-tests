
Engine_ManySines : CroneEngine {
	var <g, <b, <lim_s;
	alloc {
        var s = Server.default;
        g = Group.new(Server.default);
        b = Bus.audio(s, 2);
        
        lim_s = {
            Out.ar(0, Limiter.ar(In.ar(b.index, 2)))
        }.play(target:g, addAction:\addAfter);

		this.addCommand("newsine", "f", { arg msg;
            var hz = msg[1];
            {
                var amp = AmpComp.ir(hz) * 0.02;
                Out.ar(b.index, Pan2.ar(SinOsc.ar(hz)*amp, 1.0.rand))
            }.play(target:g, addAction:\addToTail);
		});

		this.addCommand("clear", "", { arg msg;
			g.deepFree;
		});
	}
	free {
		g.free;
        lim_s.free;
        b.free;
	}
}
