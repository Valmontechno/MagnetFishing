#ifndef RIPPLE_FUNCTION_INCLUED
#define RIPPLE_FUNCTION_INCLUED

#define RIPPLES_COUNT 20
float4 _ripples[RIPPLES_COUNT]; // x, y, radius, date

void RippleFunction_float(
    float2 position,
    float time,
    float frequency,
    float duration,
    float speed,
    out float result
)
{
    //_ripples[0] = float4(0, 0, 1, 0);

    result = 0;

    for(int i = 0; i < RIPPLES_COUNT; i++)
    {
        float2 center = _ripples[i].xy;
        float radius = _ripples[i].z;
        float date = _ripples[i].w;

        float age = clamp((time - date) / duration, 0, 1);

        radius = radius + age * speed;
        float extent = max(radius - distance(center, position), 0);
        result += sin((extent + time) * frequency) * extent * (1 - age);
        
    }

    result = clamp(result, 0, 1);
}

#endif