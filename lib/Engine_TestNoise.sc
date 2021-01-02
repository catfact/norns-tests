// CroneEngine_TestNoise
// variante of TestSine, for switching

// Inherit methods from CroneEngine
Engine_TestNoise : CroneEngine {
	var <synth;



	*new { arg context, doneCallback;
		^super.new(context, doneCallback);
	}

	alloc {
		synth = {
			arg out, hz=220, amp=0.5, amplag=0.02, hzlag=0.01;
			var amp_, hz_;
			amp_ = Lag.ar(K2A.ar(amp), amplag);
			hz_ = Lag.ar(K2A.ar(hz), hzlag);
			Out.ar(out, (LPF.ar(WhiteNoise.ar, hz_) * amp_).dup);
		}.play(args: [\out, context.out_b], target: context.xg);
		this.addCommand("hz", "f", { arg msg;
			synth.set(\hz, msg[1]);
		});

		this.addCommand("amp", "f", { arg msg;
			synth.set(\amp, msg[1]);
		});
	}
	free {
		synth.free;
	}
}
