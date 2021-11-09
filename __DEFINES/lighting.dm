//Bay lighting engine shit, not in /code/modules/lighting because BYOND is being shit about it

#ifndef LIGHTING_INSTANT_UPDATES
//#include "..\code\controllers\subsystem\lighting.dm"
//Ok this doesn't work INCLUDE IT YOURSELF.
#endif

#define LIGHTING_FALLOFF        1 // type of falloff to use for lighting; 1 for circular, 2 for square
#define LIGHTING_LAMBERTIAN     0 // use lambertian shading for light sources
#define LIGHTING_HEIGHT         1 // height off the ground of light sources on the pseudo-z-axis, you should probably leave this alone

#define LIGHTING_ICON 'icons/effects/lighting_overlay.dmi' // icon used for lighting shading effects

#define LIGHTING_SOFT_THRESHOLD 0.05 // If the max of the lighting lumcounts of each spectrum drops below this, disable luminosity on the lighting overlays.

// If I were you I'd leave this alone.
#define LIGHTING_BASE_MATRIX \
	list                     \
	(                        \
		LIGHTING_SOFT_THRESHOLD, LIGHTING_SOFT_THRESHOLD, LIGHTING_SOFT_THRESHOLD, 0, \
		LIGHTING_SOFT_THRESHOLD, LIGHTING_SOFT_THRESHOLD, LIGHTING_SOFT_THRESHOLD, 0, \
		LIGHTING_SOFT_THRESHOLD, LIGHTING_SOFT_THRESHOLD, LIGHTING_SOFT_THRESHOLD, 0, \
		LIGHTING_SOFT_THRESHOLD, LIGHTING_SOFT_THRESHOLD, LIGHTING_SOFT_THRESHOLD, 0, \
		0, 0, 0, 1           \
	)                        \

//Some defines to generalise colours used in lighting.
//Important note on colors. Colors can end up significantly different from the basic html picture, especially when saturated
#define LIGHT_COLOR_RED        "#FA8282" //Warm but extremely diluted red. rgb(250, 130, 130)
#define LIGHT_COLOR_GREEN      "#64C864" //Bright but quickly dissipating neon green. rgb(100, 200, 100)
#define LIGHT_COLOR_BLUE       "#6496FA" //Cold, diluted blue. rgb(100, 150, 250)

#define LIGHT_COLOR_CYAN       "#7DE1E1" //Diluted cyan. rgb(125, 225, 225)
#define LIGHT_COLOR_PINK       "#E17DE1" //Diluted, mid-warmth pink. rgb(225, 125, 225)
#define LIGHT_COLOR_YELLOW     "#E1E17D" //Dimmed yellow, leaning kaki. rgb(225, 225, 125)
#define LIGHT_COLOR_BROWN      "#966432" //Clear brown, mostly dim. rgb(150, 100, 50)
#define LIGHT_COLOR_ORANGE     "#FA9632" //Mostly pure orange. rgb(250, 150, 50)
#define LIGHT_COLOR_PURPLE	   "#99149b"  //Sinister. (153, 20, 155)

//These ones aren't a direct colour like the ones above, because nothing would fit
#define LIGHT_COLOR_FIRE       "#FAA019" //Warm orange color, leaning strongly towards yellow. rgb(250, 160, 25)
#define LIGHT_COLOR_FLARE      "#FA644B" //Bright, non-saturated red. Leaning slightly towards pink for visibility. rgb(250, 100, 75)
#define LIGHT_COLOR_SLIME_LAMP "#AFC84B" //Weird color, between yellow and green, very slimy. rgb(175, 200, 75)
#define LIGHT_COLOR_TUNGSTEN   "#FFF5E0" //Extremely diluted yellow, close to skin color (for some reason). rgb(255, 245, 224)
#define LIGHT_COLOR_HALOGEN    "#F0FAFA" //Barely visible cyan-ish hue, as the doctor prescribed. rgb(240, 250, 250)

//Defines for lighting status, see power/lighting.dm
#define LIGHT_OK     0
//#define LIGHT_EMPTY  1
#define LIGHT_BROKEN 2
#define LIGHT_BURNED 3
