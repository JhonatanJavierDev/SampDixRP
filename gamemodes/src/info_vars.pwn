#include <YSI-Includes\YSI\y_hooks>

new
    JobsPointsLastReset,
	WarehouseOrderNum
;

forward OnInfoVarsLoaded();

hook OnDatabaseConnected() {
    LoadInfoVars();
}

LoadInfoVars()
{
	new File:file = fopen("SERVER/INFO.txt", io_read), string[256];
	if(file)
	{
		fread(file, string);
		sscanf(string, "p<,>dd", JobsPointsLastReset, WarehouseOrderNum);
		fclose(file);
	}
	CallLocalFunction("OnInfoVarsLoaded", "");
}

SaveInfoVars()
{
	new File:file = fopen("SERVER/INFO.txt", io_write), string[256];
	if(file)
	{
		format(string, sizeof string, "%d,%d", JobsPointsLastReset, WarehouseOrderNum);
		fwrite(file, string);
		fclose(file);
	}
	return 1;
}