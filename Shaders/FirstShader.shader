// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/FirstShader"
{
    Properties//属性面板，用来说明参数属性
    {
        _Tint ("Color", Color) = (1, 1, 0, 1)
        _MainTex ("Texture", 2D) = "white"{}

    }
    SubShader
    {
        Pass
        {
            CGPROGRAM

            #pragma vertex MyVertexProgram
            #pragma fragment MyFragmentProgram

            #include "UnityCG.cginc"

            //在属性说明的参数需要在Pass中声明才能使用
            float4 _Tint;
            sampler2D _MainTex; 
            float4 _MainTex_ST;//用于设置偏移和缩放，ST是Scale和Transform的意思

            //顶点数据结构
            struct VertexData {
                float4 position : POSITION;//POSITION表示对象本地坐标
                float2 uv : TEXCOORD0;//纹理坐标
            };

            //插值后数据结构
            struct Interpolators {
				float4 position : SV_POSITION;//SV_POSITION指系统的坐标，反正就是要加个语义进去才能使用
				float2 uv : TEXCOORD0;//纹理坐标
			};

            //顶点数据通过顶点程序后进行插值，插值后数据传递给片元程序
            Interpolators MyVertexProgram (VertexData v) {
				Interpolators i;
				i.uv = TRANSFORM_TEX(v.uv, _MainTex);
				i.position = UnityObjectToClipPos(v.position);
				return i;
			}

            //片元程序
			float4 MyFragmentProgram (Interpolators i) : SV_TARGET {
				return tex2D(_MainTex, i.uv);
			}

            // 以下是未使用结构时的代码
            // float4 MyVertexProgram(
            //     float4 position : POSITION, 
            //     out float3 localPosition : TEXCOORD0) : SV_POSITION
            // {
            //     localPosition = position.xyz;
            //     return UnityObjectToClipPos(position);
            // }

            // float4 MyFragmentProgram(
            //     float4 position : POSITION,
            //     float3 localPosition : TEXCOORD0) : SV_TARGET
            // {
            //     return float4(localPosition, 1.0);
            // }

            ENDCG
        }
    }
}