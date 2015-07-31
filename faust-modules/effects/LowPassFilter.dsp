declare name "Low Pass Filter";
	import("filter.lib");

/* ========= DESCRITPION ===========

- A low pass filter blocks all the frequencies superior to the designated CUT-OFF FREQUENCY
- Front = no filter
- Back = maximum filtering
- Rocking = Increase/Decrease of the filtering
*/

process = _:lowpass(2,fc):_
with{
	fc = hslider("Cut-off Frequency[acc:2 1 -10 10 0 800][scale:log]", 440, 10, 20000, 0.01):smooth(0.999):min(20000):max(10);
	};