stock AttachObjectToObjectEx(Float:oX, Float:oY, Float:oZ, Float:oRX, Float:oRY, Float:oRZ, Float:off_x, Float:off_y, Float:off_z, Float:rot_x, Float:rot_y, Float:rot_z, &Float:X, &Float:Y, &Float:Z, &Float:RX, &Float:RY, &Float:RZ) // By Stylock - http://forum.sa-mp.com/member.php?u=114165
{
	static
		Float:sin[3],
		Float:cos[3],
        Float:pos[3],
        Float:rot[3];

    pos[0] = oX;
    pos[1] = oY;
    pos[2] = oZ;
    rot[0] = oRX;
    rot[1] = oRY;
    rot[2] = oRZ;
	
	EDIT_FloatEulerFix(rot[0], rot[1], rot[2]);
	cos[0] = floatcos(rot[0], degrees); cos[1] = floatcos(rot[1], degrees); cos[2] = floatcos(rot[2], degrees); sin[0] = floatsin(rot[0], degrees); sin[1] = floatsin(rot[1], degrees); sin[2] = floatsin(rot[2], degrees);
	pos[0] = pos[0] + off_x * cos[1] * cos[2] - off_x * sin[0] * sin[1] * sin[2] - off_y * cos[0] * sin[2] + off_z * sin[1] * cos[2] + off_z * sin[0] * cos[1] * sin[2];
	pos[1] = pos[1] + off_x * cos[1] * sin[2] + off_x * sin[0] * sin[1] * cos[2] + off_y * cos[0] * cos[2] + off_z * sin[1] * sin[2] - off_z * sin[0] * cos[1] * cos[2];
	pos[2] = pos[2] - off_x * cos[0] * sin[1] + off_y * sin[0] + off_z * cos[0] * cos[1];
	rot[0] = asin(cos[0] * cos[1]); rot[1] = atan2(sin[0], cos[0] * sin[1]) + rot_z; rot[2] = atan2(cos[1] * cos[2] * sin[0] - sin[1] * sin[2], cos[2] * sin[1] - cos[1] * sin[0] * -sin[2]);
	cos[0] = floatcos(rot[0], degrees); cos[1] = floatcos(rot[1], degrees); cos[2] = floatcos(rot[2], degrees); sin[0] = floatsin(rot[0], degrees); sin[1] = floatsin(rot[1], degrees); sin[2] = floatsin(rot[2], degrees);
	rot[0] = asin(cos[0] * sin[1]); rot[1] = atan2(cos[0] * cos[1], sin[0]); rot[2] = atan2(cos[2] * sin[0] * sin[1] - cos[1] * sin[2], cos[1] * cos[2] + sin[0] * sin[1] * sin[2]);
	cos[0] = floatcos(rot[0], degrees); cos[1] = floatcos(rot[1], degrees); cos[2] = floatcos(rot[2], degrees); sin[0] = floatsin(rot[0], degrees); sin[1] = floatsin(rot[1], degrees); sin[2] = floatsin(rot[2], degrees);
	rot[0] = atan2(sin[0], cos[0] * cos[1]) + rot_x; rot[1] = asin(cos[0] * sin[1]); rot[2] = atan2(cos[2] * sin[0] * sin[1] + cos[1] * sin[2], cos[1] * cos[2] - sin[0] * sin[1] * sin[2]);
	cos[0] = floatcos(rot[0], degrees); cos[1] = floatcos(rot[1], degrees); cos[2] = floatcos(rot[2], degrees); sin[0] = floatsin(rot[0], degrees); sin[1] = floatsin(rot[1], degrees); sin[2] = floatsin(rot[2], degrees);
	rot[0] = asin(cos[1] * sin[0]); rot[1] = atan2(sin[1], cos[0] * cos[1]) + rot_y; rot[2] = atan2(cos[0] * sin[2] - cos[2] * sin[0] * sin[1], cos[0] * cos[2] + sin[0] * sin[1] * sin[2]);
	X = pos[0];
	Y = pos[1];
	Z = pos[2];
	RX = rot[0];
	RY = rot[1];
 	RZ = rot[2];
}

stock EDIT_FloatEulerFix(&Float:rot_x, &Float:rot_y, &Float:rot_z)
{
    EDIT_FloatGetRemainder(rot_x, rot_y, rot_z);
    if((!floatcmp(rot_x, 0.0) || !floatcmp(rot_x, 360.0))
    && (!floatcmp(rot_y, 0.0) || !floatcmp(rot_y, 360.0)))
    {
        rot_y = 0.0000002;
    }
    return 1;
}

stock EDIT_FloatGetRemainder(&Float:rot_x, &Float:rot_y, &Float:rot_z)
{
    EDIT_FloatRemainder(rot_x, 360.0);
    EDIT_FloatRemainder(rot_y, 360.0);
    EDIT_FloatRemainder(rot_z, 360.0);
    return 1;
}

stock EDIT_FloatRemainder(&Float:remainder, Float:value)
{
    if(remainder >= value)
    {
        while(remainder >= value)
        {
            remainder = remainder - value;
        }
    }
    else if(remainder < 0.0)
    {
        while(remainder < 0.0)
        {
            remainder = remainder + value;
        }
    }
    return 1;
}