declare name "Bouncy Harp";
declare author "ER"; //From Nonlinear EKS by Julius Smith and Romain Michon;

/* =============== DESCRIPTION ================= :

Do not hesitate to make swift and abrupt gestures.
- Head : Silence
- Swing :  To pluck the strings of the harp.
- Fishing rod with abrupt stop in Head position : bouncing string effect.
- Frying Pan and Tennis Racket : to pluck a single bouncing string.

*/

import("music.lib");    // Define SR, delay
import("instrument.lib");
import("effect.lib");   // stereopanner

//==================== INSTRUMENT =======================

process = par(i, N, NLFeks(i)):>_;

NLFeks(n) = filtered_excitation(n,P(octave(n)),octave(n)) : stringloop(octave(n));
 												

//==================== GUI SPECIFICATION ================

N = 15;
hand = hslider("[1]Instrument Hand [acc:1 0 -8 11 0 0]", 0, 0, N, 1);// => gate
gain = 1;
reverse = select2(_, 1, 0);
pickangle = 0.9 * hslider("[3]Dry/Soft Strings[acc:2 1 -10 10 0 0.45]",0.45,0,0.9,0.1);

beta = hslider("[4]Picking Position [acc:2 1 -10 10 0 0.13]", 0.13, 0.02, 0.5, 0.01);
t60 = hslider("[5]Resonance (InstrReverb)[acc:1 1 -10 10 0 5]", 5, 0.5, 10, 0.01);  // -60db decay time (sec)

B = 0.5;
L = -10 : db2linear;

//---------------------------------- FREQUENCY TABLE ---------------------------

freq(0) = 115;
freq(1) = 130;
freq(2) = 145;
freq(3) = 160;
freq(4) = 175;

freq(d)	 = freq(d-5)*(2);
octave(d) = freq(d) * hslider("Hight[acc:2 1 -10 10 0 3]", 3, 1, 6, 0.1) : smooth(0.999);	
	

//==================== SIGNAL PROCESSING ================

//----------------------- noiseburst -------------------------
// White noise burst (adapted from Faust's karplus.dsp example)
// Requires music.lib (for noise)
noiseburst(d,e) = noise : *(trigger(d,e))
with{
upfront(x) = (x-x') > 0;
decay(n,x) = x - (x>0)/n;
release(n) = + ~ decay(n);
position(d) = abs(hand - d) < 0.5;
trigger(d,n) = position(d) : upfront : release(n) : > (0.0);
};


P(f) = SR/f ; // fundamental period in samples
Pmax = 4096; // maximum P (for delay-line allocation)

ppdel(f) = beta*P(f); // pick position delay
pickposfilter(f) = ffcombfilter(Pmax,ppdel(f),-1); // defined in filter.lib

excitation(d,e) = noiseburst(d,e) : *(gain); // defined in signal.lib

rho(f) = pow(0.001,1.0/(f*t60)); // multiplies loop-gain

// Original EKS damping filter:
b1 = 0.5*B; b0 = 1.0-b1; // S and 1-S
dampingfilter1(f,x) = rho(f) * ((b0 * x) + (b1 * x'));

// Linear phase FIR3 damping filter:
h0 = (1.0 + B)/2; h1 = (1.0 - B)/4;
dampingfilter2(f,x) = rho(f) * (h0 * x' + h1*(x+x''));

loopfilter(f) = dampingfilter2(f); // or dampingfilter1

filtered_excitation(d,e,f) = excitation(d,e) : smooth(pickangle) 
		    : pickposfilter(f) : levelfilter(L,f); // see filter.lib


stringloop(f) = (+ : fdelay4(Pmax, P(f)-2)) ~ (loopfilter(f));// : NLFM(f));

