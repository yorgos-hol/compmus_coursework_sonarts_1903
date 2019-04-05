//IF YOU WANT TO RECORD A NEW WAVETABLE SAMPLE
(
var sig, exp;
var soundFile;

// exp = 2; //
exp = 2.pow(rrand(1, 20))
sig = Signal.fill(2.pow(exp), {2.0.rand-1}).asWavetable;
sig.plot;

soundFile = SoundFile.new;
soundFile.headerFormat_("WAV").sampleFormat_("int16").numChannels_(1);
soundFile.openWrite("write Full PathName here, e.g. '/yorgos/Documents/SC SONARTS Waveta2/RECORDED/Sign_but_not_by_BEG6.wav' ");
soundFile.writeData (sig);
soundFile.close;
)
~buf.free;
//IF YOU WANT TO CHOOSE AN EXISTING WAVETABLE
~buf = Buffer.read(s, "drop file here or write full pathname e.g. 'd:/yorgos/Documents/SC SONARTS Waveta2/RECORDED/Sign_but_not_by_BEG.wav' ");
~buf2 = Buffer.read(s, "(e.g) d:/yorgos/Documents/SC SONARTS Waveta2/BUFFERS/WAV933.wav", numFrames: 512)
~buf3 = Buffer.read(s, "d:/yorgos/Documents/SC SONARTS Waveta2/BUFFERS/WAV1031.wav", numFrames: 512)
~buf4 = Buffer.read(s, "d:/yorgos/Downloads/TEMPWAV/wavzz/άγνωστο άλμπουμ - 00 - άγνωστος τίτλος.wav", numFrames: 512)
//OR...MORE RANDOMNESS

//HERE BEGINS THE MAIN PART OF THE CODE. THE EVALUATION OF THE 2 FOLLOWING PARENTHESES IS NECESSARY IN ORDER TO SUBSEQUENTLY PLAY (WITH) THE REST OF THE CODE
(

//in PathName you drop the folder containing the subfolders containing the various waveform/other samples you want to load into buffers and subsequently into wavetables
	~wavz = Dictionary.new;
	PathName("d:/yorgos/Documents/SC SONARTS Waveta2").entries.do{
		arg subfolder;
		~wavz.add(
			subfolder.folderName.asSymbol ->
			Array.fill(
				subfolder.entries.size,
				{
					arg i;
					Buffer.read(s, subfolder.entries[i].fullPath, numFrames: 512);
				// YOU CAN ALSO PUT THE FOLLOWING FOR A MORE FLEXIBLE BUFFERED WAVEFORM SAMPLE SIZE:
				// Buffer.read(s, subfolder.entries[i].fullPath, numFrames: 2.pow(rrand(1, 20)) -- OR DEPENDING ON THE SAMPLE SIZE OF THE FILE YOU ARE USING
				}
			)
		);
	};


//~wavz[\BUFFERS].choose.play;



(SynthDef (\BEGTABLE2, {
	arg buf = ~wavz[\BUFFERS].choose, freq = (Scale.ahirbhairav.degrees+60).midicps, amp = 1, out=6;
	var env, sig;
	env = EnvGen.kr(Env.new([0,1,0.1,0], [0.2,0.4,0.1], [3,-3,0]), doneAction:2);
	sig = Osc.ar(buf, freq, mul: amp*env)!2;
	Out.ar(out, sig*env)});
).add;


(
Pbindef(\mainpattern,
	\instrument, \BEGTABLE2,
	\in, 6,
	\dur, 1/16,
	\stretch, 1.875,
	\note, Prand([0,3,5,9,10,12],inf),
	\atk, 0.005,
	\rel, Pexprand(0.01, 0.5, inf),
	\amp, Pexprand(0.05,0.5,inf),
	\pan, Pwhite(-0.8, 0.8, inf),
	\out, 8
	)
)
)

(
SynthDef.new(\reverb, {
	arg in=8, out=0;
	var sig;
	sig = In.ar(in, 2);
	sig = FreeVerb.ar(sig, 0.5, 0.8, 0.2)!2;
	Out.ar(out, sig*0.08);
}).add;
)

//PATTERN 1
(
Pbindef (\mainpattern).play;
~rev = Synth.new (\reverb, \addToTail);
)
Pbindef(\mainpattern).stop;

//PATTERN 2

a= Pbind(\instrument, \BEGTABLE2, \dur, 3/13.4, \freq, Pwhite(200,2000).round(120), \legato, 1,  \amp, PLFPulse(PLFSaw(22), 0, 0.33, 0.25).trace).play
a.stop

//VARIOUS SYNTHS
// ~maybeBEG = Synth.new (\BEGTABLE2, [ \freq, (Scale.ahirbhairav.degrees+80).midicps.choose, \amp, 0.04]);
// ~maybeBEG;






(SynthDef(\guaiwu, {
	var sig, index;
	index = LFSaw.ar(500);

	index = index * MouseX.kr(0.001,1,1);

	sig = Shaper.ar(~wavz[\BUFFERS].choose, index);
	sig = LeakDC.ar(sig);
	Out.ar(0, sig * 0.1);
}
).play;
)

s.scope


// AN ADDITIONAL LAG-BASED BUFFER PLAYING GAME THAT RESEMBLES/RESULTS INTO A SYNTH PLAYING A SIMPLE RHYTHMIC PATTERN 5 TIMES
(
r = Routine.new { i=0;
	while ({i<5}, {i=i+1;

	50.do{~wavz[\BUFFERS].choose.play};
	1.wait;
	700.do{~wavz[\BUFFERS].choose.play};
	2.wait;
	50.do{~wavz[\BUFFERS].choose.play};
	1.wait;
	400.do{~wavz[\BUFFERS].choose.play};
	4.wait;
	})
}.play;
)

r.stop;

//
(
50.do{
~guai2 = {
		// choose either one of the two arg bufnum instances
		// arg bufnum = MouseY.kr(~wavz[\BUFFERS][0],~wavz[\BUFFERS][3],1);
		arg bufnum = ~wavz[\BUFFERS].choose;
		var sig, index, out=0;
		index = {[LFTri.ar([60,187]), LFTri.ar([2000,550]), LFPar.ar([430.0, 432.0]), LFPulse.ar([LFNoise1.kr(24).range(500, 2999),570.0,580.0]), SinOsc.ar(Line.kr(709.0,807.0,10))].choose};
		index = index * MouseX.kr(0.001,1,1);
		sig = Shaper.ar(bufnum, index);
		sig = LeakDC.ar(sig);
		// choose either one of the two output mixing possibilities
		// Out.ar(out,sig*0.09)
		Splay.arFill(40, {sig * 0.01},1,0.09);
}.play;

}
)

(SynthDef.new(\bassiterwav,
{var sigall, ampfol;
	sigall = 5.do{

			arg bufnum = ~wavz[\BUFFERS].choose;
		var sig, index, out=0;
		index = {[LFTri.ar([60,187]), LFTri.ar([2000,550]), LFPar.ar([430.0, 432.0]), LFPulse.ar([LFNoise1.kr(24).range(500, 2999),570.0,580.0]), SinOsc.ar(Line.kr(709.0,807.0,10))].choose};
		index = index * MouseX.kr(0.001,1,1);
		sig = Shaper.ar(bufnum, index);
		ampfol = Amplitude.ar(sig, 0.5, 0.5, 80);
			// Out.ar(out,sig*0.009)
			Out.ar(out, LeakDC.ar(Resonz.ar(sig, ampfol, rrand(0.0000001,0.00001), 4500)));

};

}).add;
)

~whyv = Synth.new(\bassiterwav)

(SynthDef.new(\detunwav,
{var sigall, ampfol;
	sigall = 5.do{
			arg i, bufnum = ~wavz[\BUFFERS].choose, bwr = rrand(0.00001,0.5);
		var sig, index, out=0;
			index = {[LFTri.ar([60,187]), LFTri.ar([2000,550]), LFPar.ar([430.0, 432.0]), LFPulse.ar([LFNoise1.kr(24).range(500, 2999),570.0,580.0]), SinOsc.ar(Line.kr(709.0,807.0,10))].choose*(i+1)+(SinOsc.kr((i+0.5)*0.2,0,0.1,0.1*2))};
		index = index * MouseX.kr(0.001,1,1);
		sig = Shaper.ar(bufnum, index);

			ampfol = Amplitude.ar(sig, 0.5, 0.5, 80);
			// Out.ar(out,sig*0.009)
			Out.ar(out, LeakDC.ar(Resonz.ar(sig, ampfol+rand(180,340),
				rrand(0.0000001,0.00001), bwr.reciprocal*1/5+2000;)));

};

}).add;
)

~wdyv = Synth.new(\detunwav)

(SynthDef.new(\rhythmdetunwav,
{var sigall, ampfol;
	sigall = 12.do{
			arg i, bufnum = ~wavz[\BUFFERS].choose, bwr = rrand(0.00001,0.5);
			// or you can change the arg bwr for differently sounding results here, or by adding different values on the ~wrhyv instance of the synth further down below
			// arg i, bufnum = ~wavz[\BUFFERS].choose, bwr = rrand(0.00001,0.0005);
		var sig, index, index2, out=0, resfreq, resmul;
			// choose either one or even both (simultaneously) of the two following var index instances:
			index = {LFPar.ar([LFDNoise1.ar(30)*3.4, 432.0*SinOsc.ar((i*200+i.squared+20*i.sqrt/5)*LFPulse.ar({[2.0/i.sqrt*2,5.0/i*2,6.0/i*2].choose}))*0.07], 0,1,0.1*2)};
			// index = {LFPar.ar([LFNoise0.ar(30)*3.4, 432.0*SinOsc.ar((i*200+i.squared+20*i.sqrt*1.5)*LFPulse.ar({[2.0/i*2,5.0/i*2,6.0/i*2].choose}))*0.07], 0,1,0.1*2)};
		index = index * MouseX.kr(0.001,1,1);
			resfreq = {ampfol+rand(400,2200).round(220)};
			// choose either one of the two arg resmul instances
			// resmul = resfreq.reciprocal*1/12;
			resmul = bwr.reciprocal*1/12;
		sig = Shaper.ar(bufnum, index)*0.2;
			ampfol = Amplitude.ar(sig, 0.5, 0.5, 80);
			// Out.ar(out,sig*0.2);
			Out.ar(out, LeakDC.ar(Limiter.ar(Resonz.ar(sig, resfreq, bwr, resmul))));

};

}).add;
)

~wrhyv = Synth.new(\rhythmdetunwav)


// THIS LAST SYNTH CREATES MOSTLY PERCUSSIVE SOUNDS OF DIFFERENT SPECTRAL CONTENT AND ENVELOPE EACH TIME
(SynthDef.new(\Hayperc,
{var sigall, ampfol;
	sigall = 12.do{
			arg i, bufnum = ~wavz[\BUFFERS].choose, bwr = rrand(0.00001,0.5);
			// or you can change the arg bwr for differently sounding results here, or by adding different values on the ~wrhyv instance of the synth further down below
			// arg i, bufnum = ~wavz[\BUFFERS].choose, bwr = rrand(0.00001,0.0005);
		var sig, index, index2, out=0, resfreq, resmul;
			// choose either one or even both (simultaneously) of the two following var index instances:
			index = {LFPar.ar([LFNoise0.ar(30)*3.4, 432.0*SinOsc.ar((i*200+i.squared+20*i.sqrt/5)*LFPulse.ar({[2.0/i.sqrt*2,5.0/i*2,6.0/i*2].choose}))*0.07], 0,1,0.1*2)};
			// index = {LFPar.ar([LFNoise0.ar(30)*3.4, 432.0*SinOsc.ar((i*200+i.squared+20*i.sqrt*1.5)*LFPulse.ar({[2.0/i*2,5.0/i*2,6.0/i*2].choose}))*0.07], 0,1,0.1*2)};
		index = index * MouseX.kr(0.001,1,1);
			resfreq = {ampfol+rand(400,2200).round(220)};
			// choose either one of the two arg resmul instances
			// resmul = resfreq.reciprocal*1/12;
			resmul = bwr.reciprocal*1/12;
		sig = Shaper.ar(bufnum, index)*0.2;
			// choose one of the two Envelope shapes below (EXAMPLE OF DIFFERENT ENVELOPE - YOU CAN CHANGE IT AT WILL):
			// sig = EnvGen.ar(Env.new([0.1,25,0], [0.001,20,1]))
			sig = EnvGen.ar(Env.new([0.9,1,0], [0.001,2,1]), doneAction: 2);
			ampfol = Amplitude.ar(sig, 0.5, 0.5, 80);
			// Out.ar(out,sig*0.2);
			Out.ar(out, LeakDC.ar(Limiter.ar(Resonz.ar(sig, resfreq, bwr, resmul))));

};

}).add;
)

~hayp = Synth.new(\Hayperc)

s.plotTree


// LAST PATTERN USES LAST SYNTH AS AN EXAMPLE - CAN USE THE OTHERS IF YOU ADD AN EnvGen WITH doneAction: 2 IN THEM:
Pbindef(\mainpattern, \instrument, \Hayperc, \dur, Pstutter(3, Prand([1/16, 1/12, 1/10, 1/9, 1/7, 1/3, 11/16, 14/17,1,1.5
],35)).trace, \stretch, 0.795, \atk, 0.002, \out, 0).play;

~pe = Pbindef.new(\mainpattern).play;
~pe.stop;
