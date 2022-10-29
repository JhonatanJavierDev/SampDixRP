#include <YSI-Includes\YSI\y_hooks>
#include <Pawn.CMD>

#define WORK_TUTORIAL_DEFAULT_TIME 5000

enum _:E_WorksTutorials {
    Float:wt_cam_X,
    Float:wt_cam_Y,
    Float:wt_cam_Z,
    Float:wt_cam_LX,
    Float:wt_cam_LY,
    Float:wt_cam_LZ,
    Float:wt_camTo_X,
    Float:wt_camTo_Y,
    Float:wt_camTo_Z,
    Float:wt_camTo_LX,
    Float:wt_camTo_LY,
    Float:wt_camTo_LZ,
    wt_WorldId,
    wt_Interior,
    wt_Time,
    wt_Audio[128],
    wt_SoundId,
    wt_Message[512]
};
new List:WorksTutorials[sizeof(work_info)];

enum E_workTutorialInfo {
    bool:wti_APPLY,
    wti_RP_STATE,
    wti_LOCAL_INTERIOR,
    wti_INTERIOR_INDEX,
    wti_INTERIOR,
    wti_WORLD,
    Float:wti_X,
    Float:wti_Y,
    Float:wti_Z,
    Float:wti_ANGLE
};

new
    bool:pInWorkTutorial[MAX_PLAYERS],
    PlayerText:pWorkTutorialTd[MAX_PLAYERS] = {PlayerText:INVALID_TEXT_DRAW, ...},
    pWorkTutorialTimer[MAX_PLAYERS] = {-1, ...},
    pWorkTutorial[MAX_PLAYERS],
    pWorkTutorialStep[MAX_PLAYERS],

    pWorkTutorialInfo[MAX_PLAYERS][E_workTutorialInfo]
;

forward OnPWorkTutorialRequestNextStep(playerid);

hook OnScriptInit() {
    new tmp_tutorial[E_WorksTutorials],
        tutorial[E_WorksTutorials];

    /* TRUCKER */
    WorksTutorials[WORK_TRUCK] = _:list_new();
    tutorial = tmp_tutorial;
    tutorial[wt_cam_X] = -463.992156; tutorial[wt_cam_Y] = -583.725708; tutorial[wt_cam_Z] = 46.475025; tutorial[wt_cam_LX] = -464.661407; tutorial[wt_cam_LY] = -583.057250; tutorial[wt_cam_LZ] = 46.150615;
    tutorial[wt_camTo_X] = -463.694183; tutorial[wt_camTo_Y] = -467.189270; tutorial[wt_camTo_Z] = 42.007614; tutorial[wt_camTo_LX] = -464.567291; tutorial[wt_camTo_LY] = -467.565643; tutorial[wt_camTo_LZ] = 41.697727;
    tutorial[wt_WorldId] = 0; tutorial[wt_Interior] = 0; tutorial[wt_Time] = 10000; tutorial[wt_SoundId] = 1138;
    tutorial[wt_Message] = "~w~Bienvenido al trabajo de ~y~camionero, ~w~para empezar, súbete a uno de los camiones que hay en el aparcamiento.";
    list_add_arr(List:WorksTutorials[WORK_TRUCK], tutorial);

    tutorial = tmp_tutorial;
    tutorial[wt_cam_X] = -542.262695; tutorial[wt_cam_Y] = -485.618560; tutorial[wt_cam_Z] = 32.136398; tutorial[wt_cam_LX] = -541.493957; tutorial[wt_cam_LY] = -486.187011; tutorial[wt_cam_LZ] = 31.843217;
    tutorial[wt_WorldId] = 0; tutorial[wt_Interior] = 0; tutorial[wt_Time] = 10000; tutorial[wt_SoundId] = 1138;
    tutorial[wt_Message] = "~w~Una vez en el camión, presiona ~y~~k~~CONVERSATION_YES~ ~w~para arrancarlo, colocalo en cualquiera de los puntos de carga y usa ~y~/cargar.";
    list_add_arr(List:WorksTutorials[WORK_TRUCK], tutorial);

    tutorial = tmp_tutorial;
    tutorial[wt_cam_X] = -513.902832; tutorial[wt_cam_Y] = -497.113525; tutorial[wt_cam_Z] = 26.966951; tutorial[wt_cam_LX] = -513.222900; tutorial[wt_cam_LY] = -497.828186; tutorial[wt_cam_LZ] = 26.802854;
    tutorial[wt_WorldId] = 0; tutorial[wt_Interior] = 0; tutorial[wt_Time] = 10000; tutorial[wt_SoundId] = 1138;
    tutorial[wt_Message] = "~y~¡Trabaja duro y queda entre los mejores empleados para obtener premios!";
    list_add_arr(List:WorksTutorials[WORK_TRUCK], tutorial);

    /* TAXIST */
    WorksTutorials[WORK_TAXI] = _:list_new();
    tutorial = tmp_tutorial;
    tutorial[wt_cam_X] = 1754.477539; tutorial[wt_cam_Y] = -1885.092651; tutorial[wt_cam_Z] = 25.960100; tutorial[wt_cam_LX] = 1755.028930; tutorial[wt_cam_LY] = -1885.866577; tutorial[wt_cam_LZ] = 25.648502;
    tutorial[wt_camTo_X] = 1810.973754; tutorial[wt_camTo_Y] = -1886.112548; tutorial[wt_camTo_Z] = 17.234500; tutorial[wt_camTo_LX] = 1810.327758; tutorial[wt_camTo_LY] = -1886.838256; tutorial[wt_camTo_LZ] = 16.997558;
    tutorial[wt_WorldId] = 0; tutorial[wt_Interior] = 0; tutorial[wt_Time] = 10000; tutorial[wt_SoundId] = 1138;
    tutorial[wt_Message] = "~w~Bienvenido al trabajo de ~y~taxista, ~w~para empezar, súbete a uno de los taxis que hay en el aparcamiento.";
    list_add_arr(List:WorksTutorials[WORK_TAXI], tutorial);

    tutorial = tmp_tutorial;
    tutorial[wt_cam_X] = 1768.793823; tutorial[wt_cam_Y] = -1943.608398; tutorial[wt_cam_Z] = 17.124599; tutorial[wt_cam_LX] = 1769.394897; tutorial[wt_cam_LY] = -1942.836181; tutorial[wt_cam_LZ] = 16.918586;
    tutorial[wt_WorldId] = 0; tutorial[wt_Interior] = 0; tutorial[wt_Time] = 10000; tutorial[wt_SoundId] = 1138;
    tutorial[wt_Message] = "~w~Una vez en el taxi, utiliza ~y~/tarifa ~w~para ajustar la tarifa.~n~~n~Una vez ajustada, empezarás a recibir llamadas~n~de los clientes, se te marcarán en el mapa de color ~y~amarillo~w~.";
    list_add_arr(List:WorksTutorials[WORK_TAXI], tutorial);

    /* MECANICO */
    WorksTutorials[WORK_MECANICO] = _:list_new();
    tutorial = tmp_tutorial;
    tutorial[wt_cam_X] = 1854.805541; tutorial[wt_cam_Y] = -1396.420166; tutorial[wt_cam_Z] = 19.928899; tutorial[wt_cam_LX] = 1853.987060; tutorial[wt_cam_LY] = -1396.945068; tutorial[wt_cam_LZ] = 19.695144;
    tutorial[wt_camTo_X] = 1857.526611; tutorial[wt_camTo_Y] = -1464.130615; tutorial[wt_camTo_Z] = 19.833200; tutorial[wt_camTo_LX] = 1856.937622; tutorial[wt_camTo_LY] = -1463.349121; tutorial[wt_camTo_LZ] = 19.627185;
    tutorial[wt_WorldId] = 0; tutorial[wt_Interior] = 0; tutorial[wt_Time] = 10000; tutorial[wt_SoundId] = 1138;
    tutorial[wt_Message] = "~w~Bienvenido al trabajo de ~y~mecánico~w~. En este trabajo podrás reparar, pintar o tunear los vehículos de otros jugadores.";
    list_add_arr(List:WorksTutorials[WORK_MECANICO], tutorial);

    tutorial = tmp_tutorial;
    tutorial[wt_cam_X] = 1829.248657; tutorial[wt_cam_Y] = -1443.120849; tutorial[wt_cam_Z] = 15.267800; tutorial[wt_cam_LX] = 1830.200195; tutorial[wt_cam_LY] = -1443.111328; tutorial[wt_cam_LZ] = 14.960361;
    tutorial[wt_WorldId] = 0; tutorial[wt_Interior] = 0; tutorial[wt_Time] = 10000; tutorial[wt_SoundId] = 1138;
    tutorial[wt_Message] = "~w~Para empezar, utiliza el comando ~y~/mecanico~w~ en esta posición para ponerte en servicio.~n~~n~Mientras estés en servicio, se te marcarán ~y~en el mapa~w~ la posición de los que necesiten un mecánico.~n~También puedes utilizar el comando ~y~/mapa~w~ para ver la posición de las personas que necesitan un mecánico.";
    list_add_arr(List:WorksTutorials[WORK_MECANICO], tutorial);

    tutorial = tmp_tutorial;
    tutorial[wt_cam_X] = 1826.096191; tutorial[wt_cam_Y] = -1441.923950; tutorial[wt_cam_Z] = 14.965800; tutorial[wt_cam_LX] = 1826.075805; tutorial[wt_cam_LY] = -1442.907592; tutorial[wt_cam_LZ] = 14.786616;
    tutorial[wt_WorldId] = 0; tutorial[wt_Interior] = 0; tutorial[wt_Time] = 10000; tutorial[wt_SoundId] = 1138;
    tutorial[wt_Message] = "~w~Para ~y~pintar, reparar o tunear~w~ necesitarás piezas. Aquí podrás comprarlas.~n~~n~Cada pieza tiene un precio de ~y~50 dólares~w~.";
    list_add_arr(List:WorksTutorials[WORK_MECANICO], tutorial);

    tutorial = tmp_tutorial;
    tutorial[wt_cam_X] = 1829.212768; tutorial[wt_cam_Y] = -1424.486938; tutorial[wt_cam_Z] = 14.771699; tutorial[wt_cam_LX] = 1829.684692; tutorial[wt_cam_LY] = -1423.614990; tutorial[wt_cam_LZ] = 14.641135;
    tutorial[wt_WorldId] = 0; tutorial[wt_Interior] = 0; tutorial[wt_Time] = 10000; tutorial[wt_SoundId] = 1138;
    tutorial[wt_Message] = "~y~¡Trabaja duro y queda entre los mejores empleados para obtener premios!";
    list_add_arr(List:WorksTutorials[WORK_MECANICO], tutorial);

    /* HARVESTER */
    WorksTutorials[WORK_HARVESTER] = _:list_new();
    tutorial = tmp_tutorial;
    tutorial[wt_cam_X] = -359.034606; tutorial[wt_cam_Y] = -1519.300170; tutorial[wt_cam_Z] = 29.057399; tutorial[wt_cam_LX] = -359.716033; tutorial[wt_cam_LY] = -1518.592163; tutorial[wt_cam_LZ] = 28.871763;
    tutorial[wt_camTo_X] = -344.665893; tutorial[wt_camTo_Y] = -1427.727905; tutorial[wt_camTo_Z] = 36.430400; tutorial[wt_camTo_LX] = -345.415679; tutorial[wt_camTo_LY] = -1428.365722; tutorial[wt_camTo_LZ] = 36.254447;
    tutorial[wt_WorldId] = 0; tutorial[wt_Interior] = 0; tutorial[wt_Time] = 10000; tutorial[wt_SoundId] = 1138;
    tutorial[wt_Message] = "~w~Bienvenido al trabajo de ~y~cosechador~w~. En este trabajo te encargarás de cosechar las plantaciones de esta zona.";
    list_add_arr(List:WorksTutorials[WORK_HARVESTER], tutorial);

    tutorial = tmp_tutorial;
    tutorial[wt_cam_X] = -368.471496; tutorial[wt_cam_Y] = -1454.408447; tutorial[wt_cam_Z] = 28.408199; tutorial[wt_cam_LX] = -368.550109; tutorial[wt_cam_LY] = -1455.377075; tutorial[wt_cam_LZ] = 28.172317;
    tutorial[wt_WorldId] = 0; tutorial[wt_Interior] = 0; tutorial[wt_Time] = 10000; tutorial[wt_SoundId] = 1138;
    tutorial[wt_Message] = "~w~Para empezar, simplemente súbete a una cosechadora.~n~~n~Una vez te montes, dirígete a los ~y~puntos marcados en el mapa~w~ para ir cosechando las plantaciones.";
    list_add_arr(List:WorksTutorials[WORK_HARVESTER], tutorial);

    tutorial = tmp_tutorial;
    tutorial[wt_cam_X] = -376.482299; tutorial[wt_cam_Y] = -1443.750610; tutorial[wt_cam_Z] = 28.370899; tutorial[wt_cam_LX] = -375.678710; tutorial[wt_cam_LY] = -1444.266967; tutorial[wt_cam_LZ] = 28.074932;
    tutorial[wt_WorldId] = 0; tutorial[wt_Interior] = 0; tutorial[wt_Time] = 10000; tutorial[wt_SoundId] = 1138;
    tutorial[wt_Message] = "~y~¡Trabaja duro y queda entre los mejores empleados para obtener premios!";
    list_add_arr(List:WorksTutorials[WORK_HARVESTER], tutorial);

    /* FUMIGATOR */
    WorksTutorials[WORK_FUMIGATOR] = _:list_new();
    tutorial = tmp_tutorial;
    tutorial[wt_cam_X] = -1397.525024; tutorial[wt_cam_Y] = -2174.577392; tutorial[wt_cam_Z] = 33.632400; tutorial[wt_cam_LX] = -1396.711425; tutorial[wt_cam_LY] = -2174.055908; tutorial[wt_cam_LZ] = 33.375320;
    tutorial[wt_camTo_X] = -1380.443359; tutorial[wt_camTo_Y] = -2207.241455; tutorial[wt_camTo_Z] = 27.309200; tutorial[wt_camTo_LX] = -1379.830078; tutorial[wt_camTo_LY] = -2206.487060; tutorial[wt_camTo_LZ] = 27.075445;
    tutorial[wt_WorldId] = 0; tutorial[wt_Interior] = 0; tutorial[wt_Time] = 10000; tutorial[wt_SoundId] = 1138;
    tutorial[wt_Message] = "~w~Bienvenido al trabajo de ~y~fumigador~w~. En este trabajo te encargarás de fumigar las plantaciones de San Andreas.";
    list_add_arr(List:WorksTutorials[WORK_FUMIGATOR], tutorial);

    tutorial = tmp_tutorial;
    tutorial[wt_cam_X] = -1332.588745; tutorial[wt_cam_Y] = -2165.710449; tutorial[wt_cam_Z] = 28.482200; tutorial[wt_cam_LX] = -1333.485107; tutorial[wt_cam_LY] = -2166.057128; tutorial[wt_cam_LZ] = 28.206144;
    tutorial[wt_WorldId] = 0; tutorial[wt_Interior] = 0; tutorial[wt_Time] = 10000; tutorial[wt_SoundId] = 1138;
    tutorial[wt_Message] = "~w~Para empezar, simplemente súbete a una avioneta.~n~~n~Una vez te montes, dirígete a los ~y~puntos marcados en el mapa~w~ para ir fumigando las plantaciones.";
    list_add_arr(List:WorksTutorials[WORK_FUMIGATOR], tutorial);

    tutorial = tmp_tutorial;
    tutorial[wt_cam_X] = -1345.540771; tutorial[wt_cam_Y] = -2184.027343; tutorial[wt_cam_Z] = 25.007900; tutorial[wt_cam_LX] = -1345.635620; tutorial[wt_cam_LY] = -2184.991455; tutorial[wt_cam_LZ] = 24.760343;
    tutorial[wt_WorldId] = 0; tutorial[wt_Interior] = 0; tutorial[wt_Time] = 10000; tutorial[wt_SoundId] = 1138;
    tutorial[wt_Message] = "~y~¡Trabaja duro y queda entre los mejores empleados para obtener premios!";
    list_add_arr(List:WorksTutorials[WORK_FUMIGATOR], tutorial);

    /* TRASH */
    WorksTutorials[WORK_TRASH] = _:list_new();
    tutorial = tmp_tutorial;
    tutorial[wt_cam_X] = -1920.069824; tutorial[wt_cam_Y] = -1752.156860; tutorial[wt_cam_Z] = 27.694799; tutorial[wt_cam_LX] = -1919.210083; tutorial[wt_cam_LY] = -1751.690063; tutorial[wt_cam_LZ] = 27.487714;
    tutorial[wt_camTo_X] = -1920.909179; tutorial[wt_camTo_Y] = -1686.411010; tutorial[wt_camTo_Z] = 35.096000; tutorial[wt_camTo_LX] = -1920.238403; tutorial[wt_camTo_LY] = -1687.074584; tutorial[wt_camTo_LZ] = 34.764724;
    tutorial[wt_WorldId] = 0; tutorial[wt_Interior] = 0; tutorial[wt_Time] = 10000; tutorial[wt_SoundId] = 1138;
    tutorial[wt_Message] = "~w~Bienvenido al trabajo de ~y~basurero~w~. En este trabajo te encargarás de recoger la basura de las calles.";
    list_add_arr(List:WorksTutorials[WORK_TRASH], tutorial);

    tutorial = tmp_tutorial;
    tutorial[wt_cam_X] = -1878.114624; tutorial[wt_cam_Y] = -1727.117187; tutorial[wt_cam_Z] = 24.312299; tutorial[wt_cam_LX] = -1878.477416; tutorial[wt_cam_LY] = -1728.032348; tutorial[wt_cam_LZ] = 24.136344;
    tutorial[wt_WorldId] = 0; tutorial[wt_Interior] = 0; tutorial[wt_Time] = 10000; tutorial[wt_SoundId] = 1138;
    tutorial[wt_Message] = "~w~Para empezar, súbete a un camión de basura.~n~~n~Una vez te subas, deberás encontrar ~y~un compañero~w~, el cual se deberá subir de copiloto.~n~En cuanto se suba, se abrirá un menú en el cual podrás elegir ~y~la ruta~w~ a realizar.";
    list_add_arr(List:WorksTutorials[WORK_TRASH], tutorial);

    tutorial = tmp_tutorial;
    tutorial[wt_cam_X] = -1906.759765; tutorial[wt_cam_Y] = -1747.682617; tutorial[wt_cam_Z] = 24.674100; tutorial[wt_cam_LX] = -1905.889160; tutorial[wt_cam_LY] = -1748.087768; tutorial[wt_cam_LZ] = 24.394893;
    tutorial[wt_WorldId] = 0; tutorial[wt_Interior] = 0; tutorial[wt_Time] = 10000; tutorial[wt_SoundId] = 1138;
    tutorial[wt_Message] = "~y~¡Trabaja duro y queda entre los mejores empleados para obtener premios!";
    list_add_arr(List:WorksTutorials[WORK_TRASH], tutorial);

    /* LUMBERJACK */
    WorksTutorials[WORK_LUMBERJACK] = _:list_new();
    tutorial = tmp_tutorial;
    tutorial[wt_cam_X] = -556.541503; tutorial[wt_cam_Y] = -59.356700; tutorial[wt_cam_Z] = 73.218803; tutorial[wt_cam_LX] = -555.720825; tutorial[wt_cam_LY] = -58.867893; tutorial[wt_cam_LZ] = 72.922836;
    tutorial[wt_camTo_X] = -504.841400; tutorial[wt_camTo_Y] = -130.117797; tutorial[wt_camTo_Z] = 71.737197; tutorial[wt_camTo_LX] = -504.465362; tutorial[wt_camTo_LY] = -129.258087; tutorial[wt_camTo_LZ] = 71.391510;
    tutorial[wt_WorldId] = 0; tutorial[wt_Interior] = 0; tutorial[wt_Time] = 10000; tutorial[wt_SoundId] = 1138;
    tutorial[wt_Message] = "~w~Bienvenido al trabajo de ~y~leñador~w~. En este trabajo te encargarás de talar árboles y entregar la madera.";
    list_add_arr(List:WorksTutorials[WORK_LUMBERJACK], tutorial);

    tutorial = tmp_tutorial;
    tutorial[wt_cam_X] = -528.886108; tutorial[wt_cam_Y] = -99.879203; tutorial[wt_cam_Z] = 64.222000; tutorial[wt_cam_LX] = -528.507751; tutorial[wt_cam_LY] = -99.035293; tutorial[wt_cam_LZ] = 63.841667;
    tutorial[wt_WorldId] = 0; tutorial[wt_Interior] = 0; tutorial[wt_Time] = 10000; tutorial[wt_SoundId] = 1138;
    tutorial[wt_Message] = "~w~Para empezar, dirígete a esta posición.~n~~n~Aquí podrás empezar a trabajar utilizando el comando ~y~/talar~w~.";
    list_add_arr(List:WorksTutorials[WORK_LUMBERJACK], tutorial);

    tutorial = tmp_tutorial;
    tutorial[wt_cam_X] = -499.863311; tutorial[wt_cam_Y] = -26.915500; tutorial[wt_cam_Z] = 76.783302; tutorial[wt_cam_LX] = -499.247253; tutorial[wt_cam_LY] = -27.592605; tutorial[wt_cam_LZ] = 76.380828;
    tutorial[wt_WorldId] = 0; tutorial[wt_Interior] = 0; tutorial[wt_Time] = 10000; tutorial[wt_SoundId] = 1138;
    tutorial[wt_Message] = "~w~Una vez hayas empezado a trabajar, dirígete a esta ~y~zona~w~.~n~~n~Aquí, acércate a uno de los arboles y utiliza el comando ~y~/talar~w~.~n~Una vez hayas talado el árbol, deberás recoger la madera y entregarla en el ~y~punto marcado en el mapa~w~.";
    list_add_arr(List:WorksTutorials[WORK_LUMBERJACK], tutorial);

    tutorial = tmp_tutorial;
    tutorial[wt_cam_X] = -531.139892; tutorial[wt_cam_Y] = -90.969299; tutorial[wt_cam_Z] = 65.376998; tutorial[wt_cam_LX] = -530.583251; tutorial[wt_cam_LY] = -91.768951; tutorial[wt_cam_LZ] = 65.151756;
    tutorial[wt_WorldId] = 0; tutorial[wt_Interior] = 0; tutorial[wt_Time] = 10000; tutorial[wt_SoundId] = 1138;
    tutorial[wt_Message] = "~y~¡Trabaja duro y queda entre los mejores empleados para obtener premios!";
    list_add_arr(List:WorksTutorials[WORK_LUMBERJACK], tutorial);

    /* FARMER */
    WorksTutorials[WORK_FARMER] = _:list_new();
    tutorial = tmp_tutorial;
    tutorial[wt_cam_X] = 1570.038940; tutorial[wt_cam_Y] = 62.085700; tutorial[wt_cam_Z] = 33.524898; tutorial[wt_cam_LX] = 1569.522094; tutorial[wt_cam_LY] = 61.269828; tutorial[wt_cam_LZ] = 33.265705;
    tutorial[wt_camTo_X] = 1584.568481; tutorial[wt_camTo_Y] = -45.529899; tutorial[wt_camTo_Z] = 33.473300; tutorial[wt_camTo_LX] = 1583.854248; tutorial[wt_camTo_LY] = -44.874034; tutorial[wt_camTo_LZ] = 33.228927;
    tutorial[wt_WorldId] = 0; tutorial[wt_Interior] = 0; tutorial[wt_Time] = 10000; tutorial[wt_SoundId] = 1138;
    tutorial[wt_Message] = "~w~Bienvenido al trabajo de ~y~agricultor~w~. En este trabajo podrás plantar plantas y cosechar ~y~medicamentos, crack o marihuana~w~.";
    list_add_arr(List:WorksTutorials[WORK_FARMER], tutorial);

    tutorial = tmp_tutorial;
    tutorial[wt_cam_X] = 1570.038452; tutorial[wt_cam_Y] = 29.206199; tutorial[wt_cam_Z] = 24.983200; tutorial[wt_cam_LX] = 1569.136352; tutorial[wt_cam_LY] = 29.592052; tutorial[wt_cam_LZ] = 24.790046;
    tutorial[wt_WorldId] = 0; tutorial[wt_Interior] = 0; tutorial[wt_Time] = 10000; tutorial[wt_SoundId] = 1138;
    tutorial[wt_Message] = "~w~Para empezar, dirígete a esta posición.~n~~n~Aquí podrás comprar semillas utilizando el comando ~y~/semillas~w~.";
    list_add_arr(List:WorksTutorials[WORK_FARMER], tutorial);

    tutorial = tmp_tutorial;
    tutorial[wt_cam_X] = 1542.819458; tutorial[wt_cam_Y] = -63.740398; tutorial[wt_cam_Z] = 36.975399; tutorial[wt_cam_LX] = 1541.876586; tutorial[wt_cam_LY] = -63.837127; tutorial[wt_cam_LZ] = 36.656536;
    tutorial[wt_WorldId] = 0; tutorial[wt_Interior] = 0; tutorial[wt_Time] = 10000; tutorial[wt_SoundId] = 1138;
    tutorial[wt_Message] = "~w~Una vez hayas comprado semillas, dirígete a esta ~y~zona~w~.~n~~n~Aquí, utiliza el comando ~y~/plantar~w~. Una vez termines el minijuego, la planta aparecerá en el suelo.~n~Luego, deberás esperar ~y~1 minuto~w~ para que la planta crezca y poder cosecharla.";
    list_add_arr(List:WorksTutorials[WORK_FARMER], tutorial);

    tutorial = tmp_tutorial;
    tutorial[wt_cam_X] = 1557.666748; tutorial[wt_cam_Y] = 26.098199; tutorial[wt_cam_Z] = 25.224800; tutorial[wt_cam_LX] = 1558.234375; tutorial[wt_cam_LY] = 26.910928; tutorial[wt_cam_LZ] = 25.093152;
    tutorial[wt_WorldId] = 0; tutorial[wt_Interior] = 0; tutorial[wt_Time] = 10000; tutorial[wt_SoundId] = 1138;
    tutorial[wt_Message] = "~y~¡Trabaja duro y queda entre los mejores empleados para obtener premios!";
    list_add_arr(List:WorksTutorials[WORK_FARMER], tutorial);

    /* PIZZA */
    WorksTutorials[WORK_PIZZA] = _:list_new();
    tutorial = tmp_tutorial;
    tutorial[wt_cam_X] = 2075.375976; tutorial[wt_cam_Y] = -1767.843017; tutorial[wt_cam_Z] = 24.193700; tutorial[wt_cam_LX] = 2076.317382; tutorial[wt_cam_LY] = -1768.114501; tutorial[wt_cam_LZ] = 23.994112;
    tutorial[wt_camTo_X] = 2080.380615; tutorial[wt_camTo_Y] = -1835.220581; tutorial[wt_camTo_Z] = 14.454500; tutorial[wt_camTo_LX] = 2081.107421; tutorial[wt_camTo_LY] = -1834.547119; tutorial[wt_camTo_LZ] = 14.319600;
    tutorial[wt_WorldId] = 0; tutorial[wt_Interior] = 0; tutorial[wt_Time] = 10000; tutorial[wt_SoundId] = 1138;
    tutorial[wt_Message] = "~w~Bienvenido al trabajo de ~y~pizzero~w~. En este trabajo te encargarás de repartir pizzas a domicilio.";
    list_add_arr(List:WorksTutorials[WORK_PIZZA], tutorial);

    tutorial = tmp_tutorial;
    tutorial[wt_cam_X] = 2099.524902; tutorial[wt_cam_Y] = -1821.809814; tutorial[wt_cam_Z] = 14.583600; tutorial[wt_cam_LX] = 2098.996093; tutorial[wt_cam_LY] = -1820.978637; tutorial[wt_cam_LZ] = 14.411953;
    tutorial[wt_WorldId] = 0; tutorial[wt_Interior] = 0; tutorial[wt_Time] = 10000; tutorial[wt_SoundId] = 1138;
    tutorial[wt_Message] = "~w~Para empezar a trabajar, dirígete a esta ~y~zona~w~.~n~~n~Después de empezar a trabajar, súbete a una de las motos. Una vez te subas, se te marcará ~y~en el mapa~w~ dónde debes entregar las pizzas.";
    list_add_arr(List:WorksTutorials[WORK_PIZZA], tutorial);

    /* MEDIC */
    WorksTutorials[WORK_MEDIC] = _:list_new();
    tutorial = tmp_tutorial;
    tutorial[wt_cam_X] = 1202.697875; tutorial[wt_cam_Y] = -1296.069946; tutorial[wt_cam_Z] = 21.061700; tutorial[wt_cam_LX] = 1201.950195; tutorial[wt_cam_LY] = -1296.688232; tutorial[wt_cam_LZ] = 20.819448;
    tutorial[wt_camTo_X] = 1201.805053; tutorial[wt_camTo_Y] = -1359.733276; tutorial[wt_camTo_Z] = 20.949600; tutorial[wt_camTo_LX] = 1201.121459; tutorial[wt_camTo_LY] = -1359.034301; tutorial[wt_camTo_LZ] = 20.739307;
    tutorial[wt_WorldId] = 0; tutorial[wt_Interior] = 0; tutorial[wt_Time] = 10000; tutorial[wt_SoundId] = 1138;
    tutorial[wt_Message] = "~w~Bienvenido al trabajo de ~y~médico~w~. En este trabajo te encargarás de salvar las vidas de las personas.";
    list_add_arr(List:WorksTutorials[WORK_MEDIC], tutorial);

    tutorial = tmp_tutorial;
    tutorial[wt_cam_X] = 1188.371093; tutorial[wt_cam_Y] = -1344.757812; tutorial[wt_cam_Z] = 14.497900; tutorial[wt_cam_LX] = 1187.781982; tutorial[wt_cam_LY] = -1343.955200; tutorial[wt_cam_LZ] = 14.404287;
    tutorial[wt_WorldId] = 0; tutorial[wt_Interior] = 0; tutorial[wt_Time] = 10000; tutorial[wt_SoundId] = 1138;
    tutorial[wt_Message] = "~w~Una vez hayas empezado a trabajar, dirígete a esta ~y~zona~w~.~n~~n~Aquí, súbete a una de las ambulancias. Una vez te subas, se te marcará ~y~en el mapa~w~ la posición de los pacientes que soliciten serivicio médico.~n~Una vez llegues a la posición marcada, utiliza el comando ~y~/curar~w~ para curarle.";
    list_add_arr(List:WorksTutorials[WORK_MEDIC], tutorial);

    /* WAREHOUSE */
    WorksTutorials[WORK_WAREHOUSE] = _:list_new();
    tutorial = tmp_tutorial;
    tutorial[wt_cam_X] = 1919.761474; tutorial[wt_cam_Y] = -1489.925415; tutorial[wt_cam_Z] = 1398.321533; tutorial[wt_cam_LX] = 1918.970947; tutorial[wt_cam_LY] = -1489.318115; tutorial[wt_cam_LZ] = 1398.242553;
    tutorial[wt_camTo_X] = 1907.615478; tutorial[wt_camTo_Y] = -1480.548339; tutorial[wt_camTo_Z] = 1400.042236; tutorial[wt_camTo_LX] = 1906.666381; tutorial[wt_camTo_LY] = -1480.758422; tutorial[wt_camTo_LZ] = 1399.807373;
    tutorial[wt_WorldId] = 0; tutorial[wt_Interior] = 11; tutorial[wt_Time] = 10000; tutorial[wt_SoundId] = 1138;
    tutorial[wt_Message] = "~w~Bienvenido al trabajo en el ~y~almacén~w~. Para empezar a atender pedidos ve hasta la oficina situada en la planta superior.";
    list_add_arr(List:WorksTutorials[WORK_WAREHOUSE], tutorial);

    tutorial = tmp_tutorial;
    tutorial[wt_cam_X] = 1931.449218; tutorial[wt_cam_Y] = -1505.929565; tutorial[wt_cam_Z] = 1399.470092; tutorial[wt_cam_LX] = 1930.528320; tutorial[wt_cam_LY] = -1505.604614; tutorial[wt_cam_LZ] = 1399.254882;
    tutorial[wt_WorldId] = 0; tutorial[wt_Interior] = 11; tutorial[wt_Time] = 10000; tutorial[wt_SoundId] = 1138;
    tutorial[wt_Message] = "~w~Tendrás que coger los distintos productos del pedido y dejarlos en la ~y~cinta transportadora ~w~para entregarlos.";
    list_add_arr(List:WorksTutorials[WORK_WAREHOUSE], tutorial);

    tutorial = tmp_tutorial;
    tutorial[wt_cam_X] = 1932.742187; tutorial[wt_cam_Y] = -1509.604858; tutorial[wt_cam_Z] = 1396.048828; tutorial[wt_cam_LX] = 1932.122070; tutorial[wt_cam_LY] = -1510.365356; tutorial[wt_cam_LZ] = 1395.856079;
    tutorial[wt_WorldId] = 0; tutorial[wt_Interior] = 11; tutorial[wt_Time] = 10000; tutorial[wt_SoundId] = 1138;
    tutorial[wt_Message] = "~y~¡Trabaja duro y queda entre los mejores empleados para obtener premios!";
    list_add_arr(List:WorksTutorials[WORK_WAREHOUSE], tutorial);

    /* DELIVERYMAN */
    WorksTutorials[WORK_DELIVERYMAN] = _:list_new();
    tutorial = tmp_tutorial;
    tutorial[wt_cam_X] = -1075.288696; tutorial[wt_cam_Y] = -567.195434; tutorial[wt_cam_Z] = 40.046535; tutorial[wt_cam_LX] = -1074.626342; tutorial[wt_cam_LY] = -567.905273; tutorial[wt_cam_LZ] = 39.806961;
    tutorial[wt_camTo_X] = -1071.123046; tutorial[wt_camTo_Y] = -594.222167; tutorial[wt_camTo_Z] = 52.977615; tutorial[wt_camTo_LX] = -1070.532104; tutorial[wt_camTo_LY] = -594.989868; tutorial[wt_camTo_LZ] = 52.729686;
    tutorial[wt_WorldId] = 0; tutorial[wt_Interior] = 0; tutorial[wt_Time] = 10000; tutorial[wt_SoundId] = 1138;
    tutorial[wt_Message] = "~w~Bienvenido al trabajo de ~y~repartidor, ~w~para empezar, súbete a una de las furgonetas que hay en el aparcamiento.";
    list_add_arr(List:WorksTutorials[WORK_DELIVERYMAN], tutorial);

    tutorial = tmp_tutorial;
    tutorial[wt_cam_X] = -1022.709472; tutorial[wt_cam_Y] = -637.135192; tutorial[wt_cam_Z] = 39.608303; tutorial[wt_cam_LX] = -1023.202697; tutorial[wt_cam_LY] = -637.966491; tutorial[wt_cam_LZ] = 39.352039;
    tutorial[wt_WorldId] = 0; tutorial[wt_Interior] = 0; tutorial[wt_Time] = 10000; tutorial[wt_SoundId] = 1138;
    tutorial[wt_Message] = "~w~Una vez en la furgoneta, presiona ~y~~k~~CONVERSATION_YES~ ~w~para arrancarla, colocala en cualquiera de los puntos de carga y usa ~y~/cargar.";
    list_add_arr(List:WorksTutorials[WORK_DELIVERYMAN], tutorial);

    tutorial = tmp_tutorial;
    tutorial[wt_cam_X] = -1017.886291; tutorial[wt_cam_Y] = -601.709960; tutorial[wt_cam_Z] = 33.938503; tutorial[wt_cam_LX] = -1018.523315; tutorial[wt_cam_LY] = -600.961975; tutorial[wt_cam_LZ] = 33.752220;
    tutorial[wt_WorldId] = 0; tutorial[wt_Interior] = 0; tutorial[wt_Time] = 10000; tutorial[wt_SoundId] = 1138;
    tutorial[wt_Message] = "~y~¡Trabaja duro y queda entre los mejores empleados para obtener premios!";
    list_add_arr(List:WorksTutorials[WORK_DELIVERYMAN], tutorial);
}

hook OnPlayerDisconnect(playerid, reason) {
    DestroyPlayerWorkTutorial(playerid);

    new tmp_pWorkTutorialInfo[E_workTutorialInfo];
    pWorkTutorialInfo[playerid] = tmp_pWorkTutorialInfo;
}

hook OnPlayerDeath(playerid, killerid, reason) {
    if(pInWorkTutorial[playerid])
    DestroyPlayerWorkTutorial(playerid);
}

hook OnPlayerObtainWork(playerid, work) {
    if(PLAYER_WORKS[playerid][work][pwork_LEVEL] <= 0 && list_valid(WorksTutorials[work]) && list_size(WorksTutorials[work]) > 0) {
        StartPlayerWorkTutorial(playerid, work);
    }
    else {
        SendFormatNotification(playerid, "¡Felicidades! Has conseguido tu trabajo de ~b~%s~w~.", work_info[work][work_info_NAME]);
		SendNotification(playerid, "Puedes utilizar ~y~/ayuda trabajos ~w~para ver como trabajar aquí.");
    }
}

hook OnPlayerSpawn(playerid) {
    if(pWorkTutorialInfo[playerid][wti_APPLY]) {
        PI[playerid][pi_STATE] = pWorkTutorialInfo[playerid][wti_RP_STATE];
        PI[playerid][pi_LOCAL_INTERIOR] = pWorkTutorialInfo[playerid][wti_LOCAL_INTERIOR];
        PLAYER_TEMP[playerid][pt_INTERIOR_INDEX] = pWorkTutorialInfo[playerid][wti_INTERIOR_INDEX];
        SetPlayerPosEx(playerid, pWorkTutorialInfo[playerid][wti_X], pWorkTutorialInfo[playerid][wti_Y], pWorkTutorialInfo[playerid][wti_Z], pWorkTutorialInfo[playerid][wti_ANGLE], pWorkTutorialInfo[playerid][wti_INTERIOR], pWorkTutorialInfo[playerid][wti_WORLD], 1);

        new tmp_pWorkTutorialInfo[E_workTutorialInfo];
        pWorkTutorialInfo[playerid] = tmp_pWorkTutorialInfo;
    }
}

DestroyPlayerWorkTutorial(playerid) {
    if(pWorkTutorialTimer[playerid] != -1) {
        KillTimer(pWorkTutorialTimer[playerid]);
        pWorkTutorialTimer[playerid] = -1;
    }

    if(pWorkTutorialTd[playerid] != PlayerText:INVALID_TEXT_DRAW) {
        PlayerTextDrawDestroy(playerid, pWorkTutorialTd[playerid]);
        pWorkTutorialTd[playerid] = PlayerText:INVALID_TEXT_DRAW;
    }
    
    pWorkTutorial[playerid] = 0;
    pWorkTutorialStep[playerid] = 0;

    if(PI[playerid][pi_ID] > 0 && pInWorkTutorial[playerid]) {
        TogglePlayerSpectatingEx(playerid, false);
        SetPlayerHud(playerid);
    }
    pInWorkTutorial[playerid] = false;
}

StartPlayerWorkTutorial(playerid, work) {
    HideNotifications(playerid);
    ClearPlayerChat(playerid);
    
    GetPlayerHealth(playerid, PI[playerid][pi_HEALTH]);
	GetPlayerArmour(playerid, PI[playerid][pi_ARMOUR]);
    PI[playerid][pi_POS_X] = obtain_work_coords[work][obtain_work_X];
    PI[playerid][pi_POS_Y] = obtain_work_coords[work][obtain_work_Y];
    PI[playerid][pi_POS_Z] = obtain_work_coords[work][obtain_work_Z];
    GetPlayerFacingAngle(playerid, PI[playerid][pi_ANGLE]);
    PI[playerid][pi_INTERIOR] = obtain_work_coords[work][obtain_work_INTERIOR];

    pWorkTutorialInfo[playerid][wti_APPLY] = true;
    pWorkTutorialInfo[playerid][wti_RP_STATE] = PI[playerid][pi_STATE];
    pWorkTutorialInfo[playerid][wti_LOCAL_INTERIOR] = PI[playerid][pi_LOCAL_INTERIOR];
    pWorkTutorialInfo[playerid][wti_INTERIOR_INDEX] = PLAYER_TEMP[playerid][pt_INTERIOR_INDEX];
    pWorkTutorialInfo[playerid][wti_INTERIOR] = obtain_work_coords[work][obtain_work_INTERIOR];
    pWorkTutorialInfo[playerid][wti_WORLD] = GetPlayerVirtualWorld(playerid);
    pWorkTutorialInfo[playerid][wti_X] = obtain_work_coords[work][obtain_work_X];
    pWorkTutorialInfo[playerid][wti_Y] = obtain_work_coords[work][obtain_work_Y];
    pWorkTutorialInfo[playerid][wti_Z] = obtain_work_coords[work][obtain_work_Z];
    pWorkTutorialInfo[playerid][wti_ANGLE] = PI[playerid][pi_ANGLE];

    SetSpawnInfo(playerid, NO_TEAM, PI[playerid][pi_SKIN], PI[playerid][pi_POS_X], PI[playerid][pi_POS_Y], PI[playerid][pi_POS_Z], PI[playerid][pi_ANGLE], 0, 0, 0, 0, 0, 0);

    DestroyPlayerWorkTutorial(playerid);
    
    pWorkTutorialTd[playerid] = CreatePlayerTextDraw(playerid, 320.000000, 350.000000, "_");
    PlayerTextDrawLetterSize(playerid, pWorkTutorialTd[playerid], 0.233249, 1.198665);
    PlayerTextDrawTextSize(playerid, pWorkTutorialTd[playerid], 0.000000, 300.000000);
    PlayerTextDrawAlignment(playerid, pWorkTutorialTd[playerid], 2);
    PlayerTextDrawColor(playerid, pWorkTutorialTd[playerid], -1);
    PlayerTextDrawSetShadow(playerid, pWorkTutorialTd[playerid], 0);
    PlayerTextDrawSetOutline(playerid, pWorkTutorialTd[playerid], 1);
    PlayerTextDrawBackgroundColor(playerid, pWorkTutorialTd[playerid], 255);
    PlayerTextDrawFont(playerid, pWorkTutorialTd[playerid], 1);
    PlayerTextDrawSetProportional(playerid, pWorkTutorialTd[playerid], 1);

    pInWorkTutorial[playerid] = true;
    pWorkTutorial[playerid] = work;
    TogglePlayerSpectatingEx(playerid, true);
    HidePlayerHud(playerid);
    UpdatePlayerWorkTutorial(playerid);
}

UpdatePlayerWorkTutorial(playerid) {
    if(pWorkTutorialTimer[playerid] != -1) {
        KillTimer(pWorkTutorialTimer[playerid]);
        pWorkTutorialTimer[playerid] = -1;
    }

    new
        work = pWorkTutorial[playerid],
        step = pWorkTutorialStep[playerid];

    new tutorialInfo[E_WorksTutorials];
    list_get_arr(List:WorksTutorials[work], step, tutorialInfo);
    if(tutorialInfo[wt_Time] <= 0) tutorialInfo[wt_Time] = WORK_TUTORIAL_DEFAULT_TIME;

    if(tutorialInfo[wt_camTo_X] != 0.0 && tutorialInfo[wt_camTo_Y] != 0.0 && tutorialInfo[wt_camTo_Z] != 0.0) InterpolateCameraPos(playerid, tutorialInfo[wt_cam_X], tutorialInfo[wt_cam_Y], tutorialInfo[wt_cam_Z], tutorialInfo[wt_camTo_X], tutorialInfo[wt_camTo_Y], tutorialInfo[wt_camTo_Z], tutorialInfo[wt_Time], CAMERA_MOVE);
    else SetPlayerCameraPos(playerid, tutorialInfo[wt_cam_X], tutorialInfo[wt_cam_Y], tutorialInfo[wt_cam_Z]);

    if(tutorialInfo[wt_camTo_LX] != 0.0 && tutorialInfo[wt_camTo_LY] != 0.0 && tutorialInfo[wt_camTo_LZ] != 0.0) InterpolateCameraLookAt(playerid, tutorialInfo[wt_cam_LX], tutorialInfo[wt_cam_LY], tutorialInfo[wt_cam_LZ], tutorialInfo[wt_camTo_LX], tutorialInfo[wt_camTo_LY], tutorialInfo[wt_camTo_LZ], tutorialInfo[wt_Time], CAMERA_MOVE);
    else SetPlayerCameraLookAt(playerid, tutorialInfo[wt_cam_LX], tutorialInfo[wt_cam_LY], tutorialInfo[wt_cam_LZ]);

    SetPlayerInterior(playerid, tutorialInfo[wt_Interior]);
    SetPlayerVirtualWorld(playerid, tutorialInfo[wt_WorldId]);

    if(tutorialInfo[wt_SoundId] != 0) PlayerPlaySound(playerid, tutorialInfo[wt_SoundId], 0.0, 0.0, 0.0);
    if(strlen(tutorialInfo[wt_Audio]) > 0) PlayAudioStreamForPlayer(playerid, tutorialInfo[wt_Audio]);

    if(strlen(tutorialInfo[wt_Message]) > 0) {
        PlayerTextDrawShow(playerid, pWorkTutorialTd[playerid]);
        FixTextDrawString(tutorialInfo[wt_Message]);
        PlayerTextDrawSetString(playerid, pWorkTutorialTd[playerid], tutorialInfo[wt_Message]);
    }
    else {
        PlayerTextDrawHide(playerid, pWorkTutorialTd[playerid]);
        PlayerTextDrawSetString(playerid, pWorkTutorialTd[playerid], "_");
    }

    pWorkTutorialTimer[playerid] = SetTimerEx("OnPWorkTutorialRequestNextStep", tutorialInfo[wt_Time], false, "i", playerid);   
}

public OnPWorkTutorialRequestNextStep(playerid) {
    pWorkTutorialTimer[playerid] = -1;

    new
        work = pWorkTutorial[playerid],
        step = pWorkTutorialStep[playerid];

    if(step >= list_size(WorksTutorials[work]) - 1) {
        DestroyPlayerWorkTutorial(playerid);
    }
    else {
        pWorkTutorialStep[playerid] ++;
        UpdatePlayerWorkTutorial(playerid);
    }
}

IsPlayerInWorkTutorial(playerid) {
    return pInWorkTutorial[playerid];
}