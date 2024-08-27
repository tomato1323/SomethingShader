Shader "Unlit/T"
{
    Properties
    {
        [HideInInspector]_MainTex ("Texture", 2D) = "white" {}
        _ColorA ("Color A", Color) = (0, 0, 0, 1)
        _ColorB ("Color B", Color) = (1, 1, 1, 1)
        _NumA ("Circle Thickness", Float) = 0.0
        _NumB ("Circle Number", Float) = 0.0
        _Smooth ("Smooth", Range(0.0, 1.0)) = 0.0
        _Speed ("Speed", Range(-10.0, 10.0)) = 1.0
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue" = "Transparent"}
        Blend SrcAlpha OneMinusSrcAlpha
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
            float _NumA;
            float _NumB;
            float _Smooth;
            float _Speed;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                //-Ichimatu-
                //fixed2 v = step(0, sin(_NumB*i.uv + (_Time * _Speed)))*_NumA;
                //return lerp(_ColorA, _ColorB, frac(v.x + v.y) * 2);

                //Circle
                fixed len = distance(i.uv, fixed2(0.5, 0.5)) + (_Time * _Speed);
                return lerp(_ColorA, _ColorB, smoothstep(_NumA, _Smooth, sin(len*_NumB)));
            }
            ENDCG
        }
    }
}
