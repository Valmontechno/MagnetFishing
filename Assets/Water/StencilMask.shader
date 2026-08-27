Shader "Custom/StencilMask"
{
    Properties
    {
        [IntRange] _Value ("Stencil Value", Range(0, 255)) = 1
    }

    SubShader
    {
        Tags
        {
            "RenderPipeline" = "UniversalPipeline"
            "Queue" = "Geometry-1"
        }

        ColorMask 0
        ZWrite Off

        Stencil
        {
            Ref [_Value]
            Comp Always
            Pass Replace
        }

        Pass
        {
        }
    }
}