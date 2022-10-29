#include <YSI-Includes\YSI\y_hooks>

hook OnSanAndreasVehicleLoad(vehicleid)
{
	if(GLOBAL_VEHICLES[vehicleid][gb_vehicle_TYPE] == VEHICLE_TYPE_WORK)
	{
		switch(WORK_VEHICLES[vehicleid][work_vehicle_WORK])
		{
			case WORK_TAXI:
			{
				if(GLOBAL_VEHICLES[vehicleid][gb_vehicle_MODELID] == 560)
				{
					new slot = GetVehicleFreeObjectSlot(vehicleid);
					if(slot != -1)
					{
						VEHICLE_OBJECTS[vehicleid][slot][vobject_VALID] = true;
			            VEHICLE_OBJECTS[vehicleid][slot][vobject_TYPE] = VOBJECT_TYPE_OBJECT;
			            VEHICLE_OBJECTS[vehicleid][slot][vobject_ID] = 0;
			            VEHICLE_OBJECTS[vehicleid][slot][vobject_MODELID] = 19308;
			            VEHICLE_OBJECTS[vehicleid][slot][vobject_ATTACHED] = true;

			            VEHICLE_OBJECTS[vehicleid][slot][vobject_OFFSET][0] = 0.0;
			            VEHICLE_OBJECTS[vehicleid][slot][vobject_OFFSET][1] = -0.17001;
			            VEHICLE_OBJECTS[vehicleid][slot][vobject_OFFSET][2] = 0.929996;
			            VEHICLE_OBJECTS[vehicleid][slot][vobject_ROT][0] = 0.0;
			            VEHICLE_OBJECTS[vehicleid][slot][vobject_ROT][1] = 0.0;
			            VEHICLE_OBJECTS[vehicleid][slot][vobject_ROT][2] = 0.0;

			            UpdateVehicleAttachedObject(vehicleid, slot);
			        }
				}
			}
			case WORK_POLICE:
			{
				if(GLOBAL_VEHICLES[vehicleid][gb_vehicle_MODELID] == 411)
				{
					new slot = GetVehicleFreeObjectSlot(vehicleid);
					if(slot != -1)
					{
						VEHICLE_OBJECTS[vehicleid][slot][vobject_VALID] = true;
						VEHICLE_OBJECTS[vehicleid][slot][vobject_TYPE] = VOBJECT_TYPE_OBJECT;
						VEHICLE_OBJECTS[vehicleid][slot][vobject_MODELID] = 1247;
						VEHICLE_OBJECTS[vehicleid][slot][vobject_ID] = 0;
						VEHICLE_OBJECTS[vehicleid][slot][vobject_ATTACHED] = true;

						VEHICLE_OBJECTS[vehicleid][slot][vobject_OFFSET][0] = 0.030243;
			            VEHICLE_OBJECTS[vehicleid][slot][vobject_OFFSET][1] = -2.52998;
			            VEHICLE_OBJECTS[vehicleid][slot][vobject_OFFSET][2] = 0.063493;
			            VEHICLE_OBJECTS[vehicleid][slot][vobject_ROT][0] = 0.0;
			            VEHICLE_OBJECTS[vehicleid][slot][vobject_ROT][1] = 0.0;
			            VEHICLE_OBJECTS[vehicleid][slot][vobject_ROT][2] = 0.0;

			            UpdateVehicleAttachedObject(vehicleid, slot);
					}

					slot = GetVehicleFreeObjectSlot(vehicleid);
					if(slot != -1)
					{
						VEHICLE_OBJECTS[vehicleid][slot][vobject_VALID] = true;
						VEHICLE_OBJECTS[vehicleid][slot][vobject_TYPE] = VOBJECT_TYPE_OBJECT;
						VEHICLE_OBJECTS[vehicleid][slot][vobject_MODELID] = 19620;
						VEHICLE_OBJECTS[vehicleid][slot][vobject_ID] = 0;
						VEHICLE_OBJECTS[vehicleid][slot][vobject_ATTACHED] = true;

						VEHICLE_OBJECTS[vehicleid][slot][vobject_OFFSET][0] = 0.0;
			            VEHICLE_OBJECTS[vehicleid][slot][vobject_OFFSET][1] = 0.260006;
			            VEHICLE_OBJECTS[vehicleid][slot][vobject_OFFSET][2] = 0.679999;
			            VEHICLE_OBJECTS[vehicleid][slot][vobject_ROT][0] = 0.0;
			            VEHICLE_OBJECTS[vehicleid][slot][vobject_ROT][1] = 0.0;
			            VEHICLE_OBJECTS[vehicleid][slot][vobject_ROT][2] = 0.0;

			            UpdateVehicleAttachedObject(vehicleid, slot);
					}

					slot = GetVehicleFreeObjectSlot(vehicleid);
					if(slot != -1)
					{
						VEHICLE_OBJECTS[vehicleid][slot][vobject_VALID] = true;
						VEHICLE_OBJECTS[vehicleid][slot][vobject_TYPE] = VOBJECT_TYPE_OBJECT;
						VEHICLE_OBJECTS[vehicleid][slot][vobject_MODELID] = 19893;
						VEHICLE_OBJECTS[vehicleid][slot][vobject_ID] = 0;
						VEHICLE_OBJECTS[vehicleid][slot][vobject_ATTACHED] = true;

						VEHICLE_OBJECTS[vehicleid][slot][vobject_OFFSET][0] = 0.0;
			            VEHICLE_OBJECTS[vehicleid][slot][vobject_OFFSET][1] = 0.500011;
			            VEHICLE_OBJECTS[vehicleid][slot][vobject_OFFSET][2] = -0.01;
			            VEHICLE_OBJECTS[vehicleid][slot][vobject_ROT][0] = 0.0;
			            VEHICLE_OBJECTS[vehicleid][slot][vobject_ROT][1] = 0.0;
			            VEHICLE_OBJECTS[vehicleid][slot][vobject_ROT][2] = 0.0;

			            UpdateVehicleAttachedObject(vehicleid, slot);
					}
				}
			}
		}
	}
}