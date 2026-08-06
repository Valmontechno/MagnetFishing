using UnityEngine;

public static class Utils
{
    public static float Remap(this float value, float from1, float to1, float from2, float to2)
    {
        return (value - from1) / (to1 - from1) * (to2 - from2) + from2;
    }

    public static Vector2 XZ(Vector3 vector)
    {
        return new Vector2(vector.x, vector.z);
    }

    public static Vector3 XyY(Vector2 vector, float y=0)
    {
        return new Vector3(vector.x, y, vector.y);
    }

    public static Vector3 SetY(Vector3 vector, float y)
    {
        vector.y = y;
        return vector;
    }

    public static float Warp180(float value)
    {
        if (value > 180)
            return value - 360;
        else if (value <= -180)
            return value + 360;
        return value;
    }
}
