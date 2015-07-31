import("maxmsp.lib");
import("music.lib");

/* =========== Description ===========: 

- A Notch creates a "hole" in the sound at the indicated frequency
- The slider Q - FILTER BANDWIDTH indicates the width of the band in Hz around the center frequency.

- Rocking : to chose the frequency to be cut-off.
- Back : Maximum Q.
- Front : Minimum Q.
- Note : The smaller Q is, the larger the notch.

*/

G = -3;
F = hslider("Frequency[scale:log][acc:0 1 -10 15 0 440]", 440, 80, 10000, 1):min(10000):max(80);
Q = hslider("Q - Filter Bandwidth[scale:log][acc:2 0 -10 10 0 20]", 20, 0.01, 50, 0.01):min(50):max(0.01);

process(x) = notch(x,F,G,Q);

