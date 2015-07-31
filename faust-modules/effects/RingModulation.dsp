declare name "Ring Modulation";

/* ======== DESCRIPTION ==========

- Ring modulation consists in modulating a sound by multiplying it with a sine wave
- Head = no modulation
- Downward = modulation, varying the modulating frequency

*/

import("music.lib"); 
import("oscillator.lib"); 
import("filter.lib");


process = ringmod;	

ringmod = _<:_,*(oscs(freq)):drywet
		with {
				freq = hslider ( "[1]Modulation Frequency[acc:1 0 -10 10 0 2][scale:log]", 10,0.001,100,0.001):smooth(0.999);	
				drywet(x,y) = (1-c)*x + c*y;
				c = hslider("[2]Modulation intensity[style:knob][unit:%][acc:1 0 -10 10 0 60]",50,0,100,0.01)*(0.01):smooth(0.999);
			};
				
		
		



	
