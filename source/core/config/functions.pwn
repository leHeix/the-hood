#if defined _CORE_CONFIG_FUNCTIONS_
	#endinput
#endif
#define _CORE_CONFIG_FUNCTIONS_

Config_Save()
{
	new File:cfile = fopen(!"Config.bin", io_write);
	if(!cfile)
	{
		print("[!] No se pudo guardar la configuraci�n.");
		return 0;
	}

	fblockwrite(cfile, g_rgeServerData);
	fclose(cfile);

	return 1;
}

Config_Load()
{
	new File:cfile = fopen(!"Config.bin", io_read);
	if(!cfile)
	{
		print("[!] No se pudo cargar el archivo de configuraci�n del servidor.");
		return 0;
	}

	if(flength(cfile) != (eServerData << __COMPILER_CELL_SHIFT))
	{
		print("[!] El archivo de configuraci�n guardado no es compatible.");
		fclose(cfile);
		SendRconCommand(!"exit");
		
		return 0;
	}

	fblockread(cfile, g_rgeServerData);
	fclose(cfile);
	
	return 1;
}