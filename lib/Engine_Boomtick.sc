Engine_Boomtick : CroneEngine {

	*new { arg context, doneCallback;
		^super.new(context, doneCallback);
	}
	
	alloc {
		var s = Crone.server;
		SynthDef.new(\boom, { arg out=0, hz=110, amp=0.2, atk=0, rel=0.1, pan= -0.5;
			Out.ar(out, Pan2.ar(EnvGen.ar(Env.perc(atk, rel), doneAction:2) * SinOsc.ar(hz) * amp, pan));
		}).send(s);

		SynthDef.new(\tick, { arg out=0, amp=0.1, atk=0, rel=0.01, pan=0.5;
			Out.ar(out, Pan2.ar(EnvGen.ar(Env.perc(atk, rel), doneAction:2) * WhiteNoise.ar * amp, pan));
		}).send(s);
		
		s.sync;
		
		this.addCommand("boom", "", { Synth.new(\boom, target:s); });
		this.addCommand("tick", "", { Synth.new(\tick, target:s); });
		this.addCommand("ping", "f", { arg msg;
			Synth.new(\boom, [\hz, msg[1], \rel, 0.2, \pan, 0.0], target:s);
		});
	}
	
	free { }
}
