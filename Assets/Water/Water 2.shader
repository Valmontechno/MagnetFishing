Shader "Custom/Water 2"
{
    Properties
    {
        _Scale("Scale", Float) = 1
        _FlowSpeed("FlowSpeed", Float) = 0.1
        _FlowDirection("FlowDirection", Vector, 2) = (1, 0, 0, 0)
        _WaterColor("WaterColor", Color) = (0, 0.5188804, 1, 1)
        _Frequency("Frequency", Float) = 28.76
        [HDR]_PatternColor("PatternColor", Color) = (0.5529096, 2.015, 2.307419, 1)
        _PatternSpeed("PatternSpeed", Float) = 1
        _PatternDensity("PatternDensity", Float) = 7.5
        _PatternCutoff("PatternCutoff", Float) = 100
        _WaveSpeed("WaveSpeed", Float) = 0.2
        _WaveSpread("WaveSpread", Float) = 10
        _WaveHeight("WaveHeight", Float) = 1
        _FoamColor("FoamColor", Color) = (1, 1, 1, 1)
        _FoamScale("FoamScale", Float) = 10
        _FoamAmount("FoamAmount", Float) = 0.75
        _FoamCutoff("FoamCutoff", Float) = 1
        _RippleColor("RippleColor", Color) = (1, 0, 0, 0)
        _RippleDuration("RippleDuration", Float) = 0.4
        _RippleSpeed("RippleSpeed", Float) = 1
        [HideInInspector]_QueueOffset("_QueueOffset", Float) = 0
        [HideInInspector]_QueueControl("_QueueControl", Float) = -1
        [HideInInspector][NoScaleOffset]unity_Lightmaps("unity_Lightmaps", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_LightmapsInd("unity_LightmapsInd", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_ShadowMasks("unity_ShadowMasks", 2DArray) = "" {}
    }
    SubShader
    {
        Tags
        {
            "RenderPipeline"="UniversalPipeline"
            "RenderType"="Transparent"
            "UniversalMaterialType" = "Lit"
            "Queue"="Transparent"
            "DisableBatching"="LODFading"
            "ShaderGraphShader"="true"
            "ShaderGraphTargetId"="UniversalLitSubTarget"
        }
        Pass
        {
            Name "Universal Forward"
            Tags
            {
                "LightMode" = "UniversalForward"
            }
        
        // Render State
        Cull Back
        Blend One Zero
        ZTest LEqual
        ZWrite On
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma multi_compile_instancing
        #pragma instancing_options renderinglayer
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma multi_compile_fragment _ _SCREEN_SPACE_OCCLUSION
        #pragma multi_compile_fragment _ _SCREEN_SPACE_IRRADIANCE
        #pragma multi_compile _ LIGHTMAP_ON
        #pragma multi_compile _ DYNAMICLIGHTMAP_ON
        #pragma multi_compile _ DIRLIGHTMAP_COMBINED
        #pragma multi_compile _ USE_LEGACY_LIGHTMAPS
        #pragma multi_compile _ LIGHTMAP_BICUBIC_SAMPLING
        #pragma multi_compile _ REFLECTION_PROBE_ROTATION
        #pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
        #pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
        #pragma multi_compile_fragment _ _ADDITIONAL_LIGHT_SHADOWS
        #pragma multi_compile_fragment _ _REFLECTION_PROBE_BLENDING
        #pragma multi_compile_fragment _ _REFLECTION_PROBE_BOX_PROJECTION
        #pragma multi_compile_fragment _ _REFLECTION_PROBE_ATLAS
        #pragma multi_compile_fragment _ _SHADOWS_SOFT _SHADOWS_SOFT_LOW _SHADOWS_SOFT_MEDIUM _SHADOWS_SOFT_HIGH
        #pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
        #pragma multi_compile _ SHADOWS_SHADOWMASK
        #pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
        #pragma multi_compile_fragment _ _LIGHT_LAYERS
        #pragma multi_compile_fragment _ DEBUG_DISPLAY
        #pragma multi_compile_fragment _ _LIGHT_COOKIES
        #pragma multi_compile _ _CLUSTER_LIGHT_LOOP
        #pragma multi_compile _ EVALUATE_SH_MIXED EVALUATE_SH_VERTEX
        #pragma multi_compile _ LOD_FADE_CROSSFADE
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define ATTRIBUTES_NEED_TEXCOORD2
        #define GRAPH_VERTEX_USES_TIME_PARAMETERS_INPUT
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
        #define VARYINGS_NEED_SHADOW_COORD
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_FORWARD
        #define _RECEIVE_SHADOWS_OFF 1
        #define USE_UNITY_CROSSFADE 1
        #define REQUIRE_DEPTH_TEXTURE
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Fog.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ProbeVolumeVariants.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/LODCrossFade.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv1 : TEXCOORD1;
             float4 uv2 : TEXCOORD2;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 tangentWS;
            #if defined(LIGHTMAP_ON)
             float2 staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
             float2 dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
             float3 sh;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
             float4 probeOcclusion;
            #endif
             float4 fogFactorAndVertexLight;
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
             float4 shadowCoord;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 TangentSpaceNormal;
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float2 NDCPosition;
             float2 PixelPosition;
             float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float3 WorldSpacePosition;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
            #if defined(LIGHTMAP_ON)
             float2 staticLightmapUV : INTERP0;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
             float2 dynamicLightmapUV : INTERP1;
            #endif
            #if !defined(LIGHTMAP_ON)
             float3 sh : INTERP2;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
             float4 probeOcclusion : INTERP3;
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
             float4 shadowCoord : INTERP4;
            #endif
             float4 tangentWS : INTERP5;
             float4 fogFactorAndVertexLight : INTERP6;
             float3 positionWS : INTERP7;
             float3 normalWS : INTERP8;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            #if defined(LIGHTMAP_ON)
            output.staticLightmapUV = input.staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            output.dynamicLightmapUV = input.dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.sh;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
            output.probeOcclusion = input.probeOcclusion;
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            output.shadowCoord = input.shadowCoord;
            #endif
            output.tangentWS.xyzw = input.tangentWS;
            output.fogFactorAndVertexLight.xyzw = input.fogFactorAndVertexLight;
            output.positionWS.xyz = input.positionWS;
            output.normalWS.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            #if defined(LIGHTMAP_ON)
            output.staticLightmapUV = input.staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            output.dynamicLightmapUV = input.dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.sh;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
            output.probeOcclusion = input.probeOcclusion;
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            output.shadowCoord = input.shadowCoord;
            #endif
            output.tangentWS = input.tangentWS.xyzw;
            output.fogFactorAndVertexLight = input.fogFactorAndVertexLight.xyzw;
            output.positionWS = input.positionWS.xyz;
            output.normalWS = input.normalWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _PatternSpeed;
        float _FlowSpeed;
        float2 _FlowDirection;
        float _WaveSpread;
        float _WaveHeight;
        float _WaveSpeed;
        float _Scale;
        float _PatternDensity;
        float4 _WaterColor;
        float4 _PatternColor;
        float _FoamScale;
        float _FoamAmount;
        float _FoamCutoff;
        float4 _FoamColor;
        float _PatternCutoff;
        float _Frequency;
        float4 _RippleColor;
        float _RippleDuration;
        float _RippleSpeed;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        
        // Graph Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
        #include_with_pragmas "Assets/Water/RippleFunction.hlsl"
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Divide_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A / B;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        float2 Unity_GradientNoise_Deterministic_Dir_float(float2 p)
        {
            float x; Hash_Tchou_2_1_float(p, x);
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_Deterministic_float (float2 UV, float3 Scale, out float Out)
        {
            float2 p = UV * Scale.xy;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_Distance_float3(float3 A, float3 B, out float Out)
        {
            Out = distance(A, B);
        }
        
        void Unity_InverseLerp_float(float A, float B, float T, out float Out)
        {
            Out = (T - A)/(B - A);
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        float2 Unity_Voronoi_RandomVector_Deterministic_float (float2 UV, float offset)
        {
            Hash_Tchou_2_2_float(UV, UV);
            return float2(sin(UV.y * offset), cos(UV.x * offset)) * 0.5 + 0.5;
        }
        
        void Unity_Voronoi_Deterministic_float(float2 UV, float AngleOffset, float CellDensity, out float Out, out float Cells)
        {
            float2 g = floor(UV * CellDensity);
            float2 f = frac(UV * CellDensity);
            float t = 8.0;
            float3 res = float3(8.0, 0.0, 0.0);
            for (int y = -1; y <= 1; y++)
            {
                for (int x = -1; x <= 1; x++)
                {
                    float2 lattice = float2(x, y);
                    float2 offset = Unity_Voronoi_RandomVector_Deterministic_float(lattice + g, AngleOffset);
                    float d = distance(lattice + offset, f);
                    if (d < res.x)
                    {
                        res = float3(d, offset.x, offset.y);
                        Out = res.x;
                        Cells = res.y;
                    }
                }
            }
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_Add_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A + B;
        }
        
        void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
        {
            if (unity_OrthoParams.w == 1.0)
            {
                Out = LinearEyeDepth(ComputeWorldSpacePosition(UV.xy, SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), UNITY_MATRIX_I_VP), UNITY_MATRIX_V);
            }
            else
            {
                Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
            }
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        struct Bindings_DepthFade_8bbfe621c0368244b80a10cdd14cd70e_float
        {
        float4 ScreenPosition;
        float2 NDCPosition;
        };
        
        void SG_DepthFade_8bbfe621c0368244b80a10cdd14cd70e_float(float _Distance, Bindings_DepthFade_8bbfe621c0368244b80a10cdd14cd70e_float IN, out float Out_1)
        {
        float _SceneDepth_2eb96c52a24a4558b37a5f543bc363b1_Out_1_Float;
        Unity_SceneDepth_Eye_float(float4(IN.NDCPosition.xy, 0, 0), _SceneDepth_2eb96c52a24a4558b37a5f543bc363b1_Out_1_Float);
        float4 _ScreenPosition_4c9380fe7a70484c8beb74b5792bdbc8_Out_0_Vector4 = IN.ScreenPosition;
        float _Split_9c58755aea204a38a422f36c78e4d894_R_1_Float = _ScreenPosition_4c9380fe7a70484c8beb74b5792bdbc8_Out_0_Vector4[0];
        float _Split_9c58755aea204a38a422f36c78e4d894_G_2_Float = _ScreenPosition_4c9380fe7a70484c8beb74b5792bdbc8_Out_0_Vector4[1];
        float _Split_9c58755aea204a38a422f36c78e4d894_B_3_Float = _ScreenPosition_4c9380fe7a70484c8beb74b5792bdbc8_Out_0_Vector4[2];
        float _Split_9c58755aea204a38a422f36c78e4d894_A_4_Float = _ScreenPosition_4c9380fe7a70484c8beb74b5792bdbc8_Out_0_Vector4[3];
        float _Subtract_4b0c684883d8435c9e6d251f76545c9a_Out_2_Float;
        Unity_Subtract_float(_SceneDepth_2eb96c52a24a4558b37a5f543bc363b1_Out_1_Float, _Split_9c58755aea204a38a422f36c78e4d894_A_4_Float, _Subtract_4b0c684883d8435c9e6d251f76545c9a_Out_2_Float);
        float _Property_71a843c8a2ad403b8140354c6a881afd_Out_0_Float = _Distance;
        float _Divide_6a045dbede5f44819286797f917918ac_Out_2_Float;
        Unity_Divide_float(_Subtract_4b0c684883d8435c9e6d251f76545c9a_Out_2_Float, _Property_71a843c8a2ad403b8140354c6a881afd_Out_0_Float, _Divide_6a045dbede5f44819286797f917918ac_Out_2_Float);
        float _Saturate_f45f6fa4775044429c760084824ef684_Out_1_Float;
        Unity_Saturate_float(_Divide_6a045dbede5f44819286797f917918ac_Out_2_Float, _Saturate_f45f6fa4775044429c760084824ef684_Out_1_Float);
        Out_1 = _Saturate_f45f6fa4775044429c760084824ef684_Out_1_Float;
        }
        
        void Unity_Step_float(float Edge, float In, out float Out)
        {
            Out = step(Edge, In);
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Property_d27cf8a7dad34ecd96496a2e168a017f_Out_0_Float = _WaveHeight;
            float _Split_a4a9df004cc4457ab200382a084abebd_R_1_Float = IN.WorldSpacePosition[0];
            float _Split_a4a9df004cc4457ab200382a084abebd_G_2_Float = IN.WorldSpacePosition[1];
            float _Split_a4a9df004cc4457ab200382a084abebd_B_3_Float = IN.WorldSpacePosition[2];
            float _Split_a4a9df004cc4457ab200382a084abebd_A_4_Float = 0;
            float2 _Vector2_2a9c14ca8f744a208e525959dee4a260_Out_0_Vector2 = float2(_Split_a4a9df004cc4457ab200382a084abebd_R_1_Float, _Split_a4a9df004cc4457ab200382a084abebd_B_3_Float);
            float _Property_19f075486b9748cda9e8985ad901e546_Out_0_Float = _Scale;
            float2 _Divide_18910aaaf2724bc18f244ce72424925b_Out_2_Vector2;
            Unity_Divide_float2(_Vector2_2a9c14ca8f744a208e525959dee4a260_Out_0_Vector2, (_Property_19f075486b9748cda9e8985ad901e546_Out_0_Float.xx), _Divide_18910aaaf2724bc18f244ce72424925b_Out_2_Vector2);
            float2 _Property_54fb6e94cfc349049bf82b6de2a35e4d_Out_0_Vector2 = _FlowDirection;
            float _Property_62bb68af8ede43f6a392167fdaca1c04_Out_0_Float = _WaveSpeed;
            float _Multiply_fa246fa412f543c18db54cbf79b06304_Out_2_Float;
            Unity_Multiply_float_float(_Property_62bb68af8ede43f6a392167fdaca1c04_Out_0_Float, IN.TimeParameters.x, _Multiply_fa246fa412f543c18db54cbf79b06304_Out_2_Float);
            float2 _Multiply_7e3f5e405dcb43cb9d5c7f6b2de9ddbd_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Property_54fb6e94cfc349049bf82b6de2a35e4d_Out_0_Vector2, (_Multiply_fa246fa412f543c18db54cbf79b06304_Out_2_Float.xx), _Multiply_7e3f5e405dcb43cb9d5c7f6b2de9ddbd_Out_2_Vector2);
            float2 _TilingAndOffset_07da4fb4f18642ef83ac45f44e00d13a_Out_3_Vector2;
            Unity_TilingAndOffset_float(_Divide_18910aaaf2724bc18f244ce72424925b_Out_2_Vector2, float2 (1, 1), _Multiply_7e3f5e405dcb43cb9d5c7f6b2de9ddbd_Out_2_Vector2, _TilingAndOffset_07da4fb4f18642ef83ac45f44e00d13a_Out_3_Vector2);
            float _Property_197bb7e4b1d5495a848b56f391c3ca94_Out_0_Float = _WaveSpread;
            float _GradientNoise_c4a6176d4d8e46c98e887e141f128ace_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_07da4fb4f18642ef83ac45f44e00d13a_Out_3_Vector2, _Property_197bb7e4b1d5495a848b56f391c3ca94_Out_0_Float, _GradientNoise_c4a6176d4d8e46c98e887e141f128ace_Out_2_Float);
            float _OneMinus_5666200d4b784081927194d399b19546_Out_1_Float;
            Unity_OneMinus_float(_GradientNoise_c4a6176d4d8e46c98e887e141f128ace_Out_2_Float, _OneMinus_5666200d4b784081927194d399b19546_Out_1_Float);
            float _Remap_df0e169dec134e1494011460992d4857_Out_3_Float;
            Unity_Remap_float(_OneMinus_5666200d4b784081927194d399b19546_Out_1_Float, float2 (0, 1), float2 (-1, 1), _Remap_df0e169dec134e1494011460992d4857_Out_3_Float);
            float _Multiply_21e2fe9741664562a375c951fee94e29_Out_2_Float;
            Unity_Multiply_float_float(_Property_d27cf8a7dad34ecd96496a2e168a017f_Out_0_Float, _Remap_df0e169dec134e1494011460992d4857_Out_3_Float, _Multiply_21e2fe9741664562a375c951fee94e29_Out_2_Float);
            float3 _Multiply_1bca5d8c2e8b4f69965496a79b732a5e_Out_2_Vector3;
            Unity_Multiply_float3_float3(IN.ObjectSpaceNormal, (_Multiply_21e2fe9741664562a375c951fee94e29_Out_2_Float.xxx), _Multiply_1bca5d8c2e8b4f69965496a79b732a5e_Out_2_Vector3);
            float3 _Add_8792ee7fc1774e53b8df716cea19ceeb_Out_2_Vector3;
            Unity_Add_float3(_Multiply_1bca5d8c2e8b4f69965496a79b732a5e_Out_2_Vector3, IN.ObjectSpacePosition, _Add_8792ee7fc1774e53b8df716cea19ceeb_Out_2_Vector3);
            description.Position = _Add_8792ee7fc1774e53b8df716cea19ceeb_Out_2_Vector3;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float3 NormalTS;
            float3 Emission;
            float Metallic;
            float Smoothness;
            float Occlusion;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _Property_671d70dd5da140ee96643d243dc37fd8_Out_0_Vector4 = _WaterColor;
            float _Property_dad906e3a15845749abaee1638b45450_Out_0_Float = _PatternCutoff;
            float _Distance_cc5c484eebf44373a1398dd7e1ff845c_Out_2_Float;
            Unity_Distance_float3(IN.WorldSpacePosition, _WorldSpaceCameraPos, _Distance_cc5c484eebf44373a1398dd7e1ff845c_Out_2_Float);
            float _InverseLerp_a4e53d21ad914646bd2fa3203824b74a_Out_3_Float;
            Unity_InverseLerp_float(_Property_dad906e3a15845749abaee1638b45450_Out_0_Float, float(0), _Distance_cc5c484eebf44373a1398dd7e1ff845c_Out_2_Float, _InverseLerp_a4e53d21ad914646bd2fa3203824b74a_Out_3_Float);
            float _Saturate_aec1f9a3c440421da2b762a373cb90af_Out_1_Float;
            Unity_Saturate_float(_InverseLerp_a4e53d21ad914646bd2fa3203824b74a_Out_3_Float, _Saturate_aec1f9a3c440421da2b762a373cb90af_Out_1_Float);
            float4 _Property_d1a487fb48c74645a6287a2efe9e84ec_Out_0_Vector4 = IsGammaSpace() ? LinearToSRGB(_PatternColor) : _PatternColor;
            float _Split_6514885e4bf748d7a415566148d27785_R_1_Float = IN.WorldSpacePosition[0];
            float _Split_6514885e4bf748d7a415566148d27785_G_2_Float = IN.WorldSpacePosition[1];
            float _Split_6514885e4bf748d7a415566148d27785_B_3_Float = IN.WorldSpacePosition[2];
            float _Split_6514885e4bf748d7a415566148d27785_A_4_Float = 0;
            float2 _Vector2_aacd28bdf4cf4521b9d76e9dbe00d1e0_Out_0_Vector2 = float2(_Split_6514885e4bf748d7a415566148d27785_R_1_Float, _Split_6514885e4bf748d7a415566148d27785_B_3_Float);
            float _Property_35d111bad030402bbf4b94caac81b7f5_Out_0_Float = _Scale;
            float2 _Divide_72c033936cee42ee80147ea81c9d2ecf_Out_2_Vector2;
            Unity_Divide_float2(_Vector2_aacd28bdf4cf4521b9d76e9dbe00d1e0_Out_0_Vector2, (_Property_35d111bad030402bbf4b94caac81b7f5_Out_0_Float.xx), _Divide_72c033936cee42ee80147ea81c9d2ecf_Out_2_Vector2);
            float2 _Property_3ee92cea9de142c296a1467413ffd108_Out_0_Vector2 = _FlowDirection;
            float _Property_47d6f34367a74d388cde1a2ecaf6ccda_Out_0_Float = _FlowSpeed;
            float _Multiply_979a08f5be6e43a7ac018afb58904b04_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_47d6f34367a74d388cde1a2ecaf6ccda_Out_0_Float, _Multiply_979a08f5be6e43a7ac018afb58904b04_Out_2_Float);
            float2 _Multiply_c26278cacbce4cb1a639bf0229ed4f3b_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Property_3ee92cea9de142c296a1467413ffd108_Out_0_Vector2, (_Multiply_979a08f5be6e43a7ac018afb58904b04_Out_2_Float.xx), _Multiply_c26278cacbce4cb1a639bf0229ed4f3b_Out_2_Vector2);
            float2 _TilingAndOffset_c6acd5a2b68d4f079820e39856a12d58_Out_3_Vector2;
            Unity_TilingAndOffset_float(_Divide_72c033936cee42ee80147ea81c9d2ecf_Out_2_Vector2, float2 (1, 1), _Multiply_c26278cacbce4cb1a639bf0229ed4f3b_Out_2_Vector2, _TilingAndOffset_c6acd5a2b68d4f079820e39856a12d58_Out_3_Vector2);
            float _Property_17027e778cf54529aae8b565ff3e1f98_Out_0_Float = _PatternSpeed;
            float _Multiply_b502ebc2c57440149af34fae45d33914_Out_2_Float;
            Unity_Multiply_float_float(_Property_17027e778cf54529aae8b565ff3e1f98_Out_0_Float, IN.TimeParameters.x, _Multiply_b502ebc2c57440149af34fae45d33914_Out_2_Float);
            float _Property_3f313ed937e5421a92aa2eed66441c05_Out_0_Float = _PatternDensity;
            float _Voronoi_49347d90d7f84f2688bd11c85c622d4a_Out_3_Float;
            float _Voronoi_49347d90d7f84f2688bd11c85c622d4a_Cells_4_Float;
            Unity_Voronoi_Deterministic_float(_TilingAndOffset_c6acd5a2b68d4f079820e39856a12d58_Out_3_Vector2, _Multiply_b502ebc2c57440149af34fae45d33914_Out_2_Float, _Property_3f313ed937e5421a92aa2eed66441c05_Out_0_Float, _Voronoi_49347d90d7f84f2688bd11c85c622d4a_Out_3_Float, _Voronoi_49347d90d7f84f2688bd11c85c622d4a_Cells_4_Float);
            float _Power_5fa13e83b0bd4a30948e58d874ec8e1c_Out_2_Float;
            Unity_Power_float(_Voronoi_49347d90d7f84f2688bd11c85c622d4a_Out_3_Float, float(5), _Power_5fa13e83b0bd4a30948e58d874ec8e1c_Out_2_Float);
            float4 _Multiply_71f563a2f0994124a41103b119f6ef23_Out_2_Vector4;
            Unity_Multiply_float4_float4(_Property_d1a487fb48c74645a6287a2efe9e84ec_Out_0_Vector4, (_Power_5fa13e83b0bd4a30948e58d874ec8e1c_Out_2_Float.xxxx), _Multiply_71f563a2f0994124a41103b119f6ef23_Out_2_Vector4);
            float4 _Multiply_6366b6f890e24726a301b5317d8cca7f_Out_2_Vector4;
            Unity_Multiply_float4_float4((_Saturate_aec1f9a3c440421da2b762a373cb90af_Out_1_Float.xxxx), _Multiply_71f563a2f0994124a41103b119f6ef23_Out_2_Vector4, _Multiply_6366b6f890e24726a301b5317d8cca7f_Out_2_Vector4);
            float4 _Add_ecc8b0b6f3da4501b6a1866fd0669de6_Out_2_Vector4;
            Unity_Add_float4(_Property_671d70dd5da140ee96643d243dc37fd8_Out_0_Vector4, _Multiply_6366b6f890e24726a301b5317d8cca7f_Out_2_Vector4, _Add_ecc8b0b6f3da4501b6a1866fd0669de6_Out_2_Vector4);
            float4 _Property_487ab90812634ee7a3ee5e7286c31b37_Out_0_Vector4 = _FoamColor;
            float _Property_f098ae14b87349b18021704e4796e375_Out_0_Float = _FoamAmount;
            Bindings_DepthFade_8bbfe621c0368244b80a10cdd14cd70e_float _DepthFade_e9f6efdeeea748d5b9489cb9356db947;
            _DepthFade_e9f6efdeeea748d5b9489cb9356db947.ScreenPosition = IN.ScreenPosition;
            _DepthFade_e9f6efdeeea748d5b9489cb9356db947.NDCPosition = IN.NDCPosition;
            float _DepthFade_e9f6efdeeea748d5b9489cb9356db947_Out_1_Float;
            SG_DepthFade_8bbfe621c0368244b80a10cdd14cd70e_float(_Property_f098ae14b87349b18021704e4796e375_Out_0_Float, _DepthFade_e9f6efdeeea748d5b9489cb9356db947, _DepthFade_e9f6efdeeea748d5b9489cb9356db947_Out_1_Float);
            float _Property_a7ccaf84ea904aef93f7567d05a08c53_Out_0_Float = _FoamCutoff;
            float _Multiply_8e97f0c830a94fe1b9f69046189ad20f_Out_2_Float;
            Unity_Multiply_float_float(_DepthFade_e9f6efdeeea748d5b9489cb9356db947_Out_1_Float, _Property_a7ccaf84ea904aef93f7567d05a08c53_Out_0_Float, _Multiply_8e97f0c830a94fe1b9f69046189ad20f_Out_2_Float);
            float _Property_8aa776c9bffc482a9b793dcf9b21ade8_Out_0_Float = _FoamScale;
            float _GradientNoise_f2a772e9e9de4969aef9721d103f92f8_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_c6acd5a2b68d4f079820e39856a12d58_Out_3_Vector2, _Property_8aa776c9bffc482a9b793dcf9b21ade8_Out_0_Float, _GradientNoise_f2a772e9e9de4969aef9721d103f92f8_Out_2_Float);
            float _Step_56ca35ee6ad74a8884e66e97609c8aa2_Out_2_Float;
            Unity_Step_float(_Multiply_8e97f0c830a94fe1b9f69046189ad20f_Out_2_Float, _GradientNoise_f2a772e9e9de4969aef9721d103f92f8_Out_2_Float, _Step_56ca35ee6ad74a8884e66e97609c8aa2_Out_2_Float);
            float4 _Lerp_de94925a336f44d3a6ce9a0e9dc95dd0_Out_3_Vector4;
            Unity_Lerp_float4(_Add_ecc8b0b6f3da4501b6a1866fd0669de6_Out_2_Vector4, _Property_487ab90812634ee7a3ee5e7286c31b37_Out_0_Vector4, (_Step_56ca35ee6ad74a8884e66e97609c8aa2_Out_2_Float.xxxx), _Lerp_de94925a336f44d3a6ce9a0e9dc95dd0_Out_3_Vector4);
            float4 _Property_77b93701aebc4074baeea8507b1154c7_Out_0_Vector4 = _RippleColor;
            float _Property_6d3446e5f668442b98fa00a4f2586995_Out_0_Float = _Frequency;
            float _Property_1dfb9c72b1914f8ba792ea320d9c44f9_Out_0_Float = _RippleDuration;
            float _Property_257bf14bacfe4c9f9c21df39ebc817be_Out_0_Float = _RippleSpeed;
            float _RippleFunctionCustomFunction_e7bd970bd8964ae5a69f01acec2bce3c_result_0_Float;
            RippleFunction_float(_Vector2_aacd28bdf4cf4521b9d76e9dbe00d1e0_Out_0_Vector2, IN.TimeParameters.x, _Property_6d3446e5f668442b98fa00a4f2586995_Out_0_Float, _Property_1dfb9c72b1914f8ba792ea320d9c44f9_Out_0_Float, _Property_257bf14bacfe4c9f9c21df39ebc817be_Out_0_Float, _RippleFunctionCustomFunction_e7bd970bd8964ae5a69f01acec2bce3c_result_0_Float);
            float4 _Lerp_b21bf96f73c1465eb973600089828e31_Out_3_Vector4;
            Unity_Lerp_float4(_Lerp_de94925a336f44d3a6ce9a0e9dc95dd0_Out_3_Vector4, _Property_77b93701aebc4074baeea8507b1154c7_Out_0_Vector4, (_RippleFunctionCustomFunction_e7bd970bd8964ae5a69f01acec2bce3c_result_0_Float.xxxx), _Lerp_b21bf96f73c1465eb973600089828e31_Out_3_Vector4);
            surface.BaseColor = (_Lerp_b21bf96f73c1465eb973600089828e31_Out_3_Vector4.xyz);
            surface.NormalTS = IN.TangentSpaceNormal;
            surface.Emission = float3(0, 0, 0);
            surface.Metallic = float(-1.21);
            surface.Smoothness = float(0.8);
            surface.Occlusion = float(1);
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.WorldSpacePosition =                         TransformObjectToWorld(input.positionOS);
            output.TimeParameters =                             _TimeParameters.xyz;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
            output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);
        
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        
            #if UNITY_UV_STARTS_AT_TOP
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #else
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #endif
        
            output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
            output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
            output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBRForwardPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "GBuffer"
            Tags
            {
                "LightMode" = "UniversalGBuffer"
            }
        
        // Render State
        Cull Back
        Blend One Zero
        ZTest LEqual
        ZWrite On
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 4.5
        #pragma exclude_renderers gles3 glcore
        #pragma multi_compile_instancing
        #pragma instancing_options renderinglayer
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma multi_compile_fragment _ _SCREEN_SPACE_IRRADIANCE
        #pragma multi_compile _ LIGHTMAP_ON
        #pragma multi_compile _ DYNAMICLIGHTMAP_ON
        #pragma multi_compile _ DIRLIGHTMAP_COMBINED
        #pragma multi_compile _ USE_LEGACY_LIGHTMAPS
        #pragma multi_compile _ LIGHTMAP_BICUBIC_SAMPLING
        #pragma multi_compile _ REFLECTION_PROBE_ROTATION
        #pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
        #pragma multi_compile_fragment _ _REFLECTION_PROBE_BLENDING
        #pragma multi_compile_fragment _ _REFLECTION_PROBE_BOX_PROJECTION
        #pragma multi_compile_fragment _ _SHADOWS_SOFT _SHADOWS_SOFT_LOW _SHADOWS_SOFT_MEDIUM _SHADOWS_SOFT_HIGH
        #pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
        #pragma multi_compile _ SHADOWS_SHADOWMASK
        #pragma multi_compile _ _MIXED_LIGHTING_SUBTRACTIVE
        #pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
        #pragma multi_compile_fragment _ _GBUFFER_NORMALS_OCT
        #pragma multi_compile_fragment _ _RENDER_PASS_ENABLED
        #pragma multi_compile_fragment _ DEBUG_DISPLAY
        #pragma multi_compile _ _CLUSTER_LIGHT_LOOP
        #pragma multi_compile _ LOD_FADE_CROSSFADE
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define ATTRIBUTES_NEED_TEXCOORD2
        #define GRAPH_VERTEX_USES_TIME_PARAMETERS_INPUT
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
        #define VARYINGS_NEED_SHADOW_COORD
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_GBUFFER
        #define _FOG_FRAGMENT 1
        #define _RECEIVE_SHADOWS_OFF 1
        #define USE_UNITY_CROSSFADE 1
        #define REQUIRE_DEPTH_TEXTURE
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Fog.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ProbeVolumeVariants.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/LODCrossFade.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv1 : TEXCOORD1;
             float4 uv2 : TEXCOORD2;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 tangentWS;
            #if defined(LIGHTMAP_ON)
             float2 staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
             float2 dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
             float3 sh;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
             float4 probeOcclusion;
            #endif
             float4 fogFactorAndVertexLight;
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
             float4 shadowCoord;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 TangentSpaceNormal;
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float2 NDCPosition;
             float2 PixelPosition;
             float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float3 WorldSpacePosition;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
            #if defined(LIGHTMAP_ON)
             float2 staticLightmapUV : INTERP0;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
             float2 dynamicLightmapUV : INTERP1;
            #endif
            #if !defined(LIGHTMAP_ON)
             float3 sh : INTERP2;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
             float4 probeOcclusion : INTERP3;
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
             float4 shadowCoord : INTERP4;
            #endif
             float4 tangentWS : INTERP5;
             float4 fogFactorAndVertexLight : INTERP6;
             float3 positionWS : INTERP7;
             float3 normalWS : INTERP8;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            #if defined(LIGHTMAP_ON)
            output.staticLightmapUV = input.staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            output.dynamicLightmapUV = input.dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.sh;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
            output.probeOcclusion = input.probeOcclusion;
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            output.shadowCoord = input.shadowCoord;
            #endif
            output.tangentWS.xyzw = input.tangentWS;
            output.fogFactorAndVertexLight.xyzw = input.fogFactorAndVertexLight;
            output.positionWS.xyz = input.positionWS;
            output.normalWS.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            #if defined(LIGHTMAP_ON)
            output.staticLightmapUV = input.staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            output.dynamicLightmapUV = input.dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.sh;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
            output.probeOcclusion = input.probeOcclusion;
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            output.shadowCoord = input.shadowCoord;
            #endif
            output.tangentWS = input.tangentWS.xyzw;
            output.fogFactorAndVertexLight = input.fogFactorAndVertexLight.xyzw;
            output.positionWS = input.positionWS.xyz;
            output.normalWS = input.normalWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _PatternSpeed;
        float _FlowSpeed;
        float2 _FlowDirection;
        float _WaveSpread;
        float _WaveHeight;
        float _WaveSpeed;
        float _Scale;
        float _PatternDensity;
        float4 _WaterColor;
        float4 _PatternColor;
        float _FoamScale;
        float _FoamAmount;
        float _FoamCutoff;
        float4 _FoamColor;
        float _PatternCutoff;
        float _Frequency;
        float4 _RippleColor;
        float _RippleDuration;
        float _RippleSpeed;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        
        // Graph Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
        #include_with_pragmas "Assets/Water/RippleFunction.hlsl"
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Divide_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A / B;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        float2 Unity_GradientNoise_Deterministic_Dir_float(float2 p)
        {
            float x; Hash_Tchou_2_1_float(p, x);
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_Deterministic_float (float2 UV, float3 Scale, out float Out)
        {
            float2 p = UV * Scale.xy;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_Distance_float3(float3 A, float3 B, out float Out)
        {
            Out = distance(A, B);
        }
        
        void Unity_InverseLerp_float(float A, float B, float T, out float Out)
        {
            Out = (T - A)/(B - A);
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        float2 Unity_Voronoi_RandomVector_Deterministic_float (float2 UV, float offset)
        {
            Hash_Tchou_2_2_float(UV, UV);
            return float2(sin(UV.y * offset), cos(UV.x * offset)) * 0.5 + 0.5;
        }
        
        void Unity_Voronoi_Deterministic_float(float2 UV, float AngleOffset, float CellDensity, out float Out, out float Cells)
        {
            float2 g = floor(UV * CellDensity);
            float2 f = frac(UV * CellDensity);
            float t = 8.0;
            float3 res = float3(8.0, 0.0, 0.0);
            for (int y = -1; y <= 1; y++)
            {
                for (int x = -1; x <= 1; x++)
                {
                    float2 lattice = float2(x, y);
                    float2 offset = Unity_Voronoi_RandomVector_Deterministic_float(lattice + g, AngleOffset);
                    float d = distance(lattice + offset, f);
                    if (d < res.x)
                    {
                        res = float3(d, offset.x, offset.y);
                        Out = res.x;
                        Cells = res.y;
                    }
                }
            }
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_Add_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A + B;
        }
        
        void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
        {
            if (unity_OrthoParams.w == 1.0)
            {
                Out = LinearEyeDepth(ComputeWorldSpacePosition(UV.xy, SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), UNITY_MATRIX_I_VP), UNITY_MATRIX_V);
            }
            else
            {
                Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
            }
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        struct Bindings_DepthFade_8bbfe621c0368244b80a10cdd14cd70e_float
        {
        float4 ScreenPosition;
        float2 NDCPosition;
        };
        
        void SG_DepthFade_8bbfe621c0368244b80a10cdd14cd70e_float(float _Distance, Bindings_DepthFade_8bbfe621c0368244b80a10cdd14cd70e_float IN, out float Out_1)
        {
        float _SceneDepth_2eb96c52a24a4558b37a5f543bc363b1_Out_1_Float;
        Unity_SceneDepth_Eye_float(float4(IN.NDCPosition.xy, 0, 0), _SceneDepth_2eb96c52a24a4558b37a5f543bc363b1_Out_1_Float);
        float4 _ScreenPosition_4c9380fe7a70484c8beb74b5792bdbc8_Out_0_Vector4 = IN.ScreenPosition;
        float _Split_9c58755aea204a38a422f36c78e4d894_R_1_Float = _ScreenPosition_4c9380fe7a70484c8beb74b5792bdbc8_Out_0_Vector4[0];
        float _Split_9c58755aea204a38a422f36c78e4d894_G_2_Float = _ScreenPosition_4c9380fe7a70484c8beb74b5792bdbc8_Out_0_Vector4[1];
        float _Split_9c58755aea204a38a422f36c78e4d894_B_3_Float = _ScreenPosition_4c9380fe7a70484c8beb74b5792bdbc8_Out_0_Vector4[2];
        float _Split_9c58755aea204a38a422f36c78e4d894_A_4_Float = _ScreenPosition_4c9380fe7a70484c8beb74b5792bdbc8_Out_0_Vector4[3];
        float _Subtract_4b0c684883d8435c9e6d251f76545c9a_Out_2_Float;
        Unity_Subtract_float(_SceneDepth_2eb96c52a24a4558b37a5f543bc363b1_Out_1_Float, _Split_9c58755aea204a38a422f36c78e4d894_A_4_Float, _Subtract_4b0c684883d8435c9e6d251f76545c9a_Out_2_Float);
        float _Property_71a843c8a2ad403b8140354c6a881afd_Out_0_Float = _Distance;
        float _Divide_6a045dbede5f44819286797f917918ac_Out_2_Float;
        Unity_Divide_float(_Subtract_4b0c684883d8435c9e6d251f76545c9a_Out_2_Float, _Property_71a843c8a2ad403b8140354c6a881afd_Out_0_Float, _Divide_6a045dbede5f44819286797f917918ac_Out_2_Float);
        float _Saturate_f45f6fa4775044429c760084824ef684_Out_1_Float;
        Unity_Saturate_float(_Divide_6a045dbede5f44819286797f917918ac_Out_2_Float, _Saturate_f45f6fa4775044429c760084824ef684_Out_1_Float);
        Out_1 = _Saturate_f45f6fa4775044429c760084824ef684_Out_1_Float;
        }
        
        void Unity_Step_float(float Edge, float In, out float Out)
        {
            Out = step(Edge, In);
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Property_d27cf8a7dad34ecd96496a2e168a017f_Out_0_Float = _WaveHeight;
            float _Split_a4a9df004cc4457ab200382a084abebd_R_1_Float = IN.WorldSpacePosition[0];
            float _Split_a4a9df004cc4457ab200382a084abebd_G_2_Float = IN.WorldSpacePosition[1];
            float _Split_a4a9df004cc4457ab200382a084abebd_B_3_Float = IN.WorldSpacePosition[2];
            float _Split_a4a9df004cc4457ab200382a084abebd_A_4_Float = 0;
            float2 _Vector2_2a9c14ca8f744a208e525959dee4a260_Out_0_Vector2 = float2(_Split_a4a9df004cc4457ab200382a084abebd_R_1_Float, _Split_a4a9df004cc4457ab200382a084abebd_B_3_Float);
            float _Property_19f075486b9748cda9e8985ad901e546_Out_0_Float = _Scale;
            float2 _Divide_18910aaaf2724bc18f244ce72424925b_Out_2_Vector2;
            Unity_Divide_float2(_Vector2_2a9c14ca8f744a208e525959dee4a260_Out_0_Vector2, (_Property_19f075486b9748cda9e8985ad901e546_Out_0_Float.xx), _Divide_18910aaaf2724bc18f244ce72424925b_Out_2_Vector2);
            float2 _Property_54fb6e94cfc349049bf82b6de2a35e4d_Out_0_Vector2 = _FlowDirection;
            float _Property_62bb68af8ede43f6a392167fdaca1c04_Out_0_Float = _WaveSpeed;
            float _Multiply_fa246fa412f543c18db54cbf79b06304_Out_2_Float;
            Unity_Multiply_float_float(_Property_62bb68af8ede43f6a392167fdaca1c04_Out_0_Float, IN.TimeParameters.x, _Multiply_fa246fa412f543c18db54cbf79b06304_Out_2_Float);
            float2 _Multiply_7e3f5e405dcb43cb9d5c7f6b2de9ddbd_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Property_54fb6e94cfc349049bf82b6de2a35e4d_Out_0_Vector2, (_Multiply_fa246fa412f543c18db54cbf79b06304_Out_2_Float.xx), _Multiply_7e3f5e405dcb43cb9d5c7f6b2de9ddbd_Out_2_Vector2);
            float2 _TilingAndOffset_07da4fb4f18642ef83ac45f44e00d13a_Out_3_Vector2;
            Unity_TilingAndOffset_float(_Divide_18910aaaf2724bc18f244ce72424925b_Out_2_Vector2, float2 (1, 1), _Multiply_7e3f5e405dcb43cb9d5c7f6b2de9ddbd_Out_2_Vector2, _TilingAndOffset_07da4fb4f18642ef83ac45f44e00d13a_Out_3_Vector2);
            float _Property_197bb7e4b1d5495a848b56f391c3ca94_Out_0_Float = _WaveSpread;
            float _GradientNoise_c4a6176d4d8e46c98e887e141f128ace_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_07da4fb4f18642ef83ac45f44e00d13a_Out_3_Vector2, _Property_197bb7e4b1d5495a848b56f391c3ca94_Out_0_Float, _GradientNoise_c4a6176d4d8e46c98e887e141f128ace_Out_2_Float);
            float _OneMinus_5666200d4b784081927194d399b19546_Out_1_Float;
            Unity_OneMinus_float(_GradientNoise_c4a6176d4d8e46c98e887e141f128ace_Out_2_Float, _OneMinus_5666200d4b784081927194d399b19546_Out_1_Float);
            float _Remap_df0e169dec134e1494011460992d4857_Out_3_Float;
            Unity_Remap_float(_OneMinus_5666200d4b784081927194d399b19546_Out_1_Float, float2 (0, 1), float2 (-1, 1), _Remap_df0e169dec134e1494011460992d4857_Out_3_Float);
            float _Multiply_21e2fe9741664562a375c951fee94e29_Out_2_Float;
            Unity_Multiply_float_float(_Property_d27cf8a7dad34ecd96496a2e168a017f_Out_0_Float, _Remap_df0e169dec134e1494011460992d4857_Out_3_Float, _Multiply_21e2fe9741664562a375c951fee94e29_Out_2_Float);
            float3 _Multiply_1bca5d8c2e8b4f69965496a79b732a5e_Out_2_Vector3;
            Unity_Multiply_float3_float3(IN.ObjectSpaceNormal, (_Multiply_21e2fe9741664562a375c951fee94e29_Out_2_Float.xxx), _Multiply_1bca5d8c2e8b4f69965496a79b732a5e_Out_2_Vector3);
            float3 _Add_8792ee7fc1774e53b8df716cea19ceeb_Out_2_Vector3;
            Unity_Add_float3(_Multiply_1bca5d8c2e8b4f69965496a79b732a5e_Out_2_Vector3, IN.ObjectSpacePosition, _Add_8792ee7fc1774e53b8df716cea19ceeb_Out_2_Vector3);
            description.Position = _Add_8792ee7fc1774e53b8df716cea19ceeb_Out_2_Vector3;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float3 NormalTS;
            float3 Emission;
            float Metallic;
            float Smoothness;
            float Occlusion;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _Property_671d70dd5da140ee96643d243dc37fd8_Out_0_Vector4 = _WaterColor;
            float _Property_dad906e3a15845749abaee1638b45450_Out_0_Float = _PatternCutoff;
            float _Distance_cc5c484eebf44373a1398dd7e1ff845c_Out_2_Float;
            Unity_Distance_float3(IN.WorldSpacePosition, _WorldSpaceCameraPos, _Distance_cc5c484eebf44373a1398dd7e1ff845c_Out_2_Float);
            float _InverseLerp_a4e53d21ad914646bd2fa3203824b74a_Out_3_Float;
            Unity_InverseLerp_float(_Property_dad906e3a15845749abaee1638b45450_Out_0_Float, float(0), _Distance_cc5c484eebf44373a1398dd7e1ff845c_Out_2_Float, _InverseLerp_a4e53d21ad914646bd2fa3203824b74a_Out_3_Float);
            float _Saturate_aec1f9a3c440421da2b762a373cb90af_Out_1_Float;
            Unity_Saturate_float(_InverseLerp_a4e53d21ad914646bd2fa3203824b74a_Out_3_Float, _Saturate_aec1f9a3c440421da2b762a373cb90af_Out_1_Float);
            float4 _Property_d1a487fb48c74645a6287a2efe9e84ec_Out_0_Vector4 = IsGammaSpace() ? LinearToSRGB(_PatternColor) : _PatternColor;
            float _Split_6514885e4bf748d7a415566148d27785_R_1_Float = IN.WorldSpacePosition[0];
            float _Split_6514885e4bf748d7a415566148d27785_G_2_Float = IN.WorldSpacePosition[1];
            float _Split_6514885e4bf748d7a415566148d27785_B_3_Float = IN.WorldSpacePosition[2];
            float _Split_6514885e4bf748d7a415566148d27785_A_4_Float = 0;
            float2 _Vector2_aacd28bdf4cf4521b9d76e9dbe00d1e0_Out_0_Vector2 = float2(_Split_6514885e4bf748d7a415566148d27785_R_1_Float, _Split_6514885e4bf748d7a415566148d27785_B_3_Float);
            float _Property_35d111bad030402bbf4b94caac81b7f5_Out_0_Float = _Scale;
            float2 _Divide_72c033936cee42ee80147ea81c9d2ecf_Out_2_Vector2;
            Unity_Divide_float2(_Vector2_aacd28bdf4cf4521b9d76e9dbe00d1e0_Out_0_Vector2, (_Property_35d111bad030402bbf4b94caac81b7f5_Out_0_Float.xx), _Divide_72c033936cee42ee80147ea81c9d2ecf_Out_2_Vector2);
            float2 _Property_3ee92cea9de142c296a1467413ffd108_Out_0_Vector2 = _FlowDirection;
            float _Property_47d6f34367a74d388cde1a2ecaf6ccda_Out_0_Float = _FlowSpeed;
            float _Multiply_979a08f5be6e43a7ac018afb58904b04_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_47d6f34367a74d388cde1a2ecaf6ccda_Out_0_Float, _Multiply_979a08f5be6e43a7ac018afb58904b04_Out_2_Float);
            float2 _Multiply_c26278cacbce4cb1a639bf0229ed4f3b_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Property_3ee92cea9de142c296a1467413ffd108_Out_0_Vector2, (_Multiply_979a08f5be6e43a7ac018afb58904b04_Out_2_Float.xx), _Multiply_c26278cacbce4cb1a639bf0229ed4f3b_Out_2_Vector2);
            float2 _TilingAndOffset_c6acd5a2b68d4f079820e39856a12d58_Out_3_Vector2;
            Unity_TilingAndOffset_float(_Divide_72c033936cee42ee80147ea81c9d2ecf_Out_2_Vector2, float2 (1, 1), _Multiply_c26278cacbce4cb1a639bf0229ed4f3b_Out_2_Vector2, _TilingAndOffset_c6acd5a2b68d4f079820e39856a12d58_Out_3_Vector2);
            float _Property_17027e778cf54529aae8b565ff3e1f98_Out_0_Float = _PatternSpeed;
            float _Multiply_b502ebc2c57440149af34fae45d33914_Out_2_Float;
            Unity_Multiply_float_float(_Property_17027e778cf54529aae8b565ff3e1f98_Out_0_Float, IN.TimeParameters.x, _Multiply_b502ebc2c57440149af34fae45d33914_Out_2_Float);
            float _Property_3f313ed937e5421a92aa2eed66441c05_Out_0_Float = _PatternDensity;
            float _Voronoi_49347d90d7f84f2688bd11c85c622d4a_Out_3_Float;
            float _Voronoi_49347d90d7f84f2688bd11c85c622d4a_Cells_4_Float;
            Unity_Voronoi_Deterministic_float(_TilingAndOffset_c6acd5a2b68d4f079820e39856a12d58_Out_3_Vector2, _Multiply_b502ebc2c57440149af34fae45d33914_Out_2_Float, _Property_3f313ed937e5421a92aa2eed66441c05_Out_0_Float, _Voronoi_49347d90d7f84f2688bd11c85c622d4a_Out_3_Float, _Voronoi_49347d90d7f84f2688bd11c85c622d4a_Cells_4_Float);
            float _Power_5fa13e83b0bd4a30948e58d874ec8e1c_Out_2_Float;
            Unity_Power_float(_Voronoi_49347d90d7f84f2688bd11c85c622d4a_Out_3_Float, float(5), _Power_5fa13e83b0bd4a30948e58d874ec8e1c_Out_2_Float);
            float4 _Multiply_71f563a2f0994124a41103b119f6ef23_Out_2_Vector4;
            Unity_Multiply_float4_float4(_Property_d1a487fb48c74645a6287a2efe9e84ec_Out_0_Vector4, (_Power_5fa13e83b0bd4a30948e58d874ec8e1c_Out_2_Float.xxxx), _Multiply_71f563a2f0994124a41103b119f6ef23_Out_2_Vector4);
            float4 _Multiply_6366b6f890e24726a301b5317d8cca7f_Out_2_Vector4;
            Unity_Multiply_float4_float4((_Saturate_aec1f9a3c440421da2b762a373cb90af_Out_1_Float.xxxx), _Multiply_71f563a2f0994124a41103b119f6ef23_Out_2_Vector4, _Multiply_6366b6f890e24726a301b5317d8cca7f_Out_2_Vector4);
            float4 _Add_ecc8b0b6f3da4501b6a1866fd0669de6_Out_2_Vector4;
            Unity_Add_float4(_Property_671d70dd5da140ee96643d243dc37fd8_Out_0_Vector4, _Multiply_6366b6f890e24726a301b5317d8cca7f_Out_2_Vector4, _Add_ecc8b0b6f3da4501b6a1866fd0669de6_Out_2_Vector4);
            float4 _Property_487ab90812634ee7a3ee5e7286c31b37_Out_0_Vector4 = _FoamColor;
            float _Property_f098ae14b87349b18021704e4796e375_Out_0_Float = _FoamAmount;
            Bindings_DepthFade_8bbfe621c0368244b80a10cdd14cd70e_float _DepthFade_e9f6efdeeea748d5b9489cb9356db947;
            _DepthFade_e9f6efdeeea748d5b9489cb9356db947.ScreenPosition = IN.ScreenPosition;
            _DepthFade_e9f6efdeeea748d5b9489cb9356db947.NDCPosition = IN.NDCPosition;
            float _DepthFade_e9f6efdeeea748d5b9489cb9356db947_Out_1_Float;
            SG_DepthFade_8bbfe621c0368244b80a10cdd14cd70e_float(_Property_f098ae14b87349b18021704e4796e375_Out_0_Float, _DepthFade_e9f6efdeeea748d5b9489cb9356db947, _DepthFade_e9f6efdeeea748d5b9489cb9356db947_Out_1_Float);
            float _Property_a7ccaf84ea904aef93f7567d05a08c53_Out_0_Float = _FoamCutoff;
            float _Multiply_8e97f0c830a94fe1b9f69046189ad20f_Out_2_Float;
            Unity_Multiply_float_float(_DepthFade_e9f6efdeeea748d5b9489cb9356db947_Out_1_Float, _Property_a7ccaf84ea904aef93f7567d05a08c53_Out_0_Float, _Multiply_8e97f0c830a94fe1b9f69046189ad20f_Out_2_Float);
            float _Property_8aa776c9bffc482a9b793dcf9b21ade8_Out_0_Float = _FoamScale;
            float _GradientNoise_f2a772e9e9de4969aef9721d103f92f8_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_c6acd5a2b68d4f079820e39856a12d58_Out_3_Vector2, _Property_8aa776c9bffc482a9b793dcf9b21ade8_Out_0_Float, _GradientNoise_f2a772e9e9de4969aef9721d103f92f8_Out_2_Float);
            float _Step_56ca35ee6ad74a8884e66e97609c8aa2_Out_2_Float;
            Unity_Step_float(_Multiply_8e97f0c830a94fe1b9f69046189ad20f_Out_2_Float, _GradientNoise_f2a772e9e9de4969aef9721d103f92f8_Out_2_Float, _Step_56ca35ee6ad74a8884e66e97609c8aa2_Out_2_Float);
            float4 _Lerp_de94925a336f44d3a6ce9a0e9dc95dd0_Out_3_Vector4;
            Unity_Lerp_float4(_Add_ecc8b0b6f3da4501b6a1866fd0669de6_Out_2_Vector4, _Property_487ab90812634ee7a3ee5e7286c31b37_Out_0_Vector4, (_Step_56ca35ee6ad74a8884e66e97609c8aa2_Out_2_Float.xxxx), _Lerp_de94925a336f44d3a6ce9a0e9dc95dd0_Out_3_Vector4);
            float4 _Property_77b93701aebc4074baeea8507b1154c7_Out_0_Vector4 = _RippleColor;
            float _Property_6d3446e5f668442b98fa00a4f2586995_Out_0_Float = _Frequency;
            float _Property_1dfb9c72b1914f8ba792ea320d9c44f9_Out_0_Float = _RippleDuration;
            float _Property_257bf14bacfe4c9f9c21df39ebc817be_Out_0_Float = _RippleSpeed;
            float _RippleFunctionCustomFunction_e7bd970bd8964ae5a69f01acec2bce3c_result_0_Float;
            RippleFunction_float(_Vector2_aacd28bdf4cf4521b9d76e9dbe00d1e0_Out_0_Vector2, IN.TimeParameters.x, _Property_6d3446e5f668442b98fa00a4f2586995_Out_0_Float, _Property_1dfb9c72b1914f8ba792ea320d9c44f9_Out_0_Float, _Property_257bf14bacfe4c9f9c21df39ebc817be_Out_0_Float, _RippleFunctionCustomFunction_e7bd970bd8964ae5a69f01acec2bce3c_result_0_Float);
            float4 _Lerp_b21bf96f73c1465eb973600089828e31_Out_3_Vector4;
            Unity_Lerp_float4(_Lerp_de94925a336f44d3a6ce9a0e9dc95dd0_Out_3_Vector4, _Property_77b93701aebc4074baeea8507b1154c7_Out_0_Vector4, (_RippleFunctionCustomFunction_e7bd970bd8964ae5a69f01acec2bce3c_result_0_Float.xxxx), _Lerp_b21bf96f73c1465eb973600089828e31_Out_3_Vector4);
            surface.BaseColor = (_Lerp_b21bf96f73c1465eb973600089828e31_Out_3_Vector4.xyz);
            surface.NormalTS = IN.TangentSpaceNormal;
            surface.Emission = float3(0, 0, 0);
            surface.Metallic = float(-1.21);
            surface.Smoothness = float(0.8);
            surface.Occlusion = float(1);
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.WorldSpacePosition =                         TransformObjectToWorld(input.positionOS);
            output.TimeParameters =                             _TimeParameters.xyz;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
            output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);
        
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        
            #if UNITY_UV_STARTS_AT_TOP
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #else
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #endif
        
            output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
            output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
            output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/GBufferOutput.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBRGBufferPass.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/GBufferOutputFormat.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "ShadowCaster"
            Tags
            {
                "LightMode" = "ShadowCaster"
            }
        
        // Render State
        Cull Back
        ZTest LEqual
        ZWrite On
        ColorMask 0
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma multi_compile_vertex _ _CASTING_PUNCTUAL_LIGHT_SHADOW
        #pragma multi_compile _ LOD_FADE_CROSSFADE
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define GRAPH_VERTEX_USES_TIME_PARAMETERS_INPUT
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_NORMAL_WS
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_SHADOWCASTER
        #define USE_UNITY_CROSSFADE 1
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/LODCrossFade.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float3 WorldSpacePosition;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 normalWS : INTERP0;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.normalWS.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.normalWS = input.normalWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _PatternSpeed;
        float _FlowSpeed;
        float2 _FlowDirection;
        float _WaveSpread;
        float _WaveHeight;
        float _WaveSpeed;
        float _Scale;
        float _PatternDensity;
        float4 _WaterColor;
        float4 _PatternColor;
        float _FoamScale;
        float _FoamAmount;
        float _FoamCutoff;
        float4 _FoamColor;
        float _PatternCutoff;
        float _Frequency;
        float4 _RippleColor;
        float _RippleDuration;
        float _RippleSpeed;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        
        // Graph Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Divide_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A / B;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        float2 Unity_GradientNoise_Deterministic_Dir_float(float2 p)
        {
            float x; Hash_Tchou_2_1_float(p, x);
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_Deterministic_float (float2 UV, float3 Scale, out float Out)
        {
            float2 p = UV * Scale.xy;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Property_d27cf8a7dad34ecd96496a2e168a017f_Out_0_Float = _WaveHeight;
            float _Split_a4a9df004cc4457ab200382a084abebd_R_1_Float = IN.WorldSpacePosition[0];
            float _Split_a4a9df004cc4457ab200382a084abebd_G_2_Float = IN.WorldSpacePosition[1];
            float _Split_a4a9df004cc4457ab200382a084abebd_B_3_Float = IN.WorldSpacePosition[2];
            float _Split_a4a9df004cc4457ab200382a084abebd_A_4_Float = 0;
            float2 _Vector2_2a9c14ca8f744a208e525959dee4a260_Out_0_Vector2 = float2(_Split_a4a9df004cc4457ab200382a084abebd_R_1_Float, _Split_a4a9df004cc4457ab200382a084abebd_B_3_Float);
            float _Property_19f075486b9748cda9e8985ad901e546_Out_0_Float = _Scale;
            float2 _Divide_18910aaaf2724bc18f244ce72424925b_Out_2_Vector2;
            Unity_Divide_float2(_Vector2_2a9c14ca8f744a208e525959dee4a260_Out_0_Vector2, (_Property_19f075486b9748cda9e8985ad901e546_Out_0_Float.xx), _Divide_18910aaaf2724bc18f244ce72424925b_Out_2_Vector2);
            float2 _Property_54fb6e94cfc349049bf82b6de2a35e4d_Out_0_Vector2 = _FlowDirection;
            float _Property_62bb68af8ede43f6a392167fdaca1c04_Out_0_Float = _WaveSpeed;
            float _Multiply_fa246fa412f543c18db54cbf79b06304_Out_2_Float;
            Unity_Multiply_float_float(_Property_62bb68af8ede43f6a392167fdaca1c04_Out_0_Float, IN.TimeParameters.x, _Multiply_fa246fa412f543c18db54cbf79b06304_Out_2_Float);
            float2 _Multiply_7e3f5e405dcb43cb9d5c7f6b2de9ddbd_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Property_54fb6e94cfc349049bf82b6de2a35e4d_Out_0_Vector2, (_Multiply_fa246fa412f543c18db54cbf79b06304_Out_2_Float.xx), _Multiply_7e3f5e405dcb43cb9d5c7f6b2de9ddbd_Out_2_Vector2);
            float2 _TilingAndOffset_07da4fb4f18642ef83ac45f44e00d13a_Out_3_Vector2;
            Unity_TilingAndOffset_float(_Divide_18910aaaf2724bc18f244ce72424925b_Out_2_Vector2, float2 (1, 1), _Multiply_7e3f5e405dcb43cb9d5c7f6b2de9ddbd_Out_2_Vector2, _TilingAndOffset_07da4fb4f18642ef83ac45f44e00d13a_Out_3_Vector2);
            float _Property_197bb7e4b1d5495a848b56f391c3ca94_Out_0_Float = _WaveSpread;
            float _GradientNoise_c4a6176d4d8e46c98e887e141f128ace_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_07da4fb4f18642ef83ac45f44e00d13a_Out_3_Vector2, _Property_197bb7e4b1d5495a848b56f391c3ca94_Out_0_Float, _GradientNoise_c4a6176d4d8e46c98e887e141f128ace_Out_2_Float);
            float _OneMinus_5666200d4b784081927194d399b19546_Out_1_Float;
            Unity_OneMinus_float(_GradientNoise_c4a6176d4d8e46c98e887e141f128ace_Out_2_Float, _OneMinus_5666200d4b784081927194d399b19546_Out_1_Float);
            float _Remap_df0e169dec134e1494011460992d4857_Out_3_Float;
            Unity_Remap_float(_OneMinus_5666200d4b784081927194d399b19546_Out_1_Float, float2 (0, 1), float2 (-1, 1), _Remap_df0e169dec134e1494011460992d4857_Out_3_Float);
            float _Multiply_21e2fe9741664562a375c951fee94e29_Out_2_Float;
            Unity_Multiply_float_float(_Property_d27cf8a7dad34ecd96496a2e168a017f_Out_0_Float, _Remap_df0e169dec134e1494011460992d4857_Out_3_Float, _Multiply_21e2fe9741664562a375c951fee94e29_Out_2_Float);
            float3 _Multiply_1bca5d8c2e8b4f69965496a79b732a5e_Out_2_Vector3;
            Unity_Multiply_float3_float3(IN.ObjectSpaceNormal, (_Multiply_21e2fe9741664562a375c951fee94e29_Out_2_Float.xxx), _Multiply_1bca5d8c2e8b4f69965496a79b732a5e_Out_2_Vector3);
            float3 _Add_8792ee7fc1774e53b8df716cea19ceeb_Out_2_Vector3;
            Unity_Add_float3(_Multiply_1bca5d8c2e8b4f69965496a79b732a5e_Out_2_Vector3, IN.ObjectSpacePosition, _Add_8792ee7fc1774e53b8df716cea19ceeb_Out_2_Vector3);
            description.Position = _Add_8792ee7fc1774e53b8df716cea19ceeb_Out_2_Vector3;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.WorldSpacePosition =                         TransformObjectToWorld(input.positionOS);
            output.TimeParameters =                             _TimeParameters.xyz;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShadowCasterPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "MotionVectors"
            Tags
            {
                "LightMode" = "MotionVectors"
            }
        
        // Render State
        Cull Back
        ZTest LEqual
        ZWrite On
        ColorMask RG
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 3.5
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma multi_compile _ LOD_FADE_CROSSFADE
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define GRAPH_VERTEX_USES_TIME_PARAMETERS_INPUT
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_MOTION_VECTORS
        #define USE_UNITY_CROSSFADE 1
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/LODCrossFade.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpacePosition;
             float3 WorldSpacePosition;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _PatternSpeed;
        float _FlowSpeed;
        float2 _FlowDirection;
        float _WaveSpread;
        float _WaveHeight;
        float _WaveSpeed;
        float _Scale;
        float _PatternDensity;
        float4 _WaterColor;
        float4 _PatternColor;
        float _FoamScale;
        float _FoamAmount;
        float _FoamCutoff;
        float4 _FoamColor;
        float _PatternCutoff;
        float _Frequency;
        float4 _RippleColor;
        float _RippleDuration;
        float _RippleSpeed;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        
        // Graph Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Divide_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A / B;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        float2 Unity_GradientNoise_Deterministic_Dir_float(float2 p)
        {
            float x; Hash_Tchou_2_1_float(p, x);
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_Deterministic_float (float2 UV, float3 Scale, out float Out)
        {
            float2 p = UV * Scale.xy;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Property_d27cf8a7dad34ecd96496a2e168a017f_Out_0_Float = _WaveHeight;
            float _Split_a4a9df004cc4457ab200382a084abebd_R_1_Float = IN.WorldSpacePosition[0];
            float _Split_a4a9df004cc4457ab200382a084abebd_G_2_Float = IN.WorldSpacePosition[1];
            float _Split_a4a9df004cc4457ab200382a084abebd_B_3_Float = IN.WorldSpacePosition[2];
            float _Split_a4a9df004cc4457ab200382a084abebd_A_4_Float = 0;
            float2 _Vector2_2a9c14ca8f744a208e525959dee4a260_Out_0_Vector2 = float2(_Split_a4a9df004cc4457ab200382a084abebd_R_1_Float, _Split_a4a9df004cc4457ab200382a084abebd_B_3_Float);
            float _Property_19f075486b9748cda9e8985ad901e546_Out_0_Float = _Scale;
            float2 _Divide_18910aaaf2724bc18f244ce72424925b_Out_2_Vector2;
            Unity_Divide_float2(_Vector2_2a9c14ca8f744a208e525959dee4a260_Out_0_Vector2, (_Property_19f075486b9748cda9e8985ad901e546_Out_0_Float.xx), _Divide_18910aaaf2724bc18f244ce72424925b_Out_2_Vector2);
            float2 _Property_54fb6e94cfc349049bf82b6de2a35e4d_Out_0_Vector2 = _FlowDirection;
            float _Property_62bb68af8ede43f6a392167fdaca1c04_Out_0_Float = _WaveSpeed;
            float _Multiply_fa246fa412f543c18db54cbf79b06304_Out_2_Float;
            Unity_Multiply_float_float(_Property_62bb68af8ede43f6a392167fdaca1c04_Out_0_Float, IN.TimeParameters.x, _Multiply_fa246fa412f543c18db54cbf79b06304_Out_2_Float);
            float2 _Multiply_7e3f5e405dcb43cb9d5c7f6b2de9ddbd_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Property_54fb6e94cfc349049bf82b6de2a35e4d_Out_0_Vector2, (_Multiply_fa246fa412f543c18db54cbf79b06304_Out_2_Float.xx), _Multiply_7e3f5e405dcb43cb9d5c7f6b2de9ddbd_Out_2_Vector2);
            float2 _TilingAndOffset_07da4fb4f18642ef83ac45f44e00d13a_Out_3_Vector2;
            Unity_TilingAndOffset_float(_Divide_18910aaaf2724bc18f244ce72424925b_Out_2_Vector2, float2 (1, 1), _Multiply_7e3f5e405dcb43cb9d5c7f6b2de9ddbd_Out_2_Vector2, _TilingAndOffset_07da4fb4f18642ef83ac45f44e00d13a_Out_3_Vector2);
            float _Property_197bb7e4b1d5495a848b56f391c3ca94_Out_0_Float = _WaveSpread;
            float _GradientNoise_c4a6176d4d8e46c98e887e141f128ace_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_07da4fb4f18642ef83ac45f44e00d13a_Out_3_Vector2, _Property_197bb7e4b1d5495a848b56f391c3ca94_Out_0_Float, _GradientNoise_c4a6176d4d8e46c98e887e141f128ace_Out_2_Float);
            float _OneMinus_5666200d4b784081927194d399b19546_Out_1_Float;
            Unity_OneMinus_float(_GradientNoise_c4a6176d4d8e46c98e887e141f128ace_Out_2_Float, _OneMinus_5666200d4b784081927194d399b19546_Out_1_Float);
            float _Remap_df0e169dec134e1494011460992d4857_Out_3_Float;
            Unity_Remap_float(_OneMinus_5666200d4b784081927194d399b19546_Out_1_Float, float2 (0, 1), float2 (-1, 1), _Remap_df0e169dec134e1494011460992d4857_Out_3_Float);
            float _Multiply_21e2fe9741664562a375c951fee94e29_Out_2_Float;
            Unity_Multiply_float_float(_Property_d27cf8a7dad34ecd96496a2e168a017f_Out_0_Float, _Remap_df0e169dec134e1494011460992d4857_Out_3_Float, _Multiply_21e2fe9741664562a375c951fee94e29_Out_2_Float);
            float3 _Multiply_1bca5d8c2e8b4f69965496a79b732a5e_Out_2_Vector3;
            Unity_Multiply_float3_float3(IN.ObjectSpaceNormal, (_Multiply_21e2fe9741664562a375c951fee94e29_Out_2_Float.xxx), _Multiply_1bca5d8c2e8b4f69965496a79b732a5e_Out_2_Vector3);
            float3 _Add_8792ee7fc1774e53b8df716cea19ceeb_Out_2_Vector3;
            Unity_Add_float3(_Multiply_1bca5d8c2e8b4f69965496a79b732a5e_Out_2_Vector3, IN.ObjectSpacePosition, _Add_8792ee7fc1774e53b8df716cea19ceeb_Out_2_Vector3);
            description.Position = _Add_8792ee7fc1774e53b8df716cea19ceeb_Out_2_Vector3;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpacePosition =                        input.positionOS;
            output.WorldSpacePosition =                         TransformObjectToWorld(input.positionOS);
            output.TimeParameters =                             _TimeParameters.xyz;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/MotionVectorPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "DepthOnly"
            Tags
            {
                "LightMode" = "DepthOnly"
            }
        
        // Render State
        Cull Back
        ZTest LEqual
        ZWrite On
        ColorMask R
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma multi_compile _ LOD_FADE_CROSSFADE
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define GRAPH_VERTEX_USES_TIME_PARAMETERS_INPUT
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHONLY
        #define USE_UNITY_CROSSFADE 1
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/LODCrossFade.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float3 WorldSpacePosition;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _PatternSpeed;
        float _FlowSpeed;
        float2 _FlowDirection;
        float _WaveSpread;
        float _WaveHeight;
        float _WaveSpeed;
        float _Scale;
        float _PatternDensity;
        float4 _WaterColor;
        float4 _PatternColor;
        float _FoamScale;
        float _FoamAmount;
        float _FoamCutoff;
        float4 _FoamColor;
        float _PatternCutoff;
        float _Frequency;
        float4 _RippleColor;
        float _RippleDuration;
        float _RippleSpeed;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        
        // Graph Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Divide_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A / B;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        float2 Unity_GradientNoise_Deterministic_Dir_float(float2 p)
        {
            float x; Hash_Tchou_2_1_float(p, x);
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_Deterministic_float (float2 UV, float3 Scale, out float Out)
        {
            float2 p = UV * Scale.xy;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Property_d27cf8a7dad34ecd96496a2e168a017f_Out_0_Float = _WaveHeight;
            float _Split_a4a9df004cc4457ab200382a084abebd_R_1_Float = IN.WorldSpacePosition[0];
            float _Split_a4a9df004cc4457ab200382a084abebd_G_2_Float = IN.WorldSpacePosition[1];
            float _Split_a4a9df004cc4457ab200382a084abebd_B_3_Float = IN.WorldSpacePosition[2];
            float _Split_a4a9df004cc4457ab200382a084abebd_A_4_Float = 0;
            float2 _Vector2_2a9c14ca8f744a208e525959dee4a260_Out_0_Vector2 = float2(_Split_a4a9df004cc4457ab200382a084abebd_R_1_Float, _Split_a4a9df004cc4457ab200382a084abebd_B_3_Float);
            float _Property_19f075486b9748cda9e8985ad901e546_Out_0_Float = _Scale;
            float2 _Divide_18910aaaf2724bc18f244ce72424925b_Out_2_Vector2;
            Unity_Divide_float2(_Vector2_2a9c14ca8f744a208e525959dee4a260_Out_0_Vector2, (_Property_19f075486b9748cda9e8985ad901e546_Out_0_Float.xx), _Divide_18910aaaf2724bc18f244ce72424925b_Out_2_Vector2);
            float2 _Property_54fb6e94cfc349049bf82b6de2a35e4d_Out_0_Vector2 = _FlowDirection;
            float _Property_62bb68af8ede43f6a392167fdaca1c04_Out_0_Float = _WaveSpeed;
            float _Multiply_fa246fa412f543c18db54cbf79b06304_Out_2_Float;
            Unity_Multiply_float_float(_Property_62bb68af8ede43f6a392167fdaca1c04_Out_0_Float, IN.TimeParameters.x, _Multiply_fa246fa412f543c18db54cbf79b06304_Out_2_Float);
            float2 _Multiply_7e3f5e405dcb43cb9d5c7f6b2de9ddbd_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Property_54fb6e94cfc349049bf82b6de2a35e4d_Out_0_Vector2, (_Multiply_fa246fa412f543c18db54cbf79b06304_Out_2_Float.xx), _Multiply_7e3f5e405dcb43cb9d5c7f6b2de9ddbd_Out_2_Vector2);
            float2 _TilingAndOffset_07da4fb4f18642ef83ac45f44e00d13a_Out_3_Vector2;
            Unity_TilingAndOffset_float(_Divide_18910aaaf2724bc18f244ce72424925b_Out_2_Vector2, float2 (1, 1), _Multiply_7e3f5e405dcb43cb9d5c7f6b2de9ddbd_Out_2_Vector2, _TilingAndOffset_07da4fb4f18642ef83ac45f44e00d13a_Out_3_Vector2);
            float _Property_197bb7e4b1d5495a848b56f391c3ca94_Out_0_Float = _WaveSpread;
            float _GradientNoise_c4a6176d4d8e46c98e887e141f128ace_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_07da4fb4f18642ef83ac45f44e00d13a_Out_3_Vector2, _Property_197bb7e4b1d5495a848b56f391c3ca94_Out_0_Float, _GradientNoise_c4a6176d4d8e46c98e887e141f128ace_Out_2_Float);
            float _OneMinus_5666200d4b784081927194d399b19546_Out_1_Float;
            Unity_OneMinus_float(_GradientNoise_c4a6176d4d8e46c98e887e141f128ace_Out_2_Float, _OneMinus_5666200d4b784081927194d399b19546_Out_1_Float);
            float _Remap_df0e169dec134e1494011460992d4857_Out_3_Float;
            Unity_Remap_float(_OneMinus_5666200d4b784081927194d399b19546_Out_1_Float, float2 (0, 1), float2 (-1, 1), _Remap_df0e169dec134e1494011460992d4857_Out_3_Float);
            float _Multiply_21e2fe9741664562a375c951fee94e29_Out_2_Float;
            Unity_Multiply_float_float(_Property_d27cf8a7dad34ecd96496a2e168a017f_Out_0_Float, _Remap_df0e169dec134e1494011460992d4857_Out_3_Float, _Multiply_21e2fe9741664562a375c951fee94e29_Out_2_Float);
            float3 _Multiply_1bca5d8c2e8b4f69965496a79b732a5e_Out_2_Vector3;
            Unity_Multiply_float3_float3(IN.ObjectSpaceNormal, (_Multiply_21e2fe9741664562a375c951fee94e29_Out_2_Float.xxx), _Multiply_1bca5d8c2e8b4f69965496a79b732a5e_Out_2_Vector3);
            float3 _Add_8792ee7fc1774e53b8df716cea19ceeb_Out_2_Vector3;
            Unity_Add_float3(_Multiply_1bca5d8c2e8b4f69965496a79b732a5e_Out_2_Vector3, IN.ObjectSpacePosition, _Add_8792ee7fc1774e53b8df716cea19ceeb_Out_2_Vector3);
            description.Position = _Add_8792ee7fc1774e53b8df716cea19ceeb_Out_2_Vector3;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.WorldSpacePosition =                         TransformObjectToWorld(input.positionOS);
            output.TimeParameters =                             _TimeParameters.xyz;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthOnlyPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "DepthNormals"
            Tags
            {
                "LightMode" = "DepthNormals"
            }
        
        // Render State
        Cull Back
        ZTest LEqual
        ZWrite On
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma multi_compile _ LOD_FADE_CROSSFADE
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define GRAPH_VERTEX_USES_TIME_PARAMETERS_INPUT
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHNORMALS
        #define USE_UNITY_CROSSFADE 1
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/LODCrossFade.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv1 : TEXCOORD1;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 normalWS;
             float4 tangentWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 TangentSpaceNormal;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float3 WorldSpacePosition;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 tangentWS : INTERP0;
             float3 normalWS : INTERP1;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.tangentWS.xyzw = input.tangentWS;
            output.normalWS.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.tangentWS = input.tangentWS.xyzw;
            output.normalWS = input.normalWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _PatternSpeed;
        float _FlowSpeed;
        float2 _FlowDirection;
        float _WaveSpread;
        float _WaveHeight;
        float _WaveSpeed;
        float _Scale;
        float _PatternDensity;
        float4 _WaterColor;
        float4 _PatternColor;
        float _FoamScale;
        float _FoamAmount;
        float _FoamCutoff;
        float4 _FoamColor;
        float _PatternCutoff;
        float _Frequency;
        float4 _RippleColor;
        float _RippleDuration;
        float _RippleSpeed;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        
        // Graph Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Divide_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A / B;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        float2 Unity_GradientNoise_Deterministic_Dir_float(float2 p)
        {
            float x; Hash_Tchou_2_1_float(p, x);
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_Deterministic_float (float2 UV, float3 Scale, out float Out)
        {
            float2 p = UV * Scale.xy;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Property_d27cf8a7dad34ecd96496a2e168a017f_Out_0_Float = _WaveHeight;
            float _Split_a4a9df004cc4457ab200382a084abebd_R_1_Float = IN.WorldSpacePosition[0];
            float _Split_a4a9df004cc4457ab200382a084abebd_G_2_Float = IN.WorldSpacePosition[1];
            float _Split_a4a9df004cc4457ab200382a084abebd_B_3_Float = IN.WorldSpacePosition[2];
            float _Split_a4a9df004cc4457ab200382a084abebd_A_4_Float = 0;
            float2 _Vector2_2a9c14ca8f744a208e525959dee4a260_Out_0_Vector2 = float2(_Split_a4a9df004cc4457ab200382a084abebd_R_1_Float, _Split_a4a9df004cc4457ab200382a084abebd_B_3_Float);
            float _Property_19f075486b9748cda9e8985ad901e546_Out_0_Float = _Scale;
            float2 _Divide_18910aaaf2724bc18f244ce72424925b_Out_2_Vector2;
            Unity_Divide_float2(_Vector2_2a9c14ca8f744a208e525959dee4a260_Out_0_Vector2, (_Property_19f075486b9748cda9e8985ad901e546_Out_0_Float.xx), _Divide_18910aaaf2724bc18f244ce72424925b_Out_2_Vector2);
            float2 _Property_54fb6e94cfc349049bf82b6de2a35e4d_Out_0_Vector2 = _FlowDirection;
            float _Property_62bb68af8ede43f6a392167fdaca1c04_Out_0_Float = _WaveSpeed;
            float _Multiply_fa246fa412f543c18db54cbf79b06304_Out_2_Float;
            Unity_Multiply_float_float(_Property_62bb68af8ede43f6a392167fdaca1c04_Out_0_Float, IN.TimeParameters.x, _Multiply_fa246fa412f543c18db54cbf79b06304_Out_2_Float);
            float2 _Multiply_7e3f5e405dcb43cb9d5c7f6b2de9ddbd_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Property_54fb6e94cfc349049bf82b6de2a35e4d_Out_0_Vector2, (_Multiply_fa246fa412f543c18db54cbf79b06304_Out_2_Float.xx), _Multiply_7e3f5e405dcb43cb9d5c7f6b2de9ddbd_Out_2_Vector2);
            float2 _TilingAndOffset_07da4fb4f18642ef83ac45f44e00d13a_Out_3_Vector2;
            Unity_TilingAndOffset_float(_Divide_18910aaaf2724bc18f244ce72424925b_Out_2_Vector2, float2 (1, 1), _Multiply_7e3f5e405dcb43cb9d5c7f6b2de9ddbd_Out_2_Vector2, _TilingAndOffset_07da4fb4f18642ef83ac45f44e00d13a_Out_3_Vector2);
            float _Property_197bb7e4b1d5495a848b56f391c3ca94_Out_0_Float = _WaveSpread;
            float _GradientNoise_c4a6176d4d8e46c98e887e141f128ace_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_07da4fb4f18642ef83ac45f44e00d13a_Out_3_Vector2, _Property_197bb7e4b1d5495a848b56f391c3ca94_Out_0_Float, _GradientNoise_c4a6176d4d8e46c98e887e141f128ace_Out_2_Float);
            float _OneMinus_5666200d4b784081927194d399b19546_Out_1_Float;
            Unity_OneMinus_float(_GradientNoise_c4a6176d4d8e46c98e887e141f128ace_Out_2_Float, _OneMinus_5666200d4b784081927194d399b19546_Out_1_Float);
            float _Remap_df0e169dec134e1494011460992d4857_Out_3_Float;
            Unity_Remap_float(_OneMinus_5666200d4b784081927194d399b19546_Out_1_Float, float2 (0, 1), float2 (-1, 1), _Remap_df0e169dec134e1494011460992d4857_Out_3_Float);
            float _Multiply_21e2fe9741664562a375c951fee94e29_Out_2_Float;
            Unity_Multiply_float_float(_Property_d27cf8a7dad34ecd96496a2e168a017f_Out_0_Float, _Remap_df0e169dec134e1494011460992d4857_Out_3_Float, _Multiply_21e2fe9741664562a375c951fee94e29_Out_2_Float);
            float3 _Multiply_1bca5d8c2e8b4f69965496a79b732a5e_Out_2_Vector3;
            Unity_Multiply_float3_float3(IN.ObjectSpaceNormal, (_Multiply_21e2fe9741664562a375c951fee94e29_Out_2_Float.xxx), _Multiply_1bca5d8c2e8b4f69965496a79b732a5e_Out_2_Vector3);
            float3 _Add_8792ee7fc1774e53b8df716cea19ceeb_Out_2_Vector3;
            Unity_Add_float3(_Multiply_1bca5d8c2e8b4f69965496a79b732a5e_Out_2_Vector3, IN.ObjectSpacePosition, _Add_8792ee7fc1774e53b8df716cea19ceeb_Out_2_Vector3);
            description.Position = _Add_8792ee7fc1774e53b8df716cea19ceeb_Out_2_Vector3;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 NormalTS;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            surface.NormalTS = IN.TangentSpaceNormal;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.WorldSpacePosition =                         TransformObjectToWorld(input.positionOS);
            output.TimeParameters =                             _TimeParameters.xyz;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
            output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthNormalsOnlyPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "Meta"
            Tags
            {
                "LightMode" = "Meta"
            }
        
        // Render State
        Cull Off
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma shader_feature _ EDITOR_VISUALIZATION
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define ATTRIBUTES_NEED_TEXCOORD2
        #define ATTRIBUTES_NEED_INSTANCEID
        #define GRAPH_VERTEX_USES_TIME_PARAMETERS_INPUT
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_TEXCOORD1
        #define VARYINGS_NEED_TEXCOORD2
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_META
        #define _FOG_FRAGMENT 1
        #define REQUIRE_DEPTH_TEXTURE
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/MetaInput.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv1 : TEXCOORD1;
             float4 uv2 : TEXCOORD2;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float4 texCoord0;
             float4 texCoord1;
             float4 texCoord2;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float2 NDCPosition;
             float2 PixelPosition;
             float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float3 WorldSpacePosition;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0 : INTERP0;
             float4 texCoord1 : INTERP1;
             float4 texCoord2 : INTERP2;
             float3 positionWS : INTERP3;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.texCoord0.xyzw = input.texCoord0;
            output.texCoord1.xyzw = input.texCoord1;
            output.texCoord2.xyzw = input.texCoord2;
            output.positionWS.xyz = input.positionWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.texCoord0 = input.texCoord0.xyzw;
            output.texCoord1 = input.texCoord1.xyzw;
            output.texCoord2 = input.texCoord2.xyzw;
            output.positionWS = input.positionWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _PatternSpeed;
        float _FlowSpeed;
        float2 _FlowDirection;
        float _WaveSpread;
        float _WaveHeight;
        float _WaveSpeed;
        float _Scale;
        float _PatternDensity;
        float4 _WaterColor;
        float4 _PatternColor;
        float _FoamScale;
        float _FoamAmount;
        float _FoamCutoff;
        float4 _FoamColor;
        float _PatternCutoff;
        float _Frequency;
        float4 _RippleColor;
        float _RippleDuration;
        float _RippleSpeed;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        
        // Graph Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
        #include_with_pragmas "Assets/Water/RippleFunction.hlsl"
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Divide_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A / B;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        float2 Unity_GradientNoise_Deterministic_Dir_float(float2 p)
        {
            float x; Hash_Tchou_2_1_float(p, x);
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_Deterministic_float (float2 UV, float3 Scale, out float Out)
        {
            float2 p = UV * Scale.xy;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_Distance_float3(float3 A, float3 B, out float Out)
        {
            Out = distance(A, B);
        }
        
        void Unity_InverseLerp_float(float A, float B, float T, out float Out)
        {
            Out = (T - A)/(B - A);
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        float2 Unity_Voronoi_RandomVector_Deterministic_float (float2 UV, float offset)
        {
            Hash_Tchou_2_2_float(UV, UV);
            return float2(sin(UV.y * offset), cos(UV.x * offset)) * 0.5 + 0.5;
        }
        
        void Unity_Voronoi_Deterministic_float(float2 UV, float AngleOffset, float CellDensity, out float Out, out float Cells)
        {
            float2 g = floor(UV * CellDensity);
            float2 f = frac(UV * CellDensity);
            float t = 8.0;
            float3 res = float3(8.0, 0.0, 0.0);
            for (int y = -1; y <= 1; y++)
            {
                for (int x = -1; x <= 1; x++)
                {
                    float2 lattice = float2(x, y);
                    float2 offset = Unity_Voronoi_RandomVector_Deterministic_float(lattice + g, AngleOffset);
                    float d = distance(lattice + offset, f);
                    if (d < res.x)
                    {
                        res = float3(d, offset.x, offset.y);
                        Out = res.x;
                        Cells = res.y;
                    }
                }
            }
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_Add_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A + B;
        }
        
        void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
        {
            if (unity_OrthoParams.w == 1.0)
            {
                Out = LinearEyeDepth(ComputeWorldSpacePosition(UV.xy, SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), UNITY_MATRIX_I_VP), UNITY_MATRIX_V);
            }
            else
            {
                Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
            }
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        struct Bindings_DepthFade_8bbfe621c0368244b80a10cdd14cd70e_float
        {
        float4 ScreenPosition;
        float2 NDCPosition;
        };
        
        void SG_DepthFade_8bbfe621c0368244b80a10cdd14cd70e_float(float _Distance, Bindings_DepthFade_8bbfe621c0368244b80a10cdd14cd70e_float IN, out float Out_1)
        {
        float _SceneDepth_2eb96c52a24a4558b37a5f543bc363b1_Out_1_Float;
        Unity_SceneDepth_Eye_float(float4(IN.NDCPosition.xy, 0, 0), _SceneDepth_2eb96c52a24a4558b37a5f543bc363b1_Out_1_Float);
        float4 _ScreenPosition_4c9380fe7a70484c8beb74b5792bdbc8_Out_0_Vector4 = IN.ScreenPosition;
        float _Split_9c58755aea204a38a422f36c78e4d894_R_1_Float = _ScreenPosition_4c9380fe7a70484c8beb74b5792bdbc8_Out_0_Vector4[0];
        float _Split_9c58755aea204a38a422f36c78e4d894_G_2_Float = _ScreenPosition_4c9380fe7a70484c8beb74b5792bdbc8_Out_0_Vector4[1];
        float _Split_9c58755aea204a38a422f36c78e4d894_B_3_Float = _ScreenPosition_4c9380fe7a70484c8beb74b5792bdbc8_Out_0_Vector4[2];
        float _Split_9c58755aea204a38a422f36c78e4d894_A_4_Float = _ScreenPosition_4c9380fe7a70484c8beb74b5792bdbc8_Out_0_Vector4[3];
        float _Subtract_4b0c684883d8435c9e6d251f76545c9a_Out_2_Float;
        Unity_Subtract_float(_SceneDepth_2eb96c52a24a4558b37a5f543bc363b1_Out_1_Float, _Split_9c58755aea204a38a422f36c78e4d894_A_4_Float, _Subtract_4b0c684883d8435c9e6d251f76545c9a_Out_2_Float);
        float _Property_71a843c8a2ad403b8140354c6a881afd_Out_0_Float = _Distance;
        float _Divide_6a045dbede5f44819286797f917918ac_Out_2_Float;
        Unity_Divide_float(_Subtract_4b0c684883d8435c9e6d251f76545c9a_Out_2_Float, _Property_71a843c8a2ad403b8140354c6a881afd_Out_0_Float, _Divide_6a045dbede5f44819286797f917918ac_Out_2_Float);
        float _Saturate_f45f6fa4775044429c760084824ef684_Out_1_Float;
        Unity_Saturate_float(_Divide_6a045dbede5f44819286797f917918ac_Out_2_Float, _Saturate_f45f6fa4775044429c760084824ef684_Out_1_Float);
        Out_1 = _Saturate_f45f6fa4775044429c760084824ef684_Out_1_Float;
        }
        
        void Unity_Step_float(float Edge, float In, out float Out)
        {
            Out = step(Edge, In);
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Property_d27cf8a7dad34ecd96496a2e168a017f_Out_0_Float = _WaveHeight;
            float _Split_a4a9df004cc4457ab200382a084abebd_R_1_Float = IN.WorldSpacePosition[0];
            float _Split_a4a9df004cc4457ab200382a084abebd_G_2_Float = IN.WorldSpacePosition[1];
            float _Split_a4a9df004cc4457ab200382a084abebd_B_3_Float = IN.WorldSpacePosition[2];
            float _Split_a4a9df004cc4457ab200382a084abebd_A_4_Float = 0;
            float2 _Vector2_2a9c14ca8f744a208e525959dee4a260_Out_0_Vector2 = float2(_Split_a4a9df004cc4457ab200382a084abebd_R_1_Float, _Split_a4a9df004cc4457ab200382a084abebd_B_3_Float);
            float _Property_19f075486b9748cda9e8985ad901e546_Out_0_Float = _Scale;
            float2 _Divide_18910aaaf2724bc18f244ce72424925b_Out_2_Vector2;
            Unity_Divide_float2(_Vector2_2a9c14ca8f744a208e525959dee4a260_Out_0_Vector2, (_Property_19f075486b9748cda9e8985ad901e546_Out_0_Float.xx), _Divide_18910aaaf2724bc18f244ce72424925b_Out_2_Vector2);
            float2 _Property_54fb6e94cfc349049bf82b6de2a35e4d_Out_0_Vector2 = _FlowDirection;
            float _Property_62bb68af8ede43f6a392167fdaca1c04_Out_0_Float = _WaveSpeed;
            float _Multiply_fa246fa412f543c18db54cbf79b06304_Out_2_Float;
            Unity_Multiply_float_float(_Property_62bb68af8ede43f6a392167fdaca1c04_Out_0_Float, IN.TimeParameters.x, _Multiply_fa246fa412f543c18db54cbf79b06304_Out_2_Float);
            float2 _Multiply_7e3f5e405dcb43cb9d5c7f6b2de9ddbd_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Property_54fb6e94cfc349049bf82b6de2a35e4d_Out_0_Vector2, (_Multiply_fa246fa412f543c18db54cbf79b06304_Out_2_Float.xx), _Multiply_7e3f5e405dcb43cb9d5c7f6b2de9ddbd_Out_2_Vector2);
            float2 _TilingAndOffset_07da4fb4f18642ef83ac45f44e00d13a_Out_3_Vector2;
            Unity_TilingAndOffset_float(_Divide_18910aaaf2724bc18f244ce72424925b_Out_2_Vector2, float2 (1, 1), _Multiply_7e3f5e405dcb43cb9d5c7f6b2de9ddbd_Out_2_Vector2, _TilingAndOffset_07da4fb4f18642ef83ac45f44e00d13a_Out_3_Vector2);
            float _Property_197bb7e4b1d5495a848b56f391c3ca94_Out_0_Float = _WaveSpread;
            float _GradientNoise_c4a6176d4d8e46c98e887e141f128ace_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_07da4fb4f18642ef83ac45f44e00d13a_Out_3_Vector2, _Property_197bb7e4b1d5495a848b56f391c3ca94_Out_0_Float, _GradientNoise_c4a6176d4d8e46c98e887e141f128ace_Out_2_Float);
            float _OneMinus_5666200d4b784081927194d399b19546_Out_1_Float;
            Unity_OneMinus_float(_GradientNoise_c4a6176d4d8e46c98e887e141f128ace_Out_2_Float, _OneMinus_5666200d4b784081927194d399b19546_Out_1_Float);
            float _Remap_df0e169dec134e1494011460992d4857_Out_3_Float;
            Unity_Remap_float(_OneMinus_5666200d4b784081927194d399b19546_Out_1_Float, float2 (0, 1), float2 (-1, 1), _Remap_df0e169dec134e1494011460992d4857_Out_3_Float);
            float _Multiply_21e2fe9741664562a375c951fee94e29_Out_2_Float;
            Unity_Multiply_float_float(_Property_d27cf8a7dad34ecd96496a2e168a017f_Out_0_Float, _Remap_df0e169dec134e1494011460992d4857_Out_3_Float, _Multiply_21e2fe9741664562a375c951fee94e29_Out_2_Float);
            float3 _Multiply_1bca5d8c2e8b4f69965496a79b732a5e_Out_2_Vector3;
            Unity_Multiply_float3_float3(IN.ObjectSpaceNormal, (_Multiply_21e2fe9741664562a375c951fee94e29_Out_2_Float.xxx), _Multiply_1bca5d8c2e8b4f69965496a79b732a5e_Out_2_Vector3);
            float3 _Add_8792ee7fc1774e53b8df716cea19ceeb_Out_2_Vector3;
            Unity_Add_float3(_Multiply_1bca5d8c2e8b4f69965496a79b732a5e_Out_2_Vector3, IN.ObjectSpacePosition, _Add_8792ee7fc1774e53b8df716cea19ceeb_Out_2_Vector3);
            description.Position = _Add_8792ee7fc1774e53b8df716cea19ceeb_Out_2_Vector3;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float3 Emission;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _Property_671d70dd5da140ee96643d243dc37fd8_Out_0_Vector4 = _WaterColor;
            float _Property_dad906e3a15845749abaee1638b45450_Out_0_Float = _PatternCutoff;
            float _Distance_cc5c484eebf44373a1398dd7e1ff845c_Out_2_Float;
            Unity_Distance_float3(IN.WorldSpacePosition, _WorldSpaceCameraPos, _Distance_cc5c484eebf44373a1398dd7e1ff845c_Out_2_Float);
            float _InverseLerp_a4e53d21ad914646bd2fa3203824b74a_Out_3_Float;
            Unity_InverseLerp_float(_Property_dad906e3a15845749abaee1638b45450_Out_0_Float, float(0), _Distance_cc5c484eebf44373a1398dd7e1ff845c_Out_2_Float, _InverseLerp_a4e53d21ad914646bd2fa3203824b74a_Out_3_Float);
            float _Saturate_aec1f9a3c440421da2b762a373cb90af_Out_1_Float;
            Unity_Saturate_float(_InverseLerp_a4e53d21ad914646bd2fa3203824b74a_Out_3_Float, _Saturate_aec1f9a3c440421da2b762a373cb90af_Out_1_Float);
            float4 _Property_d1a487fb48c74645a6287a2efe9e84ec_Out_0_Vector4 = IsGammaSpace() ? LinearToSRGB(_PatternColor) : _PatternColor;
            float _Split_6514885e4bf748d7a415566148d27785_R_1_Float = IN.WorldSpacePosition[0];
            float _Split_6514885e4bf748d7a415566148d27785_G_2_Float = IN.WorldSpacePosition[1];
            float _Split_6514885e4bf748d7a415566148d27785_B_3_Float = IN.WorldSpacePosition[2];
            float _Split_6514885e4bf748d7a415566148d27785_A_4_Float = 0;
            float2 _Vector2_aacd28bdf4cf4521b9d76e9dbe00d1e0_Out_0_Vector2 = float2(_Split_6514885e4bf748d7a415566148d27785_R_1_Float, _Split_6514885e4bf748d7a415566148d27785_B_3_Float);
            float _Property_35d111bad030402bbf4b94caac81b7f5_Out_0_Float = _Scale;
            float2 _Divide_72c033936cee42ee80147ea81c9d2ecf_Out_2_Vector2;
            Unity_Divide_float2(_Vector2_aacd28bdf4cf4521b9d76e9dbe00d1e0_Out_0_Vector2, (_Property_35d111bad030402bbf4b94caac81b7f5_Out_0_Float.xx), _Divide_72c033936cee42ee80147ea81c9d2ecf_Out_2_Vector2);
            float2 _Property_3ee92cea9de142c296a1467413ffd108_Out_0_Vector2 = _FlowDirection;
            float _Property_47d6f34367a74d388cde1a2ecaf6ccda_Out_0_Float = _FlowSpeed;
            float _Multiply_979a08f5be6e43a7ac018afb58904b04_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_47d6f34367a74d388cde1a2ecaf6ccda_Out_0_Float, _Multiply_979a08f5be6e43a7ac018afb58904b04_Out_2_Float);
            float2 _Multiply_c26278cacbce4cb1a639bf0229ed4f3b_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Property_3ee92cea9de142c296a1467413ffd108_Out_0_Vector2, (_Multiply_979a08f5be6e43a7ac018afb58904b04_Out_2_Float.xx), _Multiply_c26278cacbce4cb1a639bf0229ed4f3b_Out_2_Vector2);
            float2 _TilingAndOffset_c6acd5a2b68d4f079820e39856a12d58_Out_3_Vector2;
            Unity_TilingAndOffset_float(_Divide_72c033936cee42ee80147ea81c9d2ecf_Out_2_Vector2, float2 (1, 1), _Multiply_c26278cacbce4cb1a639bf0229ed4f3b_Out_2_Vector2, _TilingAndOffset_c6acd5a2b68d4f079820e39856a12d58_Out_3_Vector2);
            float _Property_17027e778cf54529aae8b565ff3e1f98_Out_0_Float = _PatternSpeed;
            float _Multiply_b502ebc2c57440149af34fae45d33914_Out_2_Float;
            Unity_Multiply_float_float(_Property_17027e778cf54529aae8b565ff3e1f98_Out_0_Float, IN.TimeParameters.x, _Multiply_b502ebc2c57440149af34fae45d33914_Out_2_Float);
            float _Property_3f313ed937e5421a92aa2eed66441c05_Out_0_Float = _PatternDensity;
            float _Voronoi_49347d90d7f84f2688bd11c85c622d4a_Out_3_Float;
            float _Voronoi_49347d90d7f84f2688bd11c85c622d4a_Cells_4_Float;
            Unity_Voronoi_Deterministic_float(_TilingAndOffset_c6acd5a2b68d4f079820e39856a12d58_Out_3_Vector2, _Multiply_b502ebc2c57440149af34fae45d33914_Out_2_Float, _Property_3f313ed937e5421a92aa2eed66441c05_Out_0_Float, _Voronoi_49347d90d7f84f2688bd11c85c622d4a_Out_3_Float, _Voronoi_49347d90d7f84f2688bd11c85c622d4a_Cells_4_Float);
            float _Power_5fa13e83b0bd4a30948e58d874ec8e1c_Out_2_Float;
            Unity_Power_float(_Voronoi_49347d90d7f84f2688bd11c85c622d4a_Out_3_Float, float(5), _Power_5fa13e83b0bd4a30948e58d874ec8e1c_Out_2_Float);
            float4 _Multiply_71f563a2f0994124a41103b119f6ef23_Out_2_Vector4;
            Unity_Multiply_float4_float4(_Property_d1a487fb48c74645a6287a2efe9e84ec_Out_0_Vector4, (_Power_5fa13e83b0bd4a30948e58d874ec8e1c_Out_2_Float.xxxx), _Multiply_71f563a2f0994124a41103b119f6ef23_Out_2_Vector4);
            float4 _Multiply_6366b6f890e24726a301b5317d8cca7f_Out_2_Vector4;
            Unity_Multiply_float4_float4((_Saturate_aec1f9a3c440421da2b762a373cb90af_Out_1_Float.xxxx), _Multiply_71f563a2f0994124a41103b119f6ef23_Out_2_Vector4, _Multiply_6366b6f890e24726a301b5317d8cca7f_Out_2_Vector4);
            float4 _Add_ecc8b0b6f3da4501b6a1866fd0669de6_Out_2_Vector4;
            Unity_Add_float4(_Property_671d70dd5da140ee96643d243dc37fd8_Out_0_Vector4, _Multiply_6366b6f890e24726a301b5317d8cca7f_Out_2_Vector4, _Add_ecc8b0b6f3da4501b6a1866fd0669de6_Out_2_Vector4);
            float4 _Property_487ab90812634ee7a3ee5e7286c31b37_Out_0_Vector4 = _FoamColor;
            float _Property_f098ae14b87349b18021704e4796e375_Out_0_Float = _FoamAmount;
            Bindings_DepthFade_8bbfe621c0368244b80a10cdd14cd70e_float _DepthFade_e9f6efdeeea748d5b9489cb9356db947;
            _DepthFade_e9f6efdeeea748d5b9489cb9356db947.ScreenPosition = IN.ScreenPosition;
            _DepthFade_e9f6efdeeea748d5b9489cb9356db947.NDCPosition = IN.NDCPosition;
            float _DepthFade_e9f6efdeeea748d5b9489cb9356db947_Out_1_Float;
            SG_DepthFade_8bbfe621c0368244b80a10cdd14cd70e_float(_Property_f098ae14b87349b18021704e4796e375_Out_0_Float, _DepthFade_e9f6efdeeea748d5b9489cb9356db947, _DepthFade_e9f6efdeeea748d5b9489cb9356db947_Out_1_Float);
            float _Property_a7ccaf84ea904aef93f7567d05a08c53_Out_0_Float = _FoamCutoff;
            float _Multiply_8e97f0c830a94fe1b9f69046189ad20f_Out_2_Float;
            Unity_Multiply_float_float(_DepthFade_e9f6efdeeea748d5b9489cb9356db947_Out_1_Float, _Property_a7ccaf84ea904aef93f7567d05a08c53_Out_0_Float, _Multiply_8e97f0c830a94fe1b9f69046189ad20f_Out_2_Float);
            float _Property_8aa776c9bffc482a9b793dcf9b21ade8_Out_0_Float = _FoamScale;
            float _GradientNoise_f2a772e9e9de4969aef9721d103f92f8_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_c6acd5a2b68d4f079820e39856a12d58_Out_3_Vector2, _Property_8aa776c9bffc482a9b793dcf9b21ade8_Out_0_Float, _GradientNoise_f2a772e9e9de4969aef9721d103f92f8_Out_2_Float);
            float _Step_56ca35ee6ad74a8884e66e97609c8aa2_Out_2_Float;
            Unity_Step_float(_Multiply_8e97f0c830a94fe1b9f69046189ad20f_Out_2_Float, _GradientNoise_f2a772e9e9de4969aef9721d103f92f8_Out_2_Float, _Step_56ca35ee6ad74a8884e66e97609c8aa2_Out_2_Float);
            float4 _Lerp_de94925a336f44d3a6ce9a0e9dc95dd0_Out_3_Vector4;
            Unity_Lerp_float4(_Add_ecc8b0b6f3da4501b6a1866fd0669de6_Out_2_Vector4, _Property_487ab90812634ee7a3ee5e7286c31b37_Out_0_Vector4, (_Step_56ca35ee6ad74a8884e66e97609c8aa2_Out_2_Float.xxxx), _Lerp_de94925a336f44d3a6ce9a0e9dc95dd0_Out_3_Vector4);
            float4 _Property_77b93701aebc4074baeea8507b1154c7_Out_0_Vector4 = _RippleColor;
            float _Property_6d3446e5f668442b98fa00a4f2586995_Out_0_Float = _Frequency;
            float _Property_1dfb9c72b1914f8ba792ea320d9c44f9_Out_0_Float = _RippleDuration;
            float _Property_257bf14bacfe4c9f9c21df39ebc817be_Out_0_Float = _RippleSpeed;
            float _RippleFunctionCustomFunction_e7bd970bd8964ae5a69f01acec2bce3c_result_0_Float;
            RippleFunction_float(_Vector2_aacd28bdf4cf4521b9d76e9dbe00d1e0_Out_0_Vector2, IN.TimeParameters.x, _Property_6d3446e5f668442b98fa00a4f2586995_Out_0_Float, _Property_1dfb9c72b1914f8ba792ea320d9c44f9_Out_0_Float, _Property_257bf14bacfe4c9f9c21df39ebc817be_Out_0_Float, _RippleFunctionCustomFunction_e7bd970bd8964ae5a69f01acec2bce3c_result_0_Float);
            float4 _Lerp_b21bf96f73c1465eb973600089828e31_Out_3_Vector4;
            Unity_Lerp_float4(_Lerp_de94925a336f44d3a6ce9a0e9dc95dd0_Out_3_Vector4, _Property_77b93701aebc4074baeea8507b1154c7_Out_0_Vector4, (_RippleFunctionCustomFunction_e7bd970bd8964ae5a69f01acec2bce3c_result_0_Float.xxxx), _Lerp_b21bf96f73c1465eb973600089828e31_Out_3_Vector4);
            surface.BaseColor = (_Lerp_b21bf96f73c1465eb973600089828e31_Out_3_Vector4.xyz);
            surface.Emission = float3(0, 0, 0);
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.WorldSpacePosition =                         TransformObjectToWorld(input.positionOS);
            output.TimeParameters =                             _TimeParameters.xyz;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        
            #if UNITY_UV_STARTS_AT_TOP
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #else
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #endif
        
            output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
            output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
            output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/LightingMetaPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "SceneSelectionPass"
            Tags
            {
                "LightMode" = "SceneSelectionPass"
            }
        
        // Render State
        Cull Off
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define GRAPH_VERTEX_USES_TIME_PARAMETERS_INPUT
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHONLY
        #define SCENESELECTIONPASS 1
        #define ALPHA_CLIP_THRESHOLD 1
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float3 WorldSpacePosition;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _PatternSpeed;
        float _FlowSpeed;
        float2 _FlowDirection;
        float _WaveSpread;
        float _WaveHeight;
        float _WaveSpeed;
        float _Scale;
        float _PatternDensity;
        float4 _WaterColor;
        float4 _PatternColor;
        float _FoamScale;
        float _FoamAmount;
        float _FoamCutoff;
        float4 _FoamColor;
        float _PatternCutoff;
        float _Frequency;
        float4 _RippleColor;
        float _RippleDuration;
        float _RippleSpeed;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        
        // Graph Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Divide_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A / B;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        float2 Unity_GradientNoise_Deterministic_Dir_float(float2 p)
        {
            float x; Hash_Tchou_2_1_float(p, x);
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_Deterministic_float (float2 UV, float3 Scale, out float Out)
        {
            float2 p = UV * Scale.xy;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Property_d27cf8a7dad34ecd96496a2e168a017f_Out_0_Float = _WaveHeight;
            float _Split_a4a9df004cc4457ab200382a084abebd_R_1_Float = IN.WorldSpacePosition[0];
            float _Split_a4a9df004cc4457ab200382a084abebd_G_2_Float = IN.WorldSpacePosition[1];
            float _Split_a4a9df004cc4457ab200382a084abebd_B_3_Float = IN.WorldSpacePosition[2];
            float _Split_a4a9df004cc4457ab200382a084abebd_A_4_Float = 0;
            float2 _Vector2_2a9c14ca8f744a208e525959dee4a260_Out_0_Vector2 = float2(_Split_a4a9df004cc4457ab200382a084abebd_R_1_Float, _Split_a4a9df004cc4457ab200382a084abebd_B_3_Float);
            float _Property_19f075486b9748cda9e8985ad901e546_Out_0_Float = _Scale;
            float2 _Divide_18910aaaf2724bc18f244ce72424925b_Out_2_Vector2;
            Unity_Divide_float2(_Vector2_2a9c14ca8f744a208e525959dee4a260_Out_0_Vector2, (_Property_19f075486b9748cda9e8985ad901e546_Out_0_Float.xx), _Divide_18910aaaf2724bc18f244ce72424925b_Out_2_Vector2);
            float2 _Property_54fb6e94cfc349049bf82b6de2a35e4d_Out_0_Vector2 = _FlowDirection;
            float _Property_62bb68af8ede43f6a392167fdaca1c04_Out_0_Float = _WaveSpeed;
            float _Multiply_fa246fa412f543c18db54cbf79b06304_Out_2_Float;
            Unity_Multiply_float_float(_Property_62bb68af8ede43f6a392167fdaca1c04_Out_0_Float, IN.TimeParameters.x, _Multiply_fa246fa412f543c18db54cbf79b06304_Out_2_Float);
            float2 _Multiply_7e3f5e405dcb43cb9d5c7f6b2de9ddbd_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Property_54fb6e94cfc349049bf82b6de2a35e4d_Out_0_Vector2, (_Multiply_fa246fa412f543c18db54cbf79b06304_Out_2_Float.xx), _Multiply_7e3f5e405dcb43cb9d5c7f6b2de9ddbd_Out_2_Vector2);
            float2 _TilingAndOffset_07da4fb4f18642ef83ac45f44e00d13a_Out_3_Vector2;
            Unity_TilingAndOffset_float(_Divide_18910aaaf2724bc18f244ce72424925b_Out_2_Vector2, float2 (1, 1), _Multiply_7e3f5e405dcb43cb9d5c7f6b2de9ddbd_Out_2_Vector2, _TilingAndOffset_07da4fb4f18642ef83ac45f44e00d13a_Out_3_Vector2);
            float _Property_197bb7e4b1d5495a848b56f391c3ca94_Out_0_Float = _WaveSpread;
            float _GradientNoise_c4a6176d4d8e46c98e887e141f128ace_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_07da4fb4f18642ef83ac45f44e00d13a_Out_3_Vector2, _Property_197bb7e4b1d5495a848b56f391c3ca94_Out_0_Float, _GradientNoise_c4a6176d4d8e46c98e887e141f128ace_Out_2_Float);
            float _OneMinus_5666200d4b784081927194d399b19546_Out_1_Float;
            Unity_OneMinus_float(_GradientNoise_c4a6176d4d8e46c98e887e141f128ace_Out_2_Float, _OneMinus_5666200d4b784081927194d399b19546_Out_1_Float);
            float _Remap_df0e169dec134e1494011460992d4857_Out_3_Float;
            Unity_Remap_float(_OneMinus_5666200d4b784081927194d399b19546_Out_1_Float, float2 (0, 1), float2 (-1, 1), _Remap_df0e169dec134e1494011460992d4857_Out_3_Float);
            float _Multiply_21e2fe9741664562a375c951fee94e29_Out_2_Float;
            Unity_Multiply_float_float(_Property_d27cf8a7dad34ecd96496a2e168a017f_Out_0_Float, _Remap_df0e169dec134e1494011460992d4857_Out_3_Float, _Multiply_21e2fe9741664562a375c951fee94e29_Out_2_Float);
            float3 _Multiply_1bca5d8c2e8b4f69965496a79b732a5e_Out_2_Vector3;
            Unity_Multiply_float3_float3(IN.ObjectSpaceNormal, (_Multiply_21e2fe9741664562a375c951fee94e29_Out_2_Float.xxx), _Multiply_1bca5d8c2e8b4f69965496a79b732a5e_Out_2_Vector3);
            float3 _Add_8792ee7fc1774e53b8df716cea19ceeb_Out_2_Vector3;
            Unity_Add_float3(_Multiply_1bca5d8c2e8b4f69965496a79b732a5e_Out_2_Vector3, IN.ObjectSpacePosition, _Add_8792ee7fc1774e53b8df716cea19ceeb_Out_2_Vector3);
            description.Position = _Add_8792ee7fc1774e53b8df716cea19ceeb_Out_2_Vector3;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.WorldSpacePosition =                         TransformObjectToWorld(input.positionOS);
            output.TimeParameters =                             _TimeParameters.xyz;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SelectionPickingPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "ScenePickingPass"
            Tags
            {
                "LightMode" = "Picking"
            }
        
        // Render State
        Cull Back
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define GRAPH_VERTEX_USES_TIME_PARAMETERS_INPUT
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_POSITION_WS
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHONLY
        #define SCENEPICKINGPASS 1
        #define ALPHA_CLIP_THRESHOLD 1
        #define REQUIRE_DEPTH_TEXTURE
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float2 NDCPosition;
             float2 PixelPosition;
             float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float3 WorldSpacePosition;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS : INTERP0;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.positionWS.xyz = input.positionWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.positionWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _PatternSpeed;
        float _FlowSpeed;
        float2 _FlowDirection;
        float _WaveSpread;
        float _WaveHeight;
        float _WaveSpeed;
        float _Scale;
        float _PatternDensity;
        float4 _WaterColor;
        float4 _PatternColor;
        float _FoamScale;
        float _FoamAmount;
        float _FoamCutoff;
        float4 _FoamColor;
        float _PatternCutoff;
        float _Frequency;
        float4 _RippleColor;
        float _RippleDuration;
        float _RippleSpeed;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        
        // Graph Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
        #include_with_pragmas "Assets/Water/RippleFunction.hlsl"
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Divide_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A / B;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        float2 Unity_GradientNoise_Deterministic_Dir_float(float2 p)
        {
            float x; Hash_Tchou_2_1_float(p, x);
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_Deterministic_float (float2 UV, float3 Scale, out float Out)
        {
            float2 p = UV * Scale.xy;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_Distance_float3(float3 A, float3 B, out float Out)
        {
            Out = distance(A, B);
        }
        
        void Unity_InverseLerp_float(float A, float B, float T, out float Out)
        {
            Out = (T - A)/(B - A);
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        float2 Unity_Voronoi_RandomVector_Deterministic_float (float2 UV, float offset)
        {
            Hash_Tchou_2_2_float(UV, UV);
            return float2(sin(UV.y * offset), cos(UV.x * offset)) * 0.5 + 0.5;
        }
        
        void Unity_Voronoi_Deterministic_float(float2 UV, float AngleOffset, float CellDensity, out float Out, out float Cells)
        {
            float2 g = floor(UV * CellDensity);
            float2 f = frac(UV * CellDensity);
            float t = 8.0;
            float3 res = float3(8.0, 0.0, 0.0);
            for (int y = -1; y <= 1; y++)
            {
                for (int x = -1; x <= 1; x++)
                {
                    float2 lattice = float2(x, y);
                    float2 offset = Unity_Voronoi_RandomVector_Deterministic_float(lattice + g, AngleOffset);
                    float d = distance(lattice + offset, f);
                    if (d < res.x)
                    {
                        res = float3(d, offset.x, offset.y);
                        Out = res.x;
                        Cells = res.y;
                    }
                }
            }
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_Add_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A + B;
        }
        
        void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
        {
            if (unity_OrthoParams.w == 1.0)
            {
                Out = LinearEyeDepth(ComputeWorldSpacePosition(UV.xy, SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), UNITY_MATRIX_I_VP), UNITY_MATRIX_V);
            }
            else
            {
                Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
            }
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        struct Bindings_DepthFade_8bbfe621c0368244b80a10cdd14cd70e_float
        {
        float4 ScreenPosition;
        float2 NDCPosition;
        };
        
        void SG_DepthFade_8bbfe621c0368244b80a10cdd14cd70e_float(float _Distance, Bindings_DepthFade_8bbfe621c0368244b80a10cdd14cd70e_float IN, out float Out_1)
        {
        float _SceneDepth_2eb96c52a24a4558b37a5f543bc363b1_Out_1_Float;
        Unity_SceneDepth_Eye_float(float4(IN.NDCPosition.xy, 0, 0), _SceneDepth_2eb96c52a24a4558b37a5f543bc363b1_Out_1_Float);
        float4 _ScreenPosition_4c9380fe7a70484c8beb74b5792bdbc8_Out_0_Vector4 = IN.ScreenPosition;
        float _Split_9c58755aea204a38a422f36c78e4d894_R_1_Float = _ScreenPosition_4c9380fe7a70484c8beb74b5792bdbc8_Out_0_Vector4[0];
        float _Split_9c58755aea204a38a422f36c78e4d894_G_2_Float = _ScreenPosition_4c9380fe7a70484c8beb74b5792bdbc8_Out_0_Vector4[1];
        float _Split_9c58755aea204a38a422f36c78e4d894_B_3_Float = _ScreenPosition_4c9380fe7a70484c8beb74b5792bdbc8_Out_0_Vector4[2];
        float _Split_9c58755aea204a38a422f36c78e4d894_A_4_Float = _ScreenPosition_4c9380fe7a70484c8beb74b5792bdbc8_Out_0_Vector4[3];
        float _Subtract_4b0c684883d8435c9e6d251f76545c9a_Out_2_Float;
        Unity_Subtract_float(_SceneDepth_2eb96c52a24a4558b37a5f543bc363b1_Out_1_Float, _Split_9c58755aea204a38a422f36c78e4d894_A_4_Float, _Subtract_4b0c684883d8435c9e6d251f76545c9a_Out_2_Float);
        float _Property_71a843c8a2ad403b8140354c6a881afd_Out_0_Float = _Distance;
        float _Divide_6a045dbede5f44819286797f917918ac_Out_2_Float;
        Unity_Divide_float(_Subtract_4b0c684883d8435c9e6d251f76545c9a_Out_2_Float, _Property_71a843c8a2ad403b8140354c6a881afd_Out_0_Float, _Divide_6a045dbede5f44819286797f917918ac_Out_2_Float);
        float _Saturate_f45f6fa4775044429c760084824ef684_Out_1_Float;
        Unity_Saturate_float(_Divide_6a045dbede5f44819286797f917918ac_Out_2_Float, _Saturate_f45f6fa4775044429c760084824ef684_Out_1_Float);
        Out_1 = _Saturate_f45f6fa4775044429c760084824ef684_Out_1_Float;
        }
        
        void Unity_Step_float(float Edge, float In, out float Out)
        {
            Out = step(Edge, In);
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Property_d27cf8a7dad34ecd96496a2e168a017f_Out_0_Float = _WaveHeight;
            float _Split_a4a9df004cc4457ab200382a084abebd_R_1_Float = IN.WorldSpacePosition[0];
            float _Split_a4a9df004cc4457ab200382a084abebd_G_2_Float = IN.WorldSpacePosition[1];
            float _Split_a4a9df004cc4457ab200382a084abebd_B_3_Float = IN.WorldSpacePosition[2];
            float _Split_a4a9df004cc4457ab200382a084abebd_A_4_Float = 0;
            float2 _Vector2_2a9c14ca8f744a208e525959dee4a260_Out_0_Vector2 = float2(_Split_a4a9df004cc4457ab200382a084abebd_R_1_Float, _Split_a4a9df004cc4457ab200382a084abebd_B_3_Float);
            float _Property_19f075486b9748cda9e8985ad901e546_Out_0_Float = _Scale;
            float2 _Divide_18910aaaf2724bc18f244ce72424925b_Out_2_Vector2;
            Unity_Divide_float2(_Vector2_2a9c14ca8f744a208e525959dee4a260_Out_0_Vector2, (_Property_19f075486b9748cda9e8985ad901e546_Out_0_Float.xx), _Divide_18910aaaf2724bc18f244ce72424925b_Out_2_Vector2);
            float2 _Property_54fb6e94cfc349049bf82b6de2a35e4d_Out_0_Vector2 = _FlowDirection;
            float _Property_62bb68af8ede43f6a392167fdaca1c04_Out_0_Float = _WaveSpeed;
            float _Multiply_fa246fa412f543c18db54cbf79b06304_Out_2_Float;
            Unity_Multiply_float_float(_Property_62bb68af8ede43f6a392167fdaca1c04_Out_0_Float, IN.TimeParameters.x, _Multiply_fa246fa412f543c18db54cbf79b06304_Out_2_Float);
            float2 _Multiply_7e3f5e405dcb43cb9d5c7f6b2de9ddbd_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Property_54fb6e94cfc349049bf82b6de2a35e4d_Out_0_Vector2, (_Multiply_fa246fa412f543c18db54cbf79b06304_Out_2_Float.xx), _Multiply_7e3f5e405dcb43cb9d5c7f6b2de9ddbd_Out_2_Vector2);
            float2 _TilingAndOffset_07da4fb4f18642ef83ac45f44e00d13a_Out_3_Vector2;
            Unity_TilingAndOffset_float(_Divide_18910aaaf2724bc18f244ce72424925b_Out_2_Vector2, float2 (1, 1), _Multiply_7e3f5e405dcb43cb9d5c7f6b2de9ddbd_Out_2_Vector2, _TilingAndOffset_07da4fb4f18642ef83ac45f44e00d13a_Out_3_Vector2);
            float _Property_197bb7e4b1d5495a848b56f391c3ca94_Out_0_Float = _WaveSpread;
            float _GradientNoise_c4a6176d4d8e46c98e887e141f128ace_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_07da4fb4f18642ef83ac45f44e00d13a_Out_3_Vector2, _Property_197bb7e4b1d5495a848b56f391c3ca94_Out_0_Float, _GradientNoise_c4a6176d4d8e46c98e887e141f128ace_Out_2_Float);
            float _OneMinus_5666200d4b784081927194d399b19546_Out_1_Float;
            Unity_OneMinus_float(_GradientNoise_c4a6176d4d8e46c98e887e141f128ace_Out_2_Float, _OneMinus_5666200d4b784081927194d399b19546_Out_1_Float);
            float _Remap_df0e169dec134e1494011460992d4857_Out_3_Float;
            Unity_Remap_float(_OneMinus_5666200d4b784081927194d399b19546_Out_1_Float, float2 (0, 1), float2 (-1, 1), _Remap_df0e169dec134e1494011460992d4857_Out_3_Float);
            float _Multiply_21e2fe9741664562a375c951fee94e29_Out_2_Float;
            Unity_Multiply_float_float(_Property_d27cf8a7dad34ecd96496a2e168a017f_Out_0_Float, _Remap_df0e169dec134e1494011460992d4857_Out_3_Float, _Multiply_21e2fe9741664562a375c951fee94e29_Out_2_Float);
            float3 _Multiply_1bca5d8c2e8b4f69965496a79b732a5e_Out_2_Vector3;
            Unity_Multiply_float3_float3(IN.ObjectSpaceNormal, (_Multiply_21e2fe9741664562a375c951fee94e29_Out_2_Float.xxx), _Multiply_1bca5d8c2e8b4f69965496a79b732a5e_Out_2_Vector3);
            float3 _Add_8792ee7fc1774e53b8df716cea19ceeb_Out_2_Vector3;
            Unity_Add_float3(_Multiply_1bca5d8c2e8b4f69965496a79b732a5e_Out_2_Vector3, IN.ObjectSpacePosition, _Add_8792ee7fc1774e53b8df716cea19ceeb_Out_2_Vector3);
            description.Position = _Add_8792ee7fc1774e53b8df716cea19ceeb_Out_2_Vector3;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _Property_671d70dd5da140ee96643d243dc37fd8_Out_0_Vector4 = _WaterColor;
            float _Property_dad906e3a15845749abaee1638b45450_Out_0_Float = _PatternCutoff;
            float _Distance_cc5c484eebf44373a1398dd7e1ff845c_Out_2_Float;
            Unity_Distance_float3(IN.WorldSpacePosition, _WorldSpaceCameraPos, _Distance_cc5c484eebf44373a1398dd7e1ff845c_Out_2_Float);
            float _InverseLerp_a4e53d21ad914646bd2fa3203824b74a_Out_3_Float;
            Unity_InverseLerp_float(_Property_dad906e3a15845749abaee1638b45450_Out_0_Float, float(0), _Distance_cc5c484eebf44373a1398dd7e1ff845c_Out_2_Float, _InverseLerp_a4e53d21ad914646bd2fa3203824b74a_Out_3_Float);
            float _Saturate_aec1f9a3c440421da2b762a373cb90af_Out_1_Float;
            Unity_Saturate_float(_InverseLerp_a4e53d21ad914646bd2fa3203824b74a_Out_3_Float, _Saturate_aec1f9a3c440421da2b762a373cb90af_Out_1_Float);
            float4 _Property_d1a487fb48c74645a6287a2efe9e84ec_Out_0_Vector4 = IsGammaSpace() ? LinearToSRGB(_PatternColor) : _PatternColor;
            float _Split_6514885e4bf748d7a415566148d27785_R_1_Float = IN.WorldSpacePosition[0];
            float _Split_6514885e4bf748d7a415566148d27785_G_2_Float = IN.WorldSpacePosition[1];
            float _Split_6514885e4bf748d7a415566148d27785_B_3_Float = IN.WorldSpacePosition[2];
            float _Split_6514885e4bf748d7a415566148d27785_A_4_Float = 0;
            float2 _Vector2_aacd28bdf4cf4521b9d76e9dbe00d1e0_Out_0_Vector2 = float2(_Split_6514885e4bf748d7a415566148d27785_R_1_Float, _Split_6514885e4bf748d7a415566148d27785_B_3_Float);
            float _Property_35d111bad030402bbf4b94caac81b7f5_Out_0_Float = _Scale;
            float2 _Divide_72c033936cee42ee80147ea81c9d2ecf_Out_2_Vector2;
            Unity_Divide_float2(_Vector2_aacd28bdf4cf4521b9d76e9dbe00d1e0_Out_0_Vector2, (_Property_35d111bad030402bbf4b94caac81b7f5_Out_0_Float.xx), _Divide_72c033936cee42ee80147ea81c9d2ecf_Out_2_Vector2);
            float2 _Property_3ee92cea9de142c296a1467413ffd108_Out_0_Vector2 = _FlowDirection;
            float _Property_47d6f34367a74d388cde1a2ecaf6ccda_Out_0_Float = _FlowSpeed;
            float _Multiply_979a08f5be6e43a7ac018afb58904b04_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_47d6f34367a74d388cde1a2ecaf6ccda_Out_0_Float, _Multiply_979a08f5be6e43a7ac018afb58904b04_Out_2_Float);
            float2 _Multiply_c26278cacbce4cb1a639bf0229ed4f3b_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Property_3ee92cea9de142c296a1467413ffd108_Out_0_Vector2, (_Multiply_979a08f5be6e43a7ac018afb58904b04_Out_2_Float.xx), _Multiply_c26278cacbce4cb1a639bf0229ed4f3b_Out_2_Vector2);
            float2 _TilingAndOffset_c6acd5a2b68d4f079820e39856a12d58_Out_3_Vector2;
            Unity_TilingAndOffset_float(_Divide_72c033936cee42ee80147ea81c9d2ecf_Out_2_Vector2, float2 (1, 1), _Multiply_c26278cacbce4cb1a639bf0229ed4f3b_Out_2_Vector2, _TilingAndOffset_c6acd5a2b68d4f079820e39856a12d58_Out_3_Vector2);
            float _Property_17027e778cf54529aae8b565ff3e1f98_Out_0_Float = _PatternSpeed;
            float _Multiply_b502ebc2c57440149af34fae45d33914_Out_2_Float;
            Unity_Multiply_float_float(_Property_17027e778cf54529aae8b565ff3e1f98_Out_0_Float, IN.TimeParameters.x, _Multiply_b502ebc2c57440149af34fae45d33914_Out_2_Float);
            float _Property_3f313ed937e5421a92aa2eed66441c05_Out_0_Float = _PatternDensity;
            float _Voronoi_49347d90d7f84f2688bd11c85c622d4a_Out_3_Float;
            float _Voronoi_49347d90d7f84f2688bd11c85c622d4a_Cells_4_Float;
            Unity_Voronoi_Deterministic_float(_TilingAndOffset_c6acd5a2b68d4f079820e39856a12d58_Out_3_Vector2, _Multiply_b502ebc2c57440149af34fae45d33914_Out_2_Float, _Property_3f313ed937e5421a92aa2eed66441c05_Out_0_Float, _Voronoi_49347d90d7f84f2688bd11c85c622d4a_Out_3_Float, _Voronoi_49347d90d7f84f2688bd11c85c622d4a_Cells_4_Float);
            float _Power_5fa13e83b0bd4a30948e58d874ec8e1c_Out_2_Float;
            Unity_Power_float(_Voronoi_49347d90d7f84f2688bd11c85c622d4a_Out_3_Float, float(5), _Power_5fa13e83b0bd4a30948e58d874ec8e1c_Out_2_Float);
            float4 _Multiply_71f563a2f0994124a41103b119f6ef23_Out_2_Vector4;
            Unity_Multiply_float4_float4(_Property_d1a487fb48c74645a6287a2efe9e84ec_Out_0_Vector4, (_Power_5fa13e83b0bd4a30948e58d874ec8e1c_Out_2_Float.xxxx), _Multiply_71f563a2f0994124a41103b119f6ef23_Out_2_Vector4);
            float4 _Multiply_6366b6f890e24726a301b5317d8cca7f_Out_2_Vector4;
            Unity_Multiply_float4_float4((_Saturate_aec1f9a3c440421da2b762a373cb90af_Out_1_Float.xxxx), _Multiply_71f563a2f0994124a41103b119f6ef23_Out_2_Vector4, _Multiply_6366b6f890e24726a301b5317d8cca7f_Out_2_Vector4);
            float4 _Add_ecc8b0b6f3da4501b6a1866fd0669de6_Out_2_Vector4;
            Unity_Add_float4(_Property_671d70dd5da140ee96643d243dc37fd8_Out_0_Vector4, _Multiply_6366b6f890e24726a301b5317d8cca7f_Out_2_Vector4, _Add_ecc8b0b6f3da4501b6a1866fd0669de6_Out_2_Vector4);
            float4 _Property_487ab90812634ee7a3ee5e7286c31b37_Out_0_Vector4 = _FoamColor;
            float _Property_f098ae14b87349b18021704e4796e375_Out_0_Float = _FoamAmount;
            Bindings_DepthFade_8bbfe621c0368244b80a10cdd14cd70e_float _DepthFade_e9f6efdeeea748d5b9489cb9356db947;
            _DepthFade_e9f6efdeeea748d5b9489cb9356db947.ScreenPosition = IN.ScreenPosition;
            _DepthFade_e9f6efdeeea748d5b9489cb9356db947.NDCPosition = IN.NDCPosition;
            float _DepthFade_e9f6efdeeea748d5b9489cb9356db947_Out_1_Float;
            SG_DepthFade_8bbfe621c0368244b80a10cdd14cd70e_float(_Property_f098ae14b87349b18021704e4796e375_Out_0_Float, _DepthFade_e9f6efdeeea748d5b9489cb9356db947, _DepthFade_e9f6efdeeea748d5b9489cb9356db947_Out_1_Float);
            float _Property_a7ccaf84ea904aef93f7567d05a08c53_Out_0_Float = _FoamCutoff;
            float _Multiply_8e97f0c830a94fe1b9f69046189ad20f_Out_2_Float;
            Unity_Multiply_float_float(_DepthFade_e9f6efdeeea748d5b9489cb9356db947_Out_1_Float, _Property_a7ccaf84ea904aef93f7567d05a08c53_Out_0_Float, _Multiply_8e97f0c830a94fe1b9f69046189ad20f_Out_2_Float);
            float _Property_8aa776c9bffc482a9b793dcf9b21ade8_Out_0_Float = _FoamScale;
            float _GradientNoise_f2a772e9e9de4969aef9721d103f92f8_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_c6acd5a2b68d4f079820e39856a12d58_Out_3_Vector2, _Property_8aa776c9bffc482a9b793dcf9b21ade8_Out_0_Float, _GradientNoise_f2a772e9e9de4969aef9721d103f92f8_Out_2_Float);
            float _Step_56ca35ee6ad74a8884e66e97609c8aa2_Out_2_Float;
            Unity_Step_float(_Multiply_8e97f0c830a94fe1b9f69046189ad20f_Out_2_Float, _GradientNoise_f2a772e9e9de4969aef9721d103f92f8_Out_2_Float, _Step_56ca35ee6ad74a8884e66e97609c8aa2_Out_2_Float);
            float4 _Lerp_de94925a336f44d3a6ce9a0e9dc95dd0_Out_3_Vector4;
            Unity_Lerp_float4(_Add_ecc8b0b6f3da4501b6a1866fd0669de6_Out_2_Vector4, _Property_487ab90812634ee7a3ee5e7286c31b37_Out_0_Vector4, (_Step_56ca35ee6ad74a8884e66e97609c8aa2_Out_2_Float.xxxx), _Lerp_de94925a336f44d3a6ce9a0e9dc95dd0_Out_3_Vector4);
            float4 _Property_77b93701aebc4074baeea8507b1154c7_Out_0_Vector4 = _RippleColor;
            float _Property_6d3446e5f668442b98fa00a4f2586995_Out_0_Float = _Frequency;
            float _Property_1dfb9c72b1914f8ba792ea320d9c44f9_Out_0_Float = _RippleDuration;
            float _Property_257bf14bacfe4c9f9c21df39ebc817be_Out_0_Float = _RippleSpeed;
            float _RippleFunctionCustomFunction_e7bd970bd8964ae5a69f01acec2bce3c_result_0_Float;
            RippleFunction_float(_Vector2_aacd28bdf4cf4521b9d76e9dbe00d1e0_Out_0_Vector2, IN.TimeParameters.x, _Property_6d3446e5f668442b98fa00a4f2586995_Out_0_Float, _Property_1dfb9c72b1914f8ba792ea320d9c44f9_Out_0_Float, _Property_257bf14bacfe4c9f9c21df39ebc817be_Out_0_Float, _RippleFunctionCustomFunction_e7bd970bd8964ae5a69f01acec2bce3c_result_0_Float);
            float4 _Lerp_b21bf96f73c1465eb973600089828e31_Out_3_Vector4;
            Unity_Lerp_float4(_Lerp_de94925a336f44d3a6ce9a0e9dc95dd0_Out_3_Vector4, _Property_77b93701aebc4074baeea8507b1154c7_Out_0_Vector4, (_RippleFunctionCustomFunction_e7bd970bd8964ae5a69f01acec2bce3c_result_0_Float.xxxx), _Lerp_b21bf96f73c1465eb973600089828e31_Out_3_Vector4);
            surface.BaseColor = (_Lerp_b21bf96f73c1465eb973600089828e31_Out_3_Vector4.xyz);
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.WorldSpacePosition =                         TransformObjectToWorld(input.positionOS);
            output.TimeParameters =                             _TimeParameters.xyz;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        
            #if UNITY_UV_STARTS_AT_TOP
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #else
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #endif
        
            output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
            output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
            output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SelectionPickingPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "Universal 2D"
            Tags
            {
                "LightMode" = "Universal2D"
            }
        
        // Render State
        Cull Back
        Blend One Zero
        ZTest LEqual
        ZWrite On
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define GRAPH_VERTEX_USES_TIME_PARAMETERS_INPUT
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_POSITION_WS
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_2D
        #define REQUIRE_DEPTH_TEXTURE
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float2 NDCPosition;
             float2 PixelPosition;
             float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float3 WorldSpacePosition;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS : INTERP0;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.positionWS.xyz = input.positionWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.positionWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _PatternSpeed;
        float _FlowSpeed;
        float2 _FlowDirection;
        float _WaveSpread;
        float _WaveHeight;
        float _WaveSpeed;
        float _Scale;
        float _PatternDensity;
        float4 _WaterColor;
        float4 _PatternColor;
        float _FoamScale;
        float _FoamAmount;
        float _FoamCutoff;
        float4 _FoamColor;
        float _PatternCutoff;
        float _Frequency;
        float4 _RippleColor;
        float _RippleDuration;
        float _RippleSpeed;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        
        // Graph Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
        #include_with_pragmas "Assets/Water/RippleFunction.hlsl"
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Divide_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A / B;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        float2 Unity_GradientNoise_Deterministic_Dir_float(float2 p)
        {
            float x; Hash_Tchou_2_1_float(p, x);
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_Deterministic_float (float2 UV, float3 Scale, out float Out)
        {
            float2 p = UV * Scale.xy;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_Distance_float3(float3 A, float3 B, out float Out)
        {
            Out = distance(A, B);
        }
        
        void Unity_InverseLerp_float(float A, float B, float T, out float Out)
        {
            Out = (T - A)/(B - A);
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        float2 Unity_Voronoi_RandomVector_Deterministic_float (float2 UV, float offset)
        {
            Hash_Tchou_2_2_float(UV, UV);
            return float2(sin(UV.y * offset), cos(UV.x * offset)) * 0.5 + 0.5;
        }
        
        void Unity_Voronoi_Deterministic_float(float2 UV, float AngleOffset, float CellDensity, out float Out, out float Cells)
        {
            float2 g = floor(UV * CellDensity);
            float2 f = frac(UV * CellDensity);
            float t = 8.0;
            float3 res = float3(8.0, 0.0, 0.0);
            for (int y = -1; y <= 1; y++)
            {
                for (int x = -1; x <= 1; x++)
                {
                    float2 lattice = float2(x, y);
                    float2 offset = Unity_Voronoi_RandomVector_Deterministic_float(lattice + g, AngleOffset);
                    float d = distance(lattice + offset, f);
                    if (d < res.x)
                    {
                        res = float3(d, offset.x, offset.y);
                        Out = res.x;
                        Cells = res.y;
                    }
                }
            }
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_Add_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A + B;
        }
        
        void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
        {
            if (unity_OrthoParams.w == 1.0)
            {
                Out = LinearEyeDepth(ComputeWorldSpacePosition(UV.xy, SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), UNITY_MATRIX_I_VP), UNITY_MATRIX_V);
            }
            else
            {
                Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
            }
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        struct Bindings_DepthFade_8bbfe621c0368244b80a10cdd14cd70e_float
        {
        float4 ScreenPosition;
        float2 NDCPosition;
        };
        
        void SG_DepthFade_8bbfe621c0368244b80a10cdd14cd70e_float(float _Distance, Bindings_DepthFade_8bbfe621c0368244b80a10cdd14cd70e_float IN, out float Out_1)
        {
        float _SceneDepth_2eb96c52a24a4558b37a5f543bc363b1_Out_1_Float;
        Unity_SceneDepth_Eye_float(float4(IN.NDCPosition.xy, 0, 0), _SceneDepth_2eb96c52a24a4558b37a5f543bc363b1_Out_1_Float);
        float4 _ScreenPosition_4c9380fe7a70484c8beb74b5792bdbc8_Out_0_Vector4 = IN.ScreenPosition;
        float _Split_9c58755aea204a38a422f36c78e4d894_R_1_Float = _ScreenPosition_4c9380fe7a70484c8beb74b5792bdbc8_Out_0_Vector4[0];
        float _Split_9c58755aea204a38a422f36c78e4d894_G_2_Float = _ScreenPosition_4c9380fe7a70484c8beb74b5792bdbc8_Out_0_Vector4[1];
        float _Split_9c58755aea204a38a422f36c78e4d894_B_3_Float = _ScreenPosition_4c9380fe7a70484c8beb74b5792bdbc8_Out_0_Vector4[2];
        float _Split_9c58755aea204a38a422f36c78e4d894_A_4_Float = _ScreenPosition_4c9380fe7a70484c8beb74b5792bdbc8_Out_0_Vector4[3];
        float _Subtract_4b0c684883d8435c9e6d251f76545c9a_Out_2_Float;
        Unity_Subtract_float(_SceneDepth_2eb96c52a24a4558b37a5f543bc363b1_Out_1_Float, _Split_9c58755aea204a38a422f36c78e4d894_A_4_Float, _Subtract_4b0c684883d8435c9e6d251f76545c9a_Out_2_Float);
        float _Property_71a843c8a2ad403b8140354c6a881afd_Out_0_Float = _Distance;
        float _Divide_6a045dbede5f44819286797f917918ac_Out_2_Float;
        Unity_Divide_float(_Subtract_4b0c684883d8435c9e6d251f76545c9a_Out_2_Float, _Property_71a843c8a2ad403b8140354c6a881afd_Out_0_Float, _Divide_6a045dbede5f44819286797f917918ac_Out_2_Float);
        float _Saturate_f45f6fa4775044429c760084824ef684_Out_1_Float;
        Unity_Saturate_float(_Divide_6a045dbede5f44819286797f917918ac_Out_2_Float, _Saturate_f45f6fa4775044429c760084824ef684_Out_1_Float);
        Out_1 = _Saturate_f45f6fa4775044429c760084824ef684_Out_1_Float;
        }
        
        void Unity_Step_float(float Edge, float In, out float Out)
        {
            Out = step(Edge, In);
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Property_d27cf8a7dad34ecd96496a2e168a017f_Out_0_Float = _WaveHeight;
            float _Split_a4a9df004cc4457ab200382a084abebd_R_1_Float = IN.WorldSpacePosition[0];
            float _Split_a4a9df004cc4457ab200382a084abebd_G_2_Float = IN.WorldSpacePosition[1];
            float _Split_a4a9df004cc4457ab200382a084abebd_B_3_Float = IN.WorldSpacePosition[2];
            float _Split_a4a9df004cc4457ab200382a084abebd_A_4_Float = 0;
            float2 _Vector2_2a9c14ca8f744a208e525959dee4a260_Out_0_Vector2 = float2(_Split_a4a9df004cc4457ab200382a084abebd_R_1_Float, _Split_a4a9df004cc4457ab200382a084abebd_B_3_Float);
            float _Property_19f075486b9748cda9e8985ad901e546_Out_0_Float = _Scale;
            float2 _Divide_18910aaaf2724bc18f244ce72424925b_Out_2_Vector2;
            Unity_Divide_float2(_Vector2_2a9c14ca8f744a208e525959dee4a260_Out_0_Vector2, (_Property_19f075486b9748cda9e8985ad901e546_Out_0_Float.xx), _Divide_18910aaaf2724bc18f244ce72424925b_Out_2_Vector2);
            float2 _Property_54fb6e94cfc349049bf82b6de2a35e4d_Out_0_Vector2 = _FlowDirection;
            float _Property_62bb68af8ede43f6a392167fdaca1c04_Out_0_Float = _WaveSpeed;
            float _Multiply_fa246fa412f543c18db54cbf79b06304_Out_2_Float;
            Unity_Multiply_float_float(_Property_62bb68af8ede43f6a392167fdaca1c04_Out_0_Float, IN.TimeParameters.x, _Multiply_fa246fa412f543c18db54cbf79b06304_Out_2_Float);
            float2 _Multiply_7e3f5e405dcb43cb9d5c7f6b2de9ddbd_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Property_54fb6e94cfc349049bf82b6de2a35e4d_Out_0_Vector2, (_Multiply_fa246fa412f543c18db54cbf79b06304_Out_2_Float.xx), _Multiply_7e3f5e405dcb43cb9d5c7f6b2de9ddbd_Out_2_Vector2);
            float2 _TilingAndOffset_07da4fb4f18642ef83ac45f44e00d13a_Out_3_Vector2;
            Unity_TilingAndOffset_float(_Divide_18910aaaf2724bc18f244ce72424925b_Out_2_Vector2, float2 (1, 1), _Multiply_7e3f5e405dcb43cb9d5c7f6b2de9ddbd_Out_2_Vector2, _TilingAndOffset_07da4fb4f18642ef83ac45f44e00d13a_Out_3_Vector2);
            float _Property_197bb7e4b1d5495a848b56f391c3ca94_Out_0_Float = _WaveSpread;
            float _GradientNoise_c4a6176d4d8e46c98e887e141f128ace_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_07da4fb4f18642ef83ac45f44e00d13a_Out_3_Vector2, _Property_197bb7e4b1d5495a848b56f391c3ca94_Out_0_Float, _GradientNoise_c4a6176d4d8e46c98e887e141f128ace_Out_2_Float);
            float _OneMinus_5666200d4b784081927194d399b19546_Out_1_Float;
            Unity_OneMinus_float(_GradientNoise_c4a6176d4d8e46c98e887e141f128ace_Out_2_Float, _OneMinus_5666200d4b784081927194d399b19546_Out_1_Float);
            float _Remap_df0e169dec134e1494011460992d4857_Out_3_Float;
            Unity_Remap_float(_OneMinus_5666200d4b784081927194d399b19546_Out_1_Float, float2 (0, 1), float2 (-1, 1), _Remap_df0e169dec134e1494011460992d4857_Out_3_Float);
            float _Multiply_21e2fe9741664562a375c951fee94e29_Out_2_Float;
            Unity_Multiply_float_float(_Property_d27cf8a7dad34ecd96496a2e168a017f_Out_0_Float, _Remap_df0e169dec134e1494011460992d4857_Out_3_Float, _Multiply_21e2fe9741664562a375c951fee94e29_Out_2_Float);
            float3 _Multiply_1bca5d8c2e8b4f69965496a79b732a5e_Out_2_Vector3;
            Unity_Multiply_float3_float3(IN.ObjectSpaceNormal, (_Multiply_21e2fe9741664562a375c951fee94e29_Out_2_Float.xxx), _Multiply_1bca5d8c2e8b4f69965496a79b732a5e_Out_2_Vector3);
            float3 _Add_8792ee7fc1774e53b8df716cea19ceeb_Out_2_Vector3;
            Unity_Add_float3(_Multiply_1bca5d8c2e8b4f69965496a79b732a5e_Out_2_Vector3, IN.ObjectSpacePosition, _Add_8792ee7fc1774e53b8df716cea19ceeb_Out_2_Vector3);
            description.Position = _Add_8792ee7fc1774e53b8df716cea19ceeb_Out_2_Vector3;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _Property_671d70dd5da140ee96643d243dc37fd8_Out_0_Vector4 = _WaterColor;
            float _Property_dad906e3a15845749abaee1638b45450_Out_0_Float = _PatternCutoff;
            float _Distance_cc5c484eebf44373a1398dd7e1ff845c_Out_2_Float;
            Unity_Distance_float3(IN.WorldSpacePosition, _WorldSpaceCameraPos, _Distance_cc5c484eebf44373a1398dd7e1ff845c_Out_2_Float);
            float _InverseLerp_a4e53d21ad914646bd2fa3203824b74a_Out_3_Float;
            Unity_InverseLerp_float(_Property_dad906e3a15845749abaee1638b45450_Out_0_Float, float(0), _Distance_cc5c484eebf44373a1398dd7e1ff845c_Out_2_Float, _InverseLerp_a4e53d21ad914646bd2fa3203824b74a_Out_3_Float);
            float _Saturate_aec1f9a3c440421da2b762a373cb90af_Out_1_Float;
            Unity_Saturate_float(_InverseLerp_a4e53d21ad914646bd2fa3203824b74a_Out_3_Float, _Saturate_aec1f9a3c440421da2b762a373cb90af_Out_1_Float);
            float4 _Property_d1a487fb48c74645a6287a2efe9e84ec_Out_0_Vector4 = IsGammaSpace() ? LinearToSRGB(_PatternColor) : _PatternColor;
            float _Split_6514885e4bf748d7a415566148d27785_R_1_Float = IN.WorldSpacePosition[0];
            float _Split_6514885e4bf748d7a415566148d27785_G_2_Float = IN.WorldSpacePosition[1];
            float _Split_6514885e4bf748d7a415566148d27785_B_3_Float = IN.WorldSpacePosition[2];
            float _Split_6514885e4bf748d7a415566148d27785_A_4_Float = 0;
            float2 _Vector2_aacd28bdf4cf4521b9d76e9dbe00d1e0_Out_0_Vector2 = float2(_Split_6514885e4bf748d7a415566148d27785_R_1_Float, _Split_6514885e4bf748d7a415566148d27785_B_3_Float);
            float _Property_35d111bad030402bbf4b94caac81b7f5_Out_0_Float = _Scale;
            float2 _Divide_72c033936cee42ee80147ea81c9d2ecf_Out_2_Vector2;
            Unity_Divide_float2(_Vector2_aacd28bdf4cf4521b9d76e9dbe00d1e0_Out_0_Vector2, (_Property_35d111bad030402bbf4b94caac81b7f5_Out_0_Float.xx), _Divide_72c033936cee42ee80147ea81c9d2ecf_Out_2_Vector2);
            float2 _Property_3ee92cea9de142c296a1467413ffd108_Out_0_Vector2 = _FlowDirection;
            float _Property_47d6f34367a74d388cde1a2ecaf6ccda_Out_0_Float = _FlowSpeed;
            float _Multiply_979a08f5be6e43a7ac018afb58904b04_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_47d6f34367a74d388cde1a2ecaf6ccda_Out_0_Float, _Multiply_979a08f5be6e43a7ac018afb58904b04_Out_2_Float);
            float2 _Multiply_c26278cacbce4cb1a639bf0229ed4f3b_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Property_3ee92cea9de142c296a1467413ffd108_Out_0_Vector2, (_Multiply_979a08f5be6e43a7ac018afb58904b04_Out_2_Float.xx), _Multiply_c26278cacbce4cb1a639bf0229ed4f3b_Out_2_Vector2);
            float2 _TilingAndOffset_c6acd5a2b68d4f079820e39856a12d58_Out_3_Vector2;
            Unity_TilingAndOffset_float(_Divide_72c033936cee42ee80147ea81c9d2ecf_Out_2_Vector2, float2 (1, 1), _Multiply_c26278cacbce4cb1a639bf0229ed4f3b_Out_2_Vector2, _TilingAndOffset_c6acd5a2b68d4f079820e39856a12d58_Out_3_Vector2);
            float _Property_17027e778cf54529aae8b565ff3e1f98_Out_0_Float = _PatternSpeed;
            float _Multiply_b502ebc2c57440149af34fae45d33914_Out_2_Float;
            Unity_Multiply_float_float(_Property_17027e778cf54529aae8b565ff3e1f98_Out_0_Float, IN.TimeParameters.x, _Multiply_b502ebc2c57440149af34fae45d33914_Out_2_Float);
            float _Property_3f313ed937e5421a92aa2eed66441c05_Out_0_Float = _PatternDensity;
            float _Voronoi_49347d90d7f84f2688bd11c85c622d4a_Out_3_Float;
            float _Voronoi_49347d90d7f84f2688bd11c85c622d4a_Cells_4_Float;
            Unity_Voronoi_Deterministic_float(_TilingAndOffset_c6acd5a2b68d4f079820e39856a12d58_Out_3_Vector2, _Multiply_b502ebc2c57440149af34fae45d33914_Out_2_Float, _Property_3f313ed937e5421a92aa2eed66441c05_Out_0_Float, _Voronoi_49347d90d7f84f2688bd11c85c622d4a_Out_3_Float, _Voronoi_49347d90d7f84f2688bd11c85c622d4a_Cells_4_Float);
            float _Power_5fa13e83b0bd4a30948e58d874ec8e1c_Out_2_Float;
            Unity_Power_float(_Voronoi_49347d90d7f84f2688bd11c85c622d4a_Out_3_Float, float(5), _Power_5fa13e83b0bd4a30948e58d874ec8e1c_Out_2_Float);
            float4 _Multiply_71f563a2f0994124a41103b119f6ef23_Out_2_Vector4;
            Unity_Multiply_float4_float4(_Property_d1a487fb48c74645a6287a2efe9e84ec_Out_0_Vector4, (_Power_5fa13e83b0bd4a30948e58d874ec8e1c_Out_2_Float.xxxx), _Multiply_71f563a2f0994124a41103b119f6ef23_Out_2_Vector4);
            float4 _Multiply_6366b6f890e24726a301b5317d8cca7f_Out_2_Vector4;
            Unity_Multiply_float4_float4((_Saturate_aec1f9a3c440421da2b762a373cb90af_Out_1_Float.xxxx), _Multiply_71f563a2f0994124a41103b119f6ef23_Out_2_Vector4, _Multiply_6366b6f890e24726a301b5317d8cca7f_Out_2_Vector4);
            float4 _Add_ecc8b0b6f3da4501b6a1866fd0669de6_Out_2_Vector4;
            Unity_Add_float4(_Property_671d70dd5da140ee96643d243dc37fd8_Out_0_Vector4, _Multiply_6366b6f890e24726a301b5317d8cca7f_Out_2_Vector4, _Add_ecc8b0b6f3da4501b6a1866fd0669de6_Out_2_Vector4);
            float4 _Property_487ab90812634ee7a3ee5e7286c31b37_Out_0_Vector4 = _FoamColor;
            float _Property_f098ae14b87349b18021704e4796e375_Out_0_Float = _FoamAmount;
            Bindings_DepthFade_8bbfe621c0368244b80a10cdd14cd70e_float _DepthFade_e9f6efdeeea748d5b9489cb9356db947;
            _DepthFade_e9f6efdeeea748d5b9489cb9356db947.ScreenPosition = IN.ScreenPosition;
            _DepthFade_e9f6efdeeea748d5b9489cb9356db947.NDCPosition = IN.NDCPosition;
            float _DepthFade_e9f6efdeeea748d5b9489cb9356db947_Out_1_Float;
            SG_DepthFade_8bbfe621c0368244b80a10cdd14cd70e_float(_Property_f098ae14b87349b18021704e4796e375_Out_0_Float, _DepthFade_e9f6efdeeea748d5b9489cb9356db947, _DepthFade_e9f6efdeeea748d5b9489cb9356db947_Out_1_Float);
            float _Property_a7ccaf84ea904aef93f7567d05a08c53_Out_0_Float = _FoamCutoff;
            float _Multiply_8e97f0c830a94fe1b9f69046189ad20f_Out_2_Float;
            Unity_Multiply_float_float(_DepthFade_e9f6efdeeea748d5b9489cb9356db947_Out_1_Float, _Property_a7ccaf84ea904aef93f7567d05a08c53_Out_0_Float, _Multiply_8e97f0c830a94fe1b9f69046189ad20f_Out_2_Float);
            float _Property_8aa776c9bffc482a9b793dcf9b21ade8_Out_0_Float = _FoamScale;
            float _GradientNoise_f2a772e9e9de4969aef9721d103f92f8_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_c6acd5a2b68d4f079820e39856a12d58_Out_3_Vector2, _Property_8aa776c9bffc482a9b793dcf9b21ade8_Out_0_Float, _GradientNoise_f2a772e9e9de4969aef9721d103f92f8_Out_2_Float);
            float _Step_56ca35ee6ad74a8884e66e97609c8aa2_Out_2_Float;
            Unity_Step_float(_Multiply_8e97f0c830a94fe1b9f69046189ad20f_Out_2_Float, _GradientNoise_f2a772e9e9de4969aef9721d103f92f8_Out_2_Float, _Step_56ca35ee6ad74a8884e66e97609c8aa2_Out_2_Float);
            float4 _Lerp_de94925a336f44d3a6ce9a0e9dc95dd0_Out_3_Vector4;
            Unity_Lerp_float4(_Add_ecc8b0b6f3da4501b6a1866fd0669de6_Out_2_Vector4, _Property_487ab90812634ee7a3ee5e7286c31b37_Out_0_Vector4, (_Step_56ca35ee6ad74a8884e66e97609c8aa2_Out_2_Float.xxxx), _Lerp_de94925a336f44d3a6ce9a0e9dc95dd0_Out_3_Vector4);
            float4 _Property_77b93701aebc4074baeea8507b1154c7_Out_0_Vector4 = _RippleColor;
            float _Property_6d3446e5f668442b98fa00a4f2586995_Out_0_Float = _Frequency;
            float _Property_1dfb9c72b1914f8ba792ea320d9c44f9_Out_0_Float = _RippleDuration;
            float _Property_257bf14bacfe4c9f9c21df39ebc817be_Out_0_Float = _RippleSpeed;
            float _RippleFunctionCustomFunction_e7bd970bd8964ae5a69f01acec2bce3c_result_0_Float;
            RippleFunction_float(_Vector2_aacd28bdf4cf4521b9d76e9dbe00d1e0_Out_0_Vector2, IN.TimeParameters.x, _Property_6d3446e5f668442b98fa00a4f2586995_Out_0_Float, _Property_1dfb9c72b1914f8ba792ea320d9c44f9_Out_0_Float, _Property_257bf14bacfe4c9f9c21df39ebc817be_Out_0_Float, _RippleFunctionCustomFunction_e7bd970bd8964ae5a69f01acec2bce3c_result_0_Float);
            float4 _Lerp_b21bf96f73c1465eb973600089828e31_Out_3_Vector4;
            Unity_Lerp_float4(_Lerp_de94925a336f44d3a6ce9a0e9dc95dd0_Out_3_Vector4, _Property_77b93701aebc4074baeea8507b1154c7_Out_0_Vector4, (_RippleFunctionCustomFunction_e7bd970bd8964ae5a69f01acec2bce3c_result_0_Float.xxxx), _Lerp_b21bf96f73c1465eb973600089828e31_Out_3_Vector4);
            surface.BaseColor = (_Lerp_b21bf96f73c1465eb973600089828e31_Out_3_Vector4.xyz);
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.WorldSpacePosition =                         TransformObjectToWorld(input.positionOS);
            output.TimeParameters =                             _TimeParameters.xyz;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        
            #if UNITY_UV_STARTS_AT_TOP
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #else
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #endif
        
            output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
            output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
            output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBR2DPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
    }
    CustomEditor "UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI"
    CustomEditorForRenderPipeline "UnityEditor.ShaderGraphLitGUI" "UnityEngine.Rendering.Universal.UniversalRenderPipelineAsset"
    FallBack "Hidden/Shader Graph/FallbackError"
}