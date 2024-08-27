Shader "Unlit/Block"
{
    Properties
    {
        [HideInInspector]_MainTex ("Texture", 2D) = "white" {}
        _ColorA ("ColorA", Color) = (0.0, 0.0, 0.0, 1.0)
        _ColorB ("ColorB", Color) = (1.0, 1.0, 1.0, 1.0)
        _Num ("Number", float) = 10.0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            float4 _ColorA;
            float4 _ColorB;
            int _Num;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            float box(float2 st, float size)
            {
                size = 0.5 + size * 0.5;
                st = step(st,size) * step(1.0 - st, size);
                return st.x * st.y;
            }

            float wave(float2 st, float n)
            {
                st = (floor(st * n) + 0.5)/ n;
                float d = distance(0.5, st);
                return (1 + sin(d * 3 - _Time.y * 3)) * 0.5;
            }

            float box_wave(float2 uv, float n)
            {
                float2 st = frac(uv * n);
                float size = wave(uv, n);
                return box(st, size);
            }

            fixed4 frag (v2f i) : SV_Target
            {
                //return lerp(_ColorA, _ColorB, box_wave(i.uv, _Num));
                return float4(
                    box_wave(i.uv, _Num),
                    box_wave(i.uv, _Num * 2),
                    box_wave(i.uv, _Num * 4),
                    1);
            }
            ENDCG
        }
    }
}
