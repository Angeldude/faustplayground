declare name "Tuned Bars";
declare author "ER";//From "Tuned Bar" by Romain Michon (rmichon@ccrma.stanford.edu);

import("music.lib");
import("instrument.lib");

/* =============== DESCRIPTION ================= :

- Cascading tuned bars
- Head = Silence
- Bottom = Chime
- Left = Low frequencies + slow rhythm
- Right = High frequencies + fast rhythm
- Geiger counter = Chime

*/

//==================== INSTRUMENT =======================

process = par(i, N, tunedBar(i)):>_; 
tunedBar(n) =
		((select-1)*-1) <:
		//nModes resonances with nModes feedbacks for bow table look-up 
		par(i,nModes,(resonance(i,octave(n),gate(n))~_)):> + : 
		//Signal Scaling and stereo
		*(15);
//==================== GUI SPECIFICATION ================
N = 10;

gain = 1;
gate(n) = position(n) : upfront;
hand = hslider("[1]Instrument Hand[acc:1 0 -10 10 0 5]", 0, 0, N, 1):smooth(0.999):min(N):max(0):int:automat(B, 15, 0.0);
B = hslider("[3]Speed[style:knob][acc:0 1 -10 10 0 480]", 480, 180, 720, 60): smooth(0.99) : min(720) : max(180) : int;
hight = hslider("[2]Hight[acc:0 1 -10 10 0 4]", 4, 0.5, 8, 0.1);//:smooth(0.999);
octave(d) = freq(d)*(hight);
position(n) = abs(hand - n) < 0.5;
upfront(x) = abs(x-x') > 0;

select = 1;
//----------------------- Frequency Table --------------------


freq(0) = 130.81;
freq(1) = 146.83;
freq(2) = 164.81;
freq(3) = 184.99;
freq(4) = 207.65;
freq(5) = 233.08;

freq(d)	 = freq(d-6)*2;

//==================== MODAL PARAMETERS ================

preset = 2;

nMode(2) = 4;

modes(2,0) = 1;
basegains(2,0) = pow(0.999,1);
excitation(2,0,g) = 1*gain*g/nMode(2);

modes(2,1) = 4.0198391420;
basegains(2,1) = pow(0.999,2);
excitation(2,1,g) = 1*gain*g/nMode(2);

modes(2,2) = 10.7184986595;
basegains(2,2) = pow(0.999,3);
excitation(2,2,g) = 1*gain*g/nMode(2);

modes(2,3) = 18.0697050938;
basegains(2,3) = pow(0.999,4);
excitation(2,3,g) = 1*gain*g/nMode(2);

//==================== SIGNAL PROCESSING ================
//----------------------- Synthesis parameters computing and functions declaration ----------------------------

//the number of modes depends on the preset being used
nModes = nMode(preset);

delayLengthBase(f) = SR/f;

//delay lengths in number of samples
delayLength(x,f) = delayLengthBase(f)/modes(preset,x);

//delay lines
delayLine(x,f) = delay(4096,delayLength(x,f));

//Filter bank: bandpass filters (declared in instrument.lib)
radius = 1 - PI*32/SR;
bandPassFilter(x,f) = bandPass(f*modes(preset,x),radius);
//----------------------- Algorithm implementation ----------------------------

//One resonance
resonance(x,f,g) = + : + (excitation(preset,x,g)*select) : delayLine(x,f) : *(basegains(preset,x)) : bandPassFilter(x,f);
