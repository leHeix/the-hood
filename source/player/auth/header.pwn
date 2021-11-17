#if defined _H_AUTH_
    #endinput
#endif
#define _H_AUTH_

#define INTRO_PROP_OBJECT_INDEX (0)

new 
    bool:g_rgbPasswordShown[MAX_PLAYERS char],
    g_rgiSelectedSkin[MAX_PLAYERS char];

new const
	g_rgiIntroSkins[] = {
		cellmin,

		/* Edad: 18 - 34 */
		19, 4, 12, 20, 21, 28,      // Hombres
		12, 65, 76, 139, 207,       // Mujeres

		/* Edad: 35 - 60 */
		6, 14, 15, 17, 24,          // Hombres
		11, 13, 63, 69, 148,        // Mujeres

		/* Edad: 61 - 100 */
		220, 221, 222, 262, 296,    // Hombres
		218, 10, 39, 129, 131       // Mujeres
	};