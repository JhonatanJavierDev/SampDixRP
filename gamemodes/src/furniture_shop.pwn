#include <YSI-Includes\YSI\y_hooks>

#define FURNITURE_CAMERA_MOVE_TIME 2000
#define FURNITURE_CAMERA_OBJECT_SCALE 10.0

enum FURNITURE_TYPES 
{
    FURNITURE_TYPE_BEDROOM,
    FURNITURE_TYPE_BATHROOM,
    FURNITURE_TYPE_KITCHEN,
    FURNITURE_TYPE_LIVING_ROOM,
    FURNITURE_TYPE_DECORATION,
    FURNITURE_TYPE_DOORS,
    FURNITURE_TYPE_WALLS,
    FURNITURE_TYPE_GARAJE,
    FURNITURE_TYPE_OTHERS
};

enum E_FurnitureTypesInfo 
{
    fti_NAME[32],
    Float:fti_CAM_X,
    Float:fti_CAM_Y,
    Float:fti_CAM_Z,
    Float:fti_CAM_LOOK_AT_X,
    Float:fti_CAM_LOOK_AT_Y,
    Float:fti_CAM_LOOK_AT_Z
};

new FurnitureTypesInfo[][E_FurnitureTypesInfo] = 
{
    {"Dormitorio", 1956.232055, -1817.076171, 1252.489990, 1955.514160, -1816.458862, 1252.168212},
    {"Baño", 1933.197875, -1714.829589, 1252.328735, 1933.881835, -1715.493774, 1252.026977},
    {"Cocina", 1953.703247, -1738.496704, 1252.050659, 1953.227416, -1737.662963, 1251.770629},
    {"Salón / comedor", 1955.580444, -1712.746093, 1251.999389, 1954.951416, -1713.470214, 1251.716552},
    {"Decoración", 1934.992553, -1743.235717, 1252.032104, 1935.613891, -1743.970581, 1251.760131},
    {"Puertas", 1933.297485, -1737.081054, 1252.086669, 1933.906494, -1736.344238, 1251.793090},
    {"Paredes", 1933.297485, -1737.081054, 1252.086669, 1933.906494, -1736.344238, 1251.793090},
    {"Garaje", 1934.992553, -1743.235717, 1252.032104, 1935.613891, -1743.970581, 1251.760131},
    {"Otros", 1933.297485, -1737.081054, 1252.086669, 1933.906494, -1736.344238, 1251.793090} 
};

enum E_FurnitureObjectsInfo 
{
    FURNITURE_TYPES:foi_TYPE,
    foi_MODELID,
    foi_PRICE
};

new FurnitureObjectsInfo[][E_FurnitureObjectsInfo] = 
{
    {FURNITURE_TYPE_BATHROOM, 2525, 500},
    {FURNITURE_TYPE_BATHROOM, 2521, 500},
    {FURNITURE_TYPE_BATHROOM, 2528, 550},
    {FURNITURE_TYPE_BATHROOM, 2738, 500},
    {FURNITURE_TYPE_BATHROOM, 11709, 700},
    {FURNITURE_TYPE_BATHROOM, 2602, 500},
    {FURNITURE_TYPE_BATHROOM, 19873, 300},
    {FURNITURE_TYPE_BATHROOM, 19874, 200},
    {FURNITURE_TYPE_BATHROOM, 2515, 600},
    {FURNITURE_TYPE_BATHROOM, 11707, 500},
    {FURNITURE_TYPE_BATHROOM, 2097, 1000},
    {FURNITURE_TYPE_BATHROOM, 2527, 700},
    {FURNITURE_TYPE_BATHROOM, 2616, 1200},
    {FURNITURE_TYPE_BATHROOM, 2517, 800},
    {FURNITURE_TYPE_BATHROOM, 2520, 600},
    {FURNITURE_TYPE_BATHROOM, 2522, 1100},

    {FURNITURE_TYPE_LIVING_ROOM, 1805, 400},
    {FURNITURE_TYPE_LIVING_ROOM, 1716, 300},
    {FURNITURE_TYPE_LIVING_ROOM, 1670, 100},
    {FURNITURE_TYPE_LIVING_ROOM, 2125, 300},
    {FURNITURE_TYPE_LIVING_ROOM, 11687, 400},
    {FURNITURE_TYPE_LIVING_ROOM, 2273, 300},
    {FURNITURE_TYPE_LIVING_ROOM, 19994, 300},
    {FURNITURE_TYPE_LIVING_ROOM, 1663, 600},
    {FURNITURE_TYPE_LIVING_ROOM, 1671, 700},
    {FURNITURE_TYPE_LIVING_ROOM, 2801, 200},
    {FURNITURE_TYPE_LIVING_ROOM, 1720, 300},
    {FURNITURE_TYPE_LIVING_ROOM, 2776, 250},
    {FURNITURE_TYPE_LIVING_ROOM, 1722, 100},
    {FURNITURE_TYPE_LIVING_ROOM, 2356, 300},
    {FURNITURE_TYPE_LIVING_ROOM, 2079, 150},
    {FURNITURE_TYPE_LIVING_ROOM, 1746, 200},
    {FURNITURE_TYPE_LIVING_ROOM, 1711, 100},
    {FURNITURE_TYPE_LIVING_ROOM, 2636, 200},
    {FURNITURE_TYPE_LIVING_ROOM, 11683, 400},
    {FURNITURE_TYPE_LIVING_ROOM, 11682, 400},
    {FURNITURE_TYPE_LIVING_ROOM, 11684, 400},
    {FURNITURE_TYPE_LIVING_ROOM, 11685, 400},
    {FURNITURE_TYPE_LIVING_ROOM, 2346, 300},
    {FURNITURE_TYPE_LIVING_ROOM, 2635, 200},
    {FURNITURE_TYPE_LIVING_ROOM, 1516, 300},
    {FURNITURE_TYPE_LIVING_ROOM, 1763, 300},
    {FURNITURE_TYPE_LIVING_ROOM, 1714, 600},
    {FURNITURE_TYPE_LIVING_ROOM, 1827, 500},
    {FURNITURE_TYPE_LIVING_ROOM, 2124, 350},
    {FURNITURE_TYPE_LIVING_ROOM, 19997, 400},
    {FURNITURE_TYPE_LIVING_ROOM, 1705, 450},
    {FURNITURE_TYPE_LIVING_ROOM, 2169, 600},
    {FURNITURE_TYPE_LIVING_ROOM, 2180, 400},
    {FURNITURE_TYPE_LIVING_ROOM, 2607, 550},
    {FURNITURE_TYPE_LIVING_ROOM, 1999, 500},
    {FURNITURE_TYPE_LIVING_ROOM, 1727, 600},
    {FURNITURE_TYPE_LIVING_ROOM, 2171, 350},
    {FURNITURE_TYPE_LIVING_ROOM, 2175, 350},
    {FURNITURE_TYPE_LIVING_ROOM, 2173, 600},
    {FURNITURE_TYPE_LIVING_ROOM, 1708, 500},
    {FURNITURE_TYPE_LIVING_ROOM, 2313, 400},
    {FURNITURE_TYPE_LIVING_ROOM, 2198, 500},
    {FURNITURE_TYPE_LIVING_ROOM, 2314, 450},
    {FURNITURE_TYPE_LIVING_ROOM, 2315, 600},
    {FURNITURE_TYPE_LIVING_ROOM, 2205, 650},
    {FURNITURE_TYPE_LIVING_ROOM, 2748, 500},
    {FURNITURE_TYPE_LIVING_ROOM, 2605, 400},
    {FURNITURE_TYPE_LIVING_ROOM, 2009, 800},
    {FURNITURE_TYPE_LIVING_ROOM, 11691, 900},
    {FURNITURE_TYPE_LIVING_ROOM, 1723, 1000},
    {FURNITURE_TYPE_LIVING_ROOM, 11665, 1200},
    {FURNITURE_TYPE_LIVING_ROOM, 11717, 600},
    {FURNITURE_TYPE_LIVING_ROOM, 11724, 1000},
    {FURNITURE_TYPE_LIVING_ROOM, 2617, 950},
    {FURNITURE_TYPE_LIVING_ROOM, 2572, 950},
    {FURNITURE_TYPE_LIVING_ROOM, 2357, 800},
    {FURNITURE_TYPE_LIVING_ROOM, 3921, 1000},

    {FURNITURE_TYPE_BEDROOM, 1803, 1500},
    {FURNITURE_TYPE_BEDROOM, 1802, 1100},
    {FURNITURE_TYPE_BEDROOM, 1801, 900},
    {FURNITURE_TYPE_BEDROOM, 1800, 800},
    {FURNITURE_TYPE_BEDROOM, 1799, 1500},
    {FURNITURE_TYPE_BEDROOM, 1798, 1300},
    {FURNITURE_TYPE_BEDROOM, 1795, 1150},
    {FURNITURE_TYPE_BEDROOM, 1796, 1000},
    {FURNITURE_TYPE_BEDROOM, 1793, 800},
    {FURNITURE_TYPE_BEDROOM, 1745, 1300},
    {FURNITURE_TYPE_BEDROOM, 1701, 1500},
    {FURNITURE_TYPE_BEDROOM, 1797, 1150},
    {FURNITURE_TYPE_BEDROOM, 1812, 600},
    {FURNITURE_TYPE_BEDROOM, 2299, 1300},
    {FURNITURE_TYPE_BEDROOM, 2298, 1500},
    {FURNITURE_TYPE_BEDROOM, 11446, 1800},
    {FURNITURE_TYPE_BEDROOM, 2301, 1000},
    {FURNITURE_TYPE_BEDROOM, 2300, 1200},
    {FURNITURE_TYPE_BEDROOM, 11720, 1600},
    {FURNITURE_TYPE_BEDROOM, 14866, 1400},
    {FURNITURE_TYPE_BEDROOM, 1794, 1100},
    {FURNITURE_TYPE_BEDROOM, 2265, 400},
    {FURNITURE_TYPE_BEDROOM, 2268, 400},
    {FURNITURE_TYPE_BEDROOM, 2277, 400},
    {FURNITURE_TYPE_BEDROOM, 2269, 400},
    {FURNITURE_TYPE_BEDROOM, 2280, 400},
    {FURNITURE_TYPE_BEDROOM, 2286, 400},
    {FURNITURE_TYPE_BEDROOM, 2267, 400},
    {FURNITURE_TYPE_BEDROOM, 2256, 400},
    {FURNITURE_TYPE_BEDROOM, 2257, 400},
    {FURNITURE_TYPE_BEDROOM, 3962, 400},
    {FURNITURE_TYPE_BEDROOM, 2105, 300},
    {FURNITURE_TYPE_BEDROOM, 2021, 700},
    {FURNITURE_TYPE_BEDROOM, 2328, 450},
    {FURNITURE_TYPE_BEDROOM, 2082, 700},
    {FURNITURE_TYPE_BEDROOM, 2306, 650},
    {FURNITURE_TYPE_BEDROOM, 2000, 450},
    {FURNITURE_TYPE_BEDROOM, 2073, 300},
    {FURNITURE_TYPE_BEDROOM, 1893, 300},
    {FURNITURE_TYPE_BEDROOM, 19611, 300},
    {FURNITURE_TYPE_BEDROOM, 2023, 300},
    {FURNITURE_TYPE_BEDROOM, 2239, 500},
    {FURNITURE_TYPE_BEDROOM, 1657, 400},
    {FURNITURE_TYPE_BEDROOM, 1742, 300},
    {FURNITURE_TYPE_BEDROOM, 2502, 550},
    {FURNITURE_TYPE_BEDROOM, 2482, 550},
    {FURNITURE_TYPE_BEDROOM, 2024, 500},
    {FURNITURE_TYPE_BEDROOM, 2109, 340},
    {FURNITURE_TYPE_BEDROOM, 2164, 800},
    {FURNITURE_TYPE_BEDROOM, 2463, 350},
    {FURNITURE_TYPE_BEDROOM, 2475, 350},
    {FURNITURE_TYPE_BEDROOM, 2199, 470},
    {FURNITURE_TYPE_BEDROOM, 2200, 500},
    {FURNITURE_TYPE_BEDROOM, 1763, 500},
    {FURNITURE_TYPE_BEDROOM, 2025, 780},
    {FURNITURE_TYPE_BEDROOM, 2204, 340},
    {FURNITURE_TYPE_BEDROOM, 2708, 350},
    {FURNITURE_TYPE_BEDROOM, 2573, 900},
    {FURNITURE_TYPE_BEDROOM, 2562, 800},
    {FURNITURE_TYPE_BEDROOM, 2568, 400},
    {FURNITURE_TYPE_BEDROOM, 14772, 700},
    {FURNITURE_TYPE_BEDROOM, 1747, 600},
    {FURNITURE_TYPE_BEDROOM, 2596, 800},
    {FURNITURE_TYPE_BEDROOM, 19786, 1500},
    {FURNITURE_TYPE_BEDROOM, 1786, 1100},
    {FURNITURE_TYPE_BEDROOM, 19787, 1350},
    {FURNITURE_TYPE_BEDROOM, 2091, 1100},

    {FURNITURE_TYPE_KITCHEN, 2133, 700},
    {FURNITURE_TYPE_KITCHEN, 2134, 700},
    {FURNITURE_TYPE_KITCHEN, 2139, 550},
    {FURNITURE_TYPE_KITCHEN, 2303, 500},
    {FURNITURE_TYPE_KITCHEN, 1893, 300},
    {FURNITURE_TYPE_KITCHEN, 19930, 650},
    {FURNITURE_TYPE_KITCHEN, 2335, 500},
    {FURNITURE_TYPE_KITCHEN, 2341, 580},
    {FURNITURE_TYPE_KITCHEN, 2152, 600},
    {FURNITURE_TYPE_KITCHEN, 2167, 380},
    {FURNITURE_TYPE_KITCHEN, 2142, 550},
    {FURNITURE_TYPE_KITCHEN, 2157, 500},
    {FURNITURE_TYPE_KITCHEN, 2159, 520},
    {FURNITURE_TYPE_KITCHEN, 2143, 560},
    {FURNITURE_TYPE_KITCHEN, 19923, 950},
    {FURNITURE_TYPE_KITCHEN, 19926, 700},
    {FURNITURE_TYPE_KITCHEN, 19927, 800},
    {FURNITURE_TYPE_KITCHEN, 19929, 890},
    {FURNITURE_TYPE_KITCHEN, 2118, 600},
    {FURNITURE_TYPE_KITCHEN, 2451, 800},
    {FURNITURE_TYPE_KITCHEN, 2419, 800},
    {FURNITURE_TYPE_KITCHEN, 2128, 350},
    {FURNITURE_TYPE_KITCHEN, 2014, 280},
    {FURNITURE_TYPE_KITCHEN, 2338, 500},
    {FURNITURE_TYPE_KITCHEN, 2152, 670},
    {FURNITURE_TYPE_KITCHEN, 19916, 1000},
    {FURNITURE_TYPE_KITCHEN, 2304, 670},
    {FURNITURE_TYPE_KITCHEN, 2539, 800},
    {FURNITURE_TYPE_KITCHEN, 2153, 450},
    {FURNITURE_TYPE_KITCHEN, 2015, 500},
    {FURNITURE_TYPE_KITCHEN, 2016, 500},
    {FURNITURE_TYPE_KITCHEN, 2018, 500},
    {FURNITURE_TYPE_KITCHEN, 2019, 500},
    {FURNITURE_TYPE_KITCHEN, 2533, 670},
    {FURNITURE_TYPE_KITCHEN, 19924, 800},
    {FURNITURE_TYPE_KITCHEN, 2129, 620},
    {FURNITURE_TYPE_KITCHEN, 2137, 500},
    {FURNITURE_TYPE_KITCHEN, 2416, 950},
    {FURNITURE_TYPE_KITCHEN, 2305, 620},
    {FURNITURE_TYPE_KITCHEN, 2151, 670},
    {FURNITURE_TYPE_KITCHEN, 1667, 350},
    {FURNITURE_TYPE_KITCHEN, 1546, 350},
    {FURNITURE_TYPE_KITCHEN, 1455, 350},
    {FURNITURE_TYPE_KITCHEN, 1486, 350},
    {FURNITURE_TYPE_KITCHEN, 19818, 350},
    {FURNITURE_TYPE_KITCHEN, 19819, 350},
    {FURNITURE_TYPE_KITCHEN, 1668, 350},
    {FURNITURE_TYPE_KITCHEN, 11686, 2000},
    {FURNITURE_TYPE_KITCHEN, 19821, 350},
    {FURNITURE_TYPE_KITCHEN, 1551, 350},
    {FURNITURE_TYPE_KITCHEN, 11744, 400},
    {FURNITURE_TYPE_KITCHEN, 19583, 400},
    {FURNITURE_TYPE_KITCHEN, 11719, 400},
    {FURNITURE_TYPE_KITCHEN, 2830, 500},
    {FURNITURE_TYPE_KITCHEN, 19809, 400},
    {FURNITURE_TYPE_KITCHEN, 19585, 400},
    {FURNITURE_TYPE_KITCHEN, 19584, 350},
    {FURNITURE_TYPE_KITCHEN, 2851, 400},
    {FURNITURE_TYPE_KITCHEN, 2822, 400},
    {FURNITURE_TYPE_KITCHEN, 11743, 600},
    {FURNITURE_TYPE_KITCHEN, 2848, 550},
    {FURNITURE_TYPE_KITCHEN, 19830, 600},
    {FURNITURE_TYPE_KITCHEN, 19581, 500},
    {FURNITURE_TYPE_KITCHEN, 2421, 350},
    {FURNITURE_TYPE_KITCHEN, 2426, 500},
    {FURNITURE_TYPE_KITCHEN, 19915, 900},

    {FURNITURE_TYPE_WALLS, 19368, 1000},
    {FURNITURE_TYPE_WALLS, 19447, 1000},
    {FURNITURE_TYPE_WALLS, 19366, 1000},
    {FURNITURE_TYPE_WALLS, 19370, 1000},
    {FURNITURE_TYPE_WALLS, 19362, 1000},
    {FURNITURE_TYPE_WALLS, 19387, 1000},
    {FURNITURE_TYPE_WALLS, 19411, 1000},
    {FURNITURE_TYPE_WALLS, 19369, 1000},
    {FURNITURE_TYPE_WALLS, 19437, 1000},
    {FURNITURE_TYPE_WALLS, 19392, 1000},
    {FURNITURE_TYPE_WALLS, 19456, 1000},
    {FURNITURE_TYPE_WALLS, 19399, 1000},
    {FURNITURE_TYPE_WALLS, 19400, 1000},
    {FURNITURE_TYPE_WALLS, 19401, 1000},
    {FURNITURE_TYPE_WALLS, 19402, 1000},
    {FURNITURE_TYPE_WALLS, 19465, 1000},

    {FURNITURE_TYPE_DOORS, 2875, 850},
    {FURNITURE_TYPE_DOORS, 2664, 850},
    {FURNITURE_TYPE_DOORS, 2876, 850},
    {FURNITURE_TYPE_DOORS, 1492, 850},
    {FURNITURE_TYPE_DOORS, 19304, 850},
    {FURNITURE_TYPE_DOORS, 14819, 850},
    {FURNITURE_TYPE_DOORS, 3061, 850},
    {FURNITURE_TYPE_DOORS, 1532, 850},
    {FURNITURE_TYPE_DOORS, 1504, 850},
    {FURNITURE_TYPE_DOORS, 1506, 850},
    {FURNITURE_TYPE_DOORS, 1507, 850},
    {FURNITURE_TYPE_DOORS, 1505, 850},
    {FURNITURE_TYPE_DOORS, 1493, 850},
    {FURNITURE_TYPE_DOORS, 1495, 850},
    {FURNITURE_TYPE_DOORS, 2948, 850},
    {FURNITURE_TYPE_DOORS, 1569, 850},
    {FURNITURE_TYPE_DOORS, 19805, 850},
    {FURNITURE_TYPE_DOORS, 1557, 850},
    {FURNITURE_TYPE_DOORS, 1537, 850},
    {FURNITURE_TYPE_DOORS, 1536, 850},
    {FURNITURE_TYPE_DOORS, 1556, 850},
    {FURNITURE_TYPE_DOORS, 1498, 850},
    {FURNITURE_TYPE_DOORS, 1497, 850},
    {FURNITURE_TYPE_DOORS, 1494, 850},

    {FURNITURE_TYPE_GARAJE, 1025, 900},
    {FURNITURE_TYPE_GARAJE, 1073, 900},
    {FURNITURE_TYPE_GARAJE, 1074, 900},
    {FURNITURE_TYPE_GARAJE, 1075, 900},
    {FURNITURE_TYPE_GARAJE, 1076, 900},
    {FURNITURE_TYPE_GARAJE, 1077, 900},
    {FURNITURE_TYPE_GARAJE, 1078, 900},
    {FURNITURE_TYPE_GARAJE, 1079, 900},
    {FURNITURE_TYPE_GARAJE, 1080, 900},
    {FURNITURE_TYPE_GARAJE, 1081, 900},
    {FURNITURE_TYPE_GARAJE, 1082, 900},
    {FURNITURE_TYPE_GARAJE, 1083, 900},
    {FURNITURE_TYPE_GARAJE, 1084, 900},
    {FURNITURE_TYPE_GARAJE, 1085, 900},
    {FURNITURE_TYPE_GARAJE, 1086, 900},
    {FURNITURE_TYPE_GARAJE, 1097, 900},
    {FURNITURE_TYPE_GARAJE, 1098, 900},
    {FURNITURE_TYPE_GARAJE, 1010, 900},
    {FURNITURE_TYPE_GARAJE, 18647, 1000},
    {FURNITURE_TYPE_GARAJE, 18648, 1000},
    {FURNITURE_TYPE_GARAJE, 19917, 1100},
    {FURNITURE_TYPE_GARAJE, 19620, 1000},
    {FURNITURE_TYPE_GARAJE, 19817, 1300},
    {FURNITURE_TYPE_GARAJE, 19899, 1100},
    {FURNITURE_TYPE_GARAJE, 19900, 700},
    {FURNITURE_TYPE_GARAJE, 19815, 1000},
    {FURNITURE_TYPE_GARAJE, 2465, 400},
    {FURNITURE_TYPE_GARAJE, 2466, 400},

    {FURNITURE_TYPE_OTHERS, 371, 230},
    {FURNITURE_TYPE_OTHERS, 349, 500},
    {FURNITURE_TYPE_OTHERS, 357, 500},
    {FURNITURE_TYPE_OTHERS, 358, 500},
    {FURNITURE_TYPE_OTHERS, 356, 500},
    {FURNITURE_TYPE_OTHERS, 372, 500},
    {FURNITURE_TYPE_OTHERS, 355, 500},
    {FURNITURE_TYPE_OTHERS, 353, 500},
    {FURNITURE_TYPE_OTHERS, 351, 500},
    {FURNITURE_TYPE_OTHERS, 350, 500},
    {FURNITURE_TYPE_OTHERS, 346, 500},
    {FURNITURE_TYPE_OTHERS, 1550, 850},
    {FURNITURE_TYPE_OTHERS, 1212, 500},
    {FURNITURE_TYPE_OTHERS, 1580, 700},
    {FURNITURE_TYPE_OTHERS, 1575, 700},
    {FURNITURE_TYPE_OTHERS, 1577, 700},
    {FURNITURE_TYPE_OTHERS, 1578, 700},
    {FURNITURE_TYPE_OTHERS, 1579, 700},
    {FURNITURE_TYPE_OTHERS, 19609, 1000},
    {FURNITURE_TYPE_OTHERS, 3633, 500},
    {FURNITURE_TYPE_OTHERS, 3632, 150},
    {FURNITURE_TYPE_OTHERS, 2114, 500},
    {FURNITURE_TYPE_OTHERS, 1731, 400},
    {FURNITURE_TYPE_OTHERS, 3017, 500},
    {FURNITURE_TYPE_OTHERS, 11725, 1300},
    {FURNITURE_TYPE_OTHERS, 2076, 600},
    {FURNITURE_TYPE_OTHERS, 2073, 800},
    {FURNITURE_TYPE_OTHERS, 2901, 650},
    {FURNITURE_TYPE_OTHERS, 2509, 800},
    {FURNITURE_TYPE_OTHERS, 2737, 1000},
    {FURNITURE_TYPE_OTHERS, 1646, 700},
    {FURNITURE_TYPE_OTHERS, 1647, 700},
    {FURNITURE_TYPE_OTHERS, 1421, 500},
    {FURNITURE_TYPE_OTHERS, 3031, 600},
    {FURNITURE_TYPE_OTHERS, 1892, 500},
    {FURNITURE_TYPE_OTHERS, 2919, 1000},
    {FURNITURE_TYPE_OTHERS, 946, 1500},
    {FURNITURE_TYPE_OTHERS, 3496, 1000},
    {FURNITURE_TYPE_OTHERS, 2916, 400},
    {FURNITURE_TYPE_OTHERS, 2680, 200},
    {FURNITURE_TYPE_OTHERS, 2056, 350},
    {FURNITURE_TYPE_OTHERS, 1513, 450},
    {FURNITURE_TYPE_OTHERS, 2469, 600},
    {FURNITURE_TYPE_OTHERS, 2915, 500},
    {FURNITURE_TYPE_OTHERS, 2913, 750},
    {FURNITURE_TYPE_OTHERS, 2806, 200},
    {FURNITURE_TYPE_OTHERS, 2993, 400},
    {FURNITURE_TYPE_OTHERS, 2805, 300},
    {FURNITURE_TYPE_OTHERS, 2803, 250},
    {FURNITURE_TYPE_OTHERS, 2621, 500},
    {FURNITURE_TYPE_OTHERS, 2620, 500},
    {FURNITURE_TYPE_OTHERS, 2593, 450},
    {FURNITURE_TYPE_OTHERS, 2611, 600},
    {FURNITURE_TYPE_OTHERS, 2612, 600},
    {FURNITURE_TYPE_OTHERS, 19526, 1000},
    {FURNITURE_TYPE_OTHERS, 3042, 400},
    {FURNITURE_TYPE_OTHERS, 2387, 500},
    {FURNITURE_TYPE_OTHERS, 2550, 500},
    {FURNITURE_TYPE_OTHERS, 1583, 700},
    {FURNITURE_TYPE_OTHERS, 2484, 400},
    {FURNITURE_TYPE_OTHERS, 2582, 350},
    {FURNITURE_TYPE_OTHERS, 2616, 700},
    {FURNITURE_TYPE_OTHERS, 18885, 1500},
    {FURNITURE_TYPE_OTHERS, 19899, 1300},
    {FURNITURE_TYPE_OTHERS, 2375, 1000},
    {FURNITURE_TYPE_OTHERS, 3077, 1200},
    {FURNITURE_TYPE_OTHERS, 11245, 500},
    {FURNITURE_TYPE_OTHERS, 2964, 2000},
    {FURNITURE_TYPE_OTHERS, 338, 300},
    {FURNITURE_TYPE_OTHERS, 3000, 200},
    {FURNITURE_TYPE_OTHERS, 2999, 200},
    {FURNITURE_TYPE_OTHERS, 2997, 200},
    {FURNITURE_TYPE_OTHERS, 2996, 200},
    {FURNITURE_TYPE_OTHERS, 2995, 200},
    {FURNITURE_TYPE_OTHERS, 2965, 200},
    {FURNITURE_TYPE_OTHERS, 3102, 200},
    {FURNITURE_TYPE_OTHERS, 19920, 400},
    {FURNITURE_TYPE_OTHERS, 11746, 150},
    {FURNITURE_TYPE_OTHERS, 19895, 300},
    {FURNITURE_TYPE_OTHERS, 19807, 500},
    {FURNITURE_TYPE_OTHERS, 19621, 250},
    {FURNITURE_TYPE_OTHERS, 11728, 700},
    {FURNITURE_TYPE_OTHERS, 1840, 300},
    {FURNITURE_TYPE_OTHERS, 19624, 500},
    {FURNITURE_TYPE_OTHERS, 18634, 200},
    {FURNITURE_TYPE_OTHERS, 14705, 450},
    {FURNITURE_TYPE_OTHERS, 19825, 300},
    {FURNITURE_TYPE_OTHERS, 19921, 250},
    {FURNITURE_TYPE_OTHERS, 2226, 850},
    {FURNITURE_TYPE_OTHERS, 19631, 200},
    {FURNITURE_TYPE_OTHERS, 1809, 400},
    {FURNITURE_TYPE_OTHERS, 1839, 600},
    {FURNITURE_TYPE_OTHERS, 19878, 600},
    {FURNITURE_TYPE_OTHERS, 19617, 250},
    {FURNITURE_TYPE_OTHERS, 11706, 500},
    {FURNITURE_TYPE_OTHERS, 1736, 1000},
    {FURNITURE_TYPE_OTHERS, 2103, 1000},
    {FURNITURE_TYPE_OTHERS, 11737, 250},
    {FURNITURE_TYPE_OTHERS, 19831, 500},
    {FURNITURE_TYPE_OTHERS, 1808, 700},
    {FURNITURE_TYPE_OTHERS, 2835, 200},
    {FURNITURE_TYPE_OTHERS, 2630, 1000},
    {FURNITURE_TYPE_OTHERS, 2628, 1500},
    {FURNITURE_TYPE_OTHERS, 2627, 1000},
    {FURNITURE_TYPE_OTHERS, 2629, 1100},
    {FURNITURE_TYPE_OTHERS, 2202, 950},
    {FURNITURE_TYPE_OTHERS, 2100, 1300},
    {FURNITURE_TYPE_OTHERS, 2146, 1000},
    {FURNITURE_TYPE_OTHERS, 1828, 1000},
    {FURNITURE_TYPE_OTHERS, 2631, 200},
    {FURNITURE_TYPE_OTHERS, 2632, 200},
    {FURNITURE_TYPE_OTHERS, 14806, 750},
    {FURNITURE_TYPE_OTHERS, 2704, 600},
    {FURNITURE_TYPE_OTHERS, 2706, 600},
    {FURNITURE_TYPE_OTHERS, 2689, 600},
    {FURNITURE_TYPE_OTHERS, 2839, 1000},
    {FURNITURE_TYPE_OTHERS, 2396, 1000},
    {FURNITURE_TYPE_OTHERS, 2399, 1000},
    {FURNITURE_TYPE_OTHERS, 2374, 1000},
    {FURNITURE_TYPE_OTHERS, 2844, 500},
    {FURNITURE_TYPE_OTHERS, 2381, 1000},
    {FURNITURE_TYPE_OTHERS, 2394, 900},
    {FURNITURE_TYPE_OTHERS, 1834, 1200},
    {FURNITURE_TYPE_OTHERS, 1948, 1150},
    {FURNITURE_TYPE_OTHERS, 1895, 400},
    {FURNITURE_TYPE_OTHERS, 2778, 900},
    {FURNITURE_TYPE_OTHERS, 2779, 850},
    {FURNITURE_TYPE_OTHERS, 2681, 1000},
    {FURNITURE_TYPE_OTHERS, 3441, 1000},
    {FURNITURE_TYPE_OTHERS, 2188, 950},
    {FURNITURE_TYPE_OTHERS, 1978, 2000},
    {FURNITURE_TYPE_OTHERS, 1080, 500},
    {FURNITURE_TYPE_OTHERS, 1075, 500},
    {FURNITURE_TYPE_OTHERS, 1073, 500},
    {FURNITURE_TYPE_OTHERS, 1047, 500},
    {FURNITURE_TYPE_OTHERS, 1327, 400},
    {FURNITURE_TYPE_OTHERS, 1883, 800},
    {FURNITURE_TYPE_OTHERS, 1235, 300},
    {FURNITURE_TYPE_OTHERS, 2769, 200},
    {FURNITURE_TYPE_OTHERS, 19273, 1500},
    {FURNITURE_TYPE_OTHERS, 2905, 1000},
    {FURNITURE_TYPE_OTHERS, 2906, 1000},
    {FURNITURE_TYPE_OTHERS, 2907, 1500},
    {FURNITURE_TYPE_OTHERS, 1264, 300},
    {FURNITURE_TYPE_OTHERS, 1328, 400},
    {FURNITURE_TYPE_OTHERS, 1220, 300},
    {FURNITURE_TYPE_OTHERS, 1230, 250},
    {FURNITURE_TYPE_OTHERS, 932, 500},
    {FURNITURE_TYPE_OTHERS, 1347, 250},
    {FURNITURE_TYPE_OTHERS, 1337, 500},
    {FURNITURE_TYPE_OTHERS, 1448, 200},
    {FURNITURE_TYPE_OTHERS, 1409, 350},
    {FURNITURE_TYPE_OTHERS, 1300, 600},
    {FURNITURE_TYPE_OTHERS, 1371, 500},
    {FURNITURE_TYPE_OTHERS, 1349, 300},
    {FURNITURE_TYPE_OTHERS, 1345, 200},
    {FURNITURE_TYPE_OTHERS, 1236, 200},
    {FURNITURE_TYPE_OTHERS, 1333, 200},
    {FURNITURE_TYPE_OTHERS, 1358, 1500},
    {FURNITURE_TYPE_OTHERS, 952, 1000},
    {FURNITURE_TYPE_OTHERS, 1238, 250},
    {FURNITURE_TYPE_OTHERS, 1215, 200},
    {FURNITURE_TYPE_OTHERS, 1478, 500},
    {FURNITURE_TYPE_OTHERS, 1531, 750},
    {FURNITURE_TYPE_OTHERS, 1525, 750},
    {FURNITURE_TYPE_OTHERS, 1524, 750},
    {FURNITURE_TYPE_OTHERS, 1490, 750},
    {FURNITURE_TYPE_OTHERS, 1528, 750},
    {FURNITURE_TYPE_OTHERS, 642, 500},
    {FURNITURE_TYPE_OTHERS, 1342, 1000},
    {FURNITURE_TYPE_OTHERS, 16442, 3000},
    {FURNITURE_TYPE_OTHERS, 17969, 1000},
    {FURNITURE_TYPE_OTHERS, 11733, 1000},

    {FURNITURE_TYPE_DECORATION, 19818, 500},
    {FURNITURE_TYPE_DECORATION, 1667, 600},
    {FURNITURE_TYPE_DECORATION, 1543, 200},
    {FURNITURE_TYPE_DECORATION, 1546, 100},
    {FURNITURE_TYPE_DECORATION, 1512, 300},
    {FURNITURE_TYPE_DECORATION, 1520, 450},
    {FURNITURE_TYPE_DECORATION, 1886, 1500},
    {FURNITURE_TYPE_DECORATION, 2055, 500},
    {FURNITURE_TYPE_DECORATION, 11737, 400},
    {FURNITURE_TYPE_DECORATION, 2842, 300},
    {FURNITURE_TYPE_DECORATION, 2918, 300},
    {FURNITURE_TYPE_DECORATION, 2833, 300},
    {FURNITURE_TYPE_DECORATION, 19806, 500},
    {FURNITURE_TYPE_DECORATION, 11726, 500},
    {FURNITURE_TYPE_DECORATION, 1661, 500},
    {FURNITURE_TYPE_DECORATION, 14527, 500},
    {FURNITURE_TYPE_DECORATION, 2074, 250},
    {FURNITURE_TYPE_DECORATION, 2107, 300},
    {FURNITURE_TYPE_DECORATION, 2105, 300},
    {FURNITURE_TYPE_DECORATION, 1734, 500},
    {FURNITURE_TYPE_DECORATION, 2278, 500},
    {FURNITURE_TYPE_DECORATION, 2261, 500},
    {FURNITURE_TYPE_DECORATION, 2270, 500},
    {FURNITURE_TYPE_DECORATION, 2250, 1000},
    {FURNITURE_TYPE_DECORATION, 2076, 500},
    {FURNITURE_TYPE_DECORATION, 2073, 500},
    {FURNITURE_TYPE_DECORATION, 1893, 500},
    {FURNITURE_TYPE_DECORATION, 2023, 350},
    {FURNITURE_TYPE_DECORATION, 1657, 500},
    {FURNITURE_TYPE_DECORATION, 19924, 800},
    {FURNITURE_TYPE_DECORATION, 2176, 600},
    {FURNITURE_TYPE_DECORATION, 2241, 300},
    {FURNITURE_TYPE_DECORATION, 2001, 300},
    {FURNITURE_TYPE_DECORATION, 2245, 300},
    {FURNITURE_TYPE_DECORATION, 2244, 300},
    {FURNITURE_TYPE_DECORATION, 2195, 300},
    {FURNITURE_TYPE_DECORATION, 950, 300},
    {FURNITURE_TYPE_DECORATION, 946, 300},
    {FURNITURE_TYPE_DECORATION, 948, 300},
    {FURNITURE_TYPE_DECORATION, 1361, 300},
    {FURNITURE_TYPE_DECORATION, 19473, 600}
};

new Float:FurnitureShopBuyPos[3] = {1975.910766, -1779.846435, 1249.219482};

new
    PlayerText:pFurnitureShopTd[MAX_PLAYERS][10] = {{PlayerText:INVALID_TEXT_DRAW, ...}, ...},
    bool:pFurnitureShopOpened[MAX_PLAYERS],
    pFurnitureShopCurrentType[MAX_PLAYERS],
    pFurnitureShopCurrentModel[MAX_PLAYERS],
    pFurnitureShopPickup[MAX_PLAYERS] = {INVALID_STREAMER_ID, ...}
;

hook OnScriptInit() 
{
    CreateDynamic3DTextLabel("Usa {"#PRIMARY_COLOR"}/muebles {FFFFFF}para comprar muebles.", 0xFFFFFFFF, FurnitureShopBuyPos[0], FurnitureShopBuyPos[1], FurnitureShopBuyPos[2], 10.0, .testlos = true, .worldid = 0);
}

hook OnPlayerDisconnect(playerid, reason) 
{
    DestroyPlayerFurnitureShop(playerid);
}

hook OnPlayerStateChange(playerid, newstate, oldstate)
{
	if(newstate == PLAYER_STATE_SPECTATING || newstate == PLAYER_STATE_WASTED) 
    {
        if(pFurnitureShopOpened[playerid]) 
        {
		    CancelSelectTextDrawEx(playerid);
        }
	}
	return 1;
}

hook OnPlayerClickTextDraw(playerid, Text:clickedid) 
{
    if(clickedid == Text:INVALID_TEXT_DRAW && pFurnitureShopOpened[playerid]) 
    {
        DestroyPlayerFurnitureShop(playerid);
    }
}

hook OnPlayerClickPlayerTD(playerid, PlayerText:playertextid) 
{
    if(pFurnitureShopOpened[playerid]) 
    {
        if(playertextid == pFurnitureShopTd[playerid][3]) 
        { //<< CAT
            pFurnitureShopCurrentType[playerid] --;
            if(pFurnitureShopCurrentType[playerid] < 0) pFurnitureShopCurrentType[playerid] = sizeof(FurnitureTypesInfo) - 1;
            pFurnitureShopCurrentModel[playerid] = 0;
            UpdatePlayerFurnitureShop(playerid);
            return Y_HOOKS_BREAK_RETURN_1;
        }
        else if(playertextid == pFurnitureShopTd[playerid][4]) 
        { //>> CAT
            pFurnitureShopCurrentType[playerid] ++;
            if(pFurnitureShopCurrentType[playerid] > sizeof(FurnitureTypesInfo) - 1) pFurnitureShopCurrentType[playerid] = 0;
            pFurnitureShopCurrentModel[playerid] = 0;
            UpdatePlayerFurnitureShop(playerid);
            return Y_HOOKS_BREAK_RETURN_1;
        }
        else if(playertextid == pFurnitureShopTd[playerid][6]) 
        { //<< MUEBLE
            pFurnitureShopCurrentModel[playerid] --;
            if(pFurnitureShopCurrentModel[playerid] < 0) pFurnitureShopCurrentModel[playerid] = CountFurnitureObjectsInfoType(pFurnitureShopCurrentType[playerid]) - 1;
            UpdatePlayerFurnitureShop(playerid, false);
            return Y_HOOKS_BREAK_RETURN_1;
        }
        else if(playertextid == pFurnitureShopTd[playerid][7]) 
        { //>> MUEBLE
            pFurnitureShopCurrentModel[playerid] ++;
            if(pFurnitureShopCurrentModel[playerid] > CountFurnitureObjectsInfoType(pFurnitureShopCurrentType[playerid]) - 1) pFurnitureShopCurrentModel[playerid] = 0;
            UpdatePlayerFurnitureShop(playerid, false);
            return Y_HOOKS_BREAK_RETURN_1;
        }
        else if(playertextid == pFurnitureShopTd[playerid][9]) 
        { //COMPRAR
            new dialog_body[(MAX_SU_PROPERTIES * 128) + 1], count = 0;
            dialog_body = "Propiedad\tMuebles\n";
            for(new i = 0; i < sizeof PROPERTY_INFO; i ++) 
            {
                if(PROPERTY_INFO[i][property_SOLD] && PROPERTY_INFO[i][property_OWNER_ID] == PI[playerid][pi_ID]) 
                {
                    new string[64];
                    format(string, sizeof string, "%d. %s [ID: %d]\t%d/%d muebles\n", count + 1, PROPERTY_INFO[i][property_NAME], PROPERTY_INFO[i][property_ID], CountPropertyObjects(PROPERTY_INFO[i][property_ID]), PI[playerid][pi_VIP] ? MAX_SU_PROPERTY_OBJECTS : MAX_NU_PROPERTY_OBJECTS);
                    strcat(dialog_body, string);

                    PLAYER_TEMP[playerid][pt_PLAYER_GPS_SELECTED_PROPERTY][count] = i;
                    count ++;
                }
            }

            if(count == 0) return SendNotification(playerid, "No tienes ninguna propiedad.");

            for(new i = 0; i < sizeof pFurnitureShopTd[]; i ++) {
                PlayerTextDrawHide(playerid, pFurnitureShopTd[playerid][i]);
            }

            PLAYER_TEMP[playerid][pt_DIALOG_RESPONDED] = false;
            PLAYER_TEMP[playerid][pt_DIALOG_ID] = DIALOG_FSHOP_SELECT_PROPERTY;
            ShowPlayerDialog(playerid, DIALOG_FSHOP_SELECT_PROPERTY, DIALOG_STYLE_TABLIST_HEADERS, "Selecciona la propiedad", dialog_body, "Comprar", "Cerrar");
            SendNotification(playerid, "Selecciona la propiedad donde quieres que entregemos el mueble.");
            return Y_HOOKS_BREAK_RETURN_1;
        }
    }
    return Y_HOOKS_CONTINUE_RETURN_1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {
    if(dialogid == DIALOG_FSHOP_SELECT_PROPERTY) {
        if(response) {
            new property_index = PLAYER_TEMP[playerid][pt_PLAYER_GPS_SELECTED_PROPERTY][listitem];
            new limit = PI[playerid][pi_VIP] ? MAX_SU_PROPERTY_OBJECTS : MAX_NU_PROPERTY_OBJECTS;
            if(CountPropertyObjects(PROPERTY_INFO[property_index][property_ID]) >= limit) SendNotification(playerid, "No puedes añadir más muebles a esta propiedad.");
            else {
                new objectIndex = GetCurrentFurnitureObjectIndex(playerid);
                if(GivePlayerCash(playerid, -FurnitureObjectsInfo[objectIndex][foi_PRICE], true, true)) {
                    RegisterPropertyObject(property_index, PROPERTY_INFO[property_index][property_ID], FurnitureObjectsInfo[objectIndex][foi_MODELID]);
                    SendNotification(playerid, "~g~¡El mueble será entregado en tu propiedad! ~w~Puedes seguir comprando o presionar ~y~'ESC' ~w~para salir.");
                }
                else SendNotification(playerid, "No tienes suficiente dinero para comprar este mueble.");
            }
        }
        for(new i = 0; i < sizeof pFurnitureShopTd[]; i ++) {
            PlayerTextDrawShow(playerid, pFurnitureShopTd[playerid][i]);
        }
        return Y_HOOKS_BREAK_RETURN_1;
    }
    return Y_HOOKS_CONTINUE_RETURN_1;
}

DestroyPlayerFurnitureShop(playerid) {
    for(new i = 0; i < sizeof pFurnitureShopTd[]; i ++) {
        if(pFurnitureShopTd[playerid][i] != PlayerText:INVALID_TEXT_DRAW) {
            PlayerTextDrawDestroy(playerid, pFurnitureShopTd[playerid][i]);
            pFurnitureShopTd[playerid][i] = PlayerText:INVALID_TEXT_DRAW;
        }
    }

    if(pFurnitureShopPickup[playerid] != INVALID_STREAMER_ID) {
        DestroyDynamicPickup(pFurnitureShopPickup[playerid]);
        pFurnitureShopPickup[playerid] = INVALID_STREAMER_ID;
    }

    pFurnitureShopOpened[playerid] = false;
    pFurnitureShopCurrentType[playerid] = 0;
    pFurnitureShopCurrentModel[playerid] = 0;
    SetPlayerVirtualWorld(playerid, 0);
    SetCameraBehindPlayer(playerid);
}

UpdatePlayerFurnitureShop(playerid, bool:camera = true) 
{
    if(camera)
    InterpolatePCameraToFurType(playerid);

    new string[128];
    format(string, sizeof string, "Categoría_(%d/%d)", pFurnitureShopCurrentType[playerid] + 1, sizeof(FurnitureTypesInfo));
    FixTextDrawString(string);
    PlayerTextDrawSetString(playerid, pFurnitureShopTd[playerid][1], string);
    
    format(string, sizeof string, "%s", FurnitureTypesInfo[pFurnitureShopCurrentType[playerid]][fti_NAME]);
    FixTextDrawString(string);
    PlayerTextDrawSetString(playerid, pFurnitureShopTd[playerid][2], string);

    if(pFurnitureShopPickup[playerid] != INVALID_STREAMER_ID) 
    {
        DestroyDynamicPickup(pFurnitureShopPickup[playerid]);
        pFurnitureShopPickup[playerid] = INVALID_STREAMER_ID;
    }
    
    new objectIndex = GetCurrentFurnitureObjectIndex(playerid);
    if(objectIndex != -1) 
    {
        format(string, sizeof string, "Mueble_(%d/%d)", pFurnitureShopCurrentModel[playerid] + 1, CountFurnitureObjectsInfoType(pFurnitureShopCurrentType[playerid]));
        FixTextDrawString(string);
        PlayerTextDrawSetString(playerid, pFurnitureShopTd[playerid][5], string);
    
        format(string, sizeof string, "%s$", number_format_thousand(FurnitureObjectsInfo[objectIndex][foi_PRICE]));
        FixTextDrawString(string);
        PlayerTextDrawSetString(playerid, pFurnitureShopTd[playerid][8], string);
        
        PlayerTextDrawShow(playerid, pFurnitureShopTd[playerid][6]);
        PlayerTextDrawShow(playerid, pFurnitureShopTd[playerid][7]);

        PlayerTextDrawColor(playerid, pFurnitureShopTd[playerid][9], -1);
        PlayerTextDrawBoxColor(playerid, pFurnitureShopTd[playerid][9], -2139062017);
        PlayerTextDrawSetSelectable(playerid, pFurnitureShopTd[playerid][9], true);
        PlayerTextDrawShow(playerid, pFurnitureShopTd[playerid][9]);

        new Float:fPX, Float:fPY, Float:fPZ, Float:fVX, Float:fVY, Float:fVZ, Float:pos[3];
        fPX = FurnitureTypesInfo[ pFurnitureShopCurrentType[playerid] ][fti_CAM_X];
        fPY = FurnitureTypesInfo[ pFurnitureShopCurrentType[playerid] ][fti_CAM_Y];
        fPZ = FurnitureTypesInfo[ pFurnitureShopCurrentType[playerid] ][fti_CAM_Z];
        fVX = FurnitureTypesInfo[ pFurnitureShopCurrentType[playerid] ][fti_CAM_LOOK_AT_X] - fPX;
        fVY = FurnitureTypesInfo[ pFurnitureShopCurrentType[playerid] ][fti_CAM_LOOK_AT_Y] - fPY;
        fVZ = FurnitureTypesInfo[ pFurnitureShopCurrentType[playerid] ][fti_CAM_LOOK_AT_Z] - fPZ;
 
        pos[0] = fPX + floatmul(fVX, FURNITURE_CAMERA_OBJECT_SCALE);
        pos[1] = fPY + floatmul(fVY, FURNITURE_CAMERA_OBJECT_SCALE);
        pos[2] = fPZ + floatmul(fVZ, FURNITURE_CAMERA_OBJECT_SCALE);

        pFurnitureShopPickup[playerid] = CreateDynamicPickup(
            FurnitureObjectsInfo[objectIndex][foi_MODELID],
            1,
            pos[0],
            pos[1],
            pos[2],
            GetPlayerVirtualWorld(playerid),
            -1,
            playerid
        );
    }
    else 
    {
        format(string, sizeof string, "Mueble");
        FixTextDrawString(string);
        PlayerTextDrawSetString(playerid, pFurnitureShopTd[playerid][5], string);
    
        format(string, sizeof string, "categoría_vacía");
        FixTextDrawString(string);
        PlayerTextDrawSetString(playerid, pFurnitureShopTd[playerid][8], string);

        PlayerTextDrawHide(playerid, pFurnitureShopTd[playerid][6]);
        PlayerTextDrawHide(playerid, pFurnitureShopTd[playerid][7]);

        PlayerTextDrawColor(playerid, pFurnitureShopTd[playerid][9], -186);
        PlayerTextDrawBoxColor(playerid, pFurnitureShopTd[playerid][9], -2139062202);
        PlayerTextDrawSetSelectable(playerid, pFurnitureShopTd[playerid][9], false);
        PlayerTextDrawShow(playerid, pFurnitureShopTd[playerid][9]);
    }
    
    Streamer_Update(playerid, STREAMER_TYPE_PICKUP);
}

CreatePFurnitureShopTextDraws(playerid) 
{
    pFurnitureShopTd[playerid][0] = CreatePlayerTextDraw(playerid, 247.000000, 313.000000, "LD_SPAC:white");
    PlayerTextDrawTextSize(playerid, pFurnitureShopTd[playerid][0], 146.000000, 100.000000);
    PlayerTextDrawAlignment(playerid, pFurnitureShopTd[playerid][0], 1);
    PlayerTextDrawColor(playerid, pFurnitureShopTd[playerid][0], 170);
    PlayerTextDrawSetShadow(playerid, pFurnitureShopTd[playerid][0], 0);
    PlayerTextDrawBackgroundColor(playerid, pFurnitureShopTd[playerid][0], 255);
    PlayerTextDrawFont(playerid, pFurnitureShopTd[playerid][0], 4);
    PlayerTextDrawSetProportional(playerid, pFurnitureShopTd[playerid][0], 0);

    pFurnitureShopTd[playerid][1] = CreatePlayerTextDraw(playerid, 320.000000, 320.000000, "Cat_(0/0)");
    PlayerTextDrawLetterSize(playerid, pFurnitureShopTd[playerid][1], 0.301250, 1.416444);
    PlayerTextDrawTextSize(playerid, pFurnitureShopTd[playerid][1], 0.000000, 10.000000);
    PlayerTextDrawAlignment(playerid, pFurnitureShopTd[playerid][1], 2);
    PlayerTextDrawColor(playerid, pFurnitureShopTd[playerid][1], -1);
    PlayerTextDrawSetShadow(playerid, pFurnitureShopTd[playerid][1], 0);
    PlayerTextDrawSetOutline(playerid, pFurnitureShopTd[playerid][1], 1);
    PlayerTextDrawBackgroundColor(playerid, pFurnitureShopTd[playerid][1], 255);
    PlayerTextDrawFont(playerid, pFurnitureShopTd[playerid][1], 1);
    PlayerTextDrawSetProportional(playerid, pFurnitureShopTd[playerid][1], 1);

    pFurnitureShopTd[playerid][2] = CreatePlayerTextDraw(playerid, 320.000000, 335.000000, "---");
    PlayerTextDrawLetterSize(playerid, pFurnitureShopTd[playerid][2], 0.208999, 1.291999);
    PlayerTextDrawAlignment(playerid, pFurnitureShopTd[playerid][2], 2);
    PlayerTextDrawColor(playerid, pFurnitureShopTd[playerid][2], -1378294017);
    PlayerTextDrawSetShadow(playerid, pFurnitureShopTd[playerid][2], 0);
    PlayerTextDrawSetOutline(playerid, pFurnitureShopTd[playerid][2], 1);
    PlayerTextDrawBackgroundColor(playerid, pFurnitureShopTd[playerid][2], 255);
    PlayerTextDrawFont(playerid, pFurnitureShopTd[playerid][2], 2);
    PlayerTextDrawSetProportional(playerid, pFurnitureShopTd[playerid][2], 1);

    pFurnitureShopTd[playerid][3] = CreatePlayerTextDraw(playerid, 265.000000, 319.000000, "~<~");
    PlayerTextDrawLetterSize(playerid, pFurnitureShopTd[playerid][3], 0.400000, 1.600000);
    PlayerTextDrawTextSize(playerid, pFurnitureShopTd[playerid][3], 16.000000, 20.000000);
    PlayerTextDrawAlignment(playerid, pFurnitureShopTd[playerid][3], 2);
    PlayerTextDrawColor(playerid, pFurnitureShopTd[playerid][3], -1);
    PlayerTextDrawSetShadow(playerid, pFurnitureShopTd[playerid][3], 0);
    PlayerTextDrawBackgroundColor(playerid, pFurnitureShopTd[playerid][3], 255);
    PlayerTextDrawFont(playerid, pFurnitureShopTd[playerid][3], 1);
    PlayerTextDrawSetProportional(playerid, pFurnitureShopTd[playerid][3], 1);
    PlayerTextDrawSetSelectable(playerid, pFurnitureShopTd[playerid][3], true);

    pFurnitureShopTd[playerid][4] = CreatePlayerTextDraw(playerid, 365.000000, 319.000000, "~>~");
    PlayerTextDrawLetterSize(playerid, pFurnitureShopTd[playerid][4], 0.400000, 1.600000);
    PlayerTextDrawTextSize(playerid, pFurnitureShopTd[playerid][4], 16.000000, 20.000000);
    PlayerTextDrawAlignment(playerid, pFurnitureShopTd[playerid][4], 2);
    PlayerTextDrawColor(playerid, pFurnitureShopTd[playerid][4], -1);
    PlayerTextDrawSetShadow(playerid, pFurnitureShopTd[playerid][4], 0);
    PlayerTextDrawBackgroundColor(playerid, pFurnitureShopTd[playerid][4], 255);
    PlayerTextDrawFont(playerid, pFurnitureShopTd[playerid][4], 1);
    PlayerTextDrawSetProportional(playerid, pFurnitureShopTd[playerid][4], 1);
    PlayerTextDrawSetSelectable(playerid, pFurnitureShopTd[playerid][4], true);

    pFurnitureShopTd[playerid][5] = CreatePlayerTextDraw(playerid, 320.000000, 355.000000, "Mueble_(0/0)");
    PlayerTextDrawLetterSize(playerid, pFurnitureShopTd[playerid][5], 0.301250, 1.416444);
    PlayerTextDrawTextSize(playerid, pFurnitureShopTd[playerid][5], 0.000000, 10.000000);
    PlayerTextDrawAlignment(playerid, pFurnitureShopTd[playerid][5], 2);
    PlayerTextDrawColor(playerid, pFurnitureShopTd[playerid][5], -1);
    PlayerTextDrawSetShadow(playerid, pFurnitureShopTd[playerid][5], 0);
    PlayerTextDrawSetOutline(playerid, pFurnitureShopTd[playerid][5], 1);
    PlayerTextDrawBackgroundColor(playerid, pFurnitureShopTd[playerid][5], 255);
    PlayerTextDrawFont(playerid, pFurnitureShopTd[playerid][5], 1);
    PlayerTextDrawSetProportional(playerid, pFurnitureShopTd[playerid][5], 1);

    pFurnitureShopTd[playerid][6] = CreatePlayerTextDraw(playerid, 265.000000, 354.000000, "~<~");
    PlayerTextDrawLetterSize(playerid, pFurnitureShopTd[playerid][6], 0.400000, 1.600000);
    PlayerTextDrawTextSize(playerid, pFurnitureShopTd[playerid][6], 16.000000, 20.000000);
    PlayerTextDrawAlignment(playerid, pFurnitureShopTd[playerid][6], 2);
    PlayerTextDrawColor(playerid, pFurnitureShopTd[playerid][6], -1);
    PlayerTextDrawSetShadow(playerid, pFurnitureShopTd[playerid][6], 0);
    PlayerTextDrawBackgroundColor(playerid, pFurnitureShopTd[playerid][6], 255);
    PlayerTextDrawFont(playerid, pFurnitureShopTd[playerid][6], 1);
    PlayerTextDrawSetProportional(playerid, pFurnitureShopTd[playerid][6], 1);
    PlayerTextDrawSetSelectable(playerid, pFurnitureShopTd[playerid][6], true);

    pFurnitureShopTd[playerid][7] = CreatePlayerTextDraw(playerid, 365.000000, 354.000000, "~>~");
    PlayerTextDrawLetterSize(playerid, pFurnitureShopTd[playerid][7], 0.400000, 1.600000);
    PlayerTextDrawTextSize(playerid, pFurnitureShopTd[playerid][7], 16.000000, 20.000000);
    PlayerTextDrawAlignment(playerid, pFurnitureShopTd[playerid][7], 2);
    PlayerTextDrawColor(playerid, pFurnitureShopTd[playerid][7], -1);
    PlayerTextDrawSetShadow(playerid, pFurnitureShopTd[playerid][7], 0);
    PlayerTextDrawBackgroundColor(playerid, pFurnitureShopTd[playerid][7], 255);
    PlayerTextDrawFont(playerid, pFurnitureShopTd[playerid][7], 1);
    PlayerTextDrawSetProportional(playerid, pFurnitureShopTd[playerid][7], 1);
    PlayerTextDrawSetSelectable(playerid, pFurnitureShopTd[playerid][7], true);

    pFurnitureShopTd[playerid][8] = CreatePlayerTextDraw(playerid, 320.000000, 369.000000, "0$");
    PlayerTextDrawLetterSize(playerid, pFurnitureShopTd[playerid][8], 0.208998, 1.291998);
    PlayerTextDrawAlignment(playerid, pFurnitureShopTd[playerid][8], 2);
    PlayerTextDrawColor(playerid, pFurnitureShopTd[playerid][8], -1378294017);
    PlayerTextDrawSetShadow(playerid, pFurnitureShopTd[playerid][8], 0);
    PlayerTextDrawSetOutline(playerid, pFurnitureShopTd[playerid][8], 1);
    PlayerTextDrawBackgroundColor(playerid, pFurnitureShopTd[playerid][8], 255);
    PlayerTextDrawFont(playerid, pFurnitureShopTd[playerid][8], 2);
    PlayerTextDrawSetProportional(playerid, pFurnitureShopTd[playerid][8], 1);

    pFurnitureShopTd[playerid][9] = CreatePlayerTextDraw(playerid, 320.000000, 390.000000, "Comprar");
    PlayerTextDrawLetterSize(playerid, pFurnitureShopTd[playerid][9], 0.208999, 1.291999);
    PlayerTextDrawTextSize(playerid, pFurnitureShopTd[playerid][9], 12.91999, 56.000000);
    PlayerTextDrawAlignment(playerid, pFurnitureShopTd[playerid][9], 2);
    PlayerTextDrawColor(playerid, pFurnitureShopTd[playerid][9], -1);
    PlayerTextDrawUseBox(playerid, pFurnitureShopTd[playerid][9], 1);
    PlayerTextDrawBoxColor(playerid, pFurnitureShopTd[playerid][9], -2139062017);
    PlayerTextDrawSetShadow(playerid, pFurnitureShopTd[playerid][9], 0);
    PlayerTextDrawSetOutline(playerid, pFurnitureShopTd[playerid][9], 1);
    PlayerTextDrawBackgroundColor(playerid, pFurnitureShopTd[playerid][9], 255);
    PlayerTextDrawFont(playerid, pFurnitureShopTd[playerid][9], 2);
    PlayerTextDrawSetProportional(playerid, pFurnitureShopTd[playerid][9], 1);
    PlayerTextDrawSetSelectable(playerid, pFurnitureShopTd[playerid][9], true);
}

CreatePlayerFurnitureShop(playerid) {
    DestroyPlayerFurnitureShop(playerid);
    CreatePFurnitureShopTextDraws(playerid);
    SetPlayerVirtualWorld(playerid, playerid + MAX_PLAYERS);
    for(new i = 0; i < sizeof pFurnitureShopTd[]; i ++) {
        if(pFurnitureShopTd[playerid][i] != PlayerText:INVALID_TEXT_DRAW) {
            PlayerTextDrawShow(playerid, pFurnitureShopTd[playerid][i]);
        }
    }
    SelectTextDrawEx(playerid, -1);

    pFurnitureShopOpened[playerid] = true;
    UpdatePlayerFurnitureShop(playerid);
    Streamer_Update(playerid, STREAMER_TYPE_OBJECT);
}

CountFurnitureObjectsInfoType(type) 
{
    new count = 0;
    for(new i = 0; i < sizeof FurnitureObjectsInfo; i ++) 
    {
        if(_:FurnitureObjectsInfo[i][foi_TYPE] == type) 
        {
            count ++;
        }
    }
    return count;
}

GetCurrentFurnitureObjectIndex(playerid) 
{
    new count;
    for(new i = 0; i < sizeof FurnitureObjectsInfo; i ++) 
    {
        if(_:FurnitureObjectsInfo[i][foi_TYPE] == pFurnitureShopCurrentType[playerid]) 
        {
            if(count == pFurnitureShopCurrentModel[playerid]){
                return i;
            }
            count ++;
        }
    }
    return -1;
}

InterpolatePCameraToFurType(playerid) 
{
    new type = pFurnitureShopCurrentType[playerid];

    /*new Float:p[6]
    GetPlayerCameraPos(playerid, p[0], p[1], p[2]);
    GetPlayerCameraLookAt(playerid, p[3], p[4], p[5]);
    InterpolateCameraPos(playerid, p[0], p[1], p[2], FurnitureTypesInfo[type][fti_CAM_X], FurnitureTypesInfo[type][fti_CAM_Y], FurnitureTypesInfo[type][fti_CAM_Z], FURNITURE_CAMERA_MOVE_TIME);
    InterpolateCameraLookAt(playerid, p[3], p[4], p[5], FurnitureTypesInfo[type][fti_CAM_LOOK_AT_X], FurnitureTypesInfo[type][fti_CAM_LOOK_AT_Y], FurnitureTypesInfo[type][fti_CAM_LOOK_AT_Z], FURNITURE_CAMERA_MOVE_TIME);*/

    SetPlayerCameraPos(playerid, FurnitureTypesInfo[type][fti_CAM_X], FurnitureTypesInfo[type][fti_CAM_Y], FurnitureTypesInfo[type][fti_CAM_Z]);
    SetPlayerCameraLookAt(playerid, FurnitureTypesInfo[type][fti_CAM_LOOK_AT_X], FurnitureTypesInfo[type][fti_CAM_LOOK_AT_Y], FurnitureTypesInfo[type][fti_CAM_LOOK_AT_Z]);
}

CMD:muebles(playerid, params[]) 
{
    if(!IsPlayerInRangeOfPoint(playerid, 1.0, FurnitureShopBuyPos[0], FurnitureShopBuyPos[1], FurnitureShopBuyPos[2])) return SendNotification(playerid, "No estás en el lugar adecuado.");
    if(pFurnitureShopOpened[playerid]) return SendNotification(playerid, "Ya estás viendo los muebles.");

    CreatePlayerFurnitureShop(playerid);
    return 1;
}

GetPObjectModelPrice(modelid) 
{
    for(new i = 0; i < sizeof FurnitureObjectsInfo; i ++) 
    {
        if(FurnitureObjectsInfo[i][foi_MODELID] == modelid) 
        {
            return FurnitureObjectsInfo[i][foi_PRICE];
        }
    }
    return 750;
}