Shader "shader/special effects/OutLine"
{
    Properties
    {
        _OutlineColor ("Outline Color", Color) = (1,0,0,1)
        _OutlineWidth ("Outline Width", Range(0, 1)) = 0.1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        // 第一个 Pass 用于渲染描边
        Pass
        {
            Cull Front // 剔除正面，只渲染背面用于描边
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            uniform float _OutlineWidth;
            uniform float4 _OutlineColor;
            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };
            struct v2f
            {
                float4 pos : SV_POSITION;
            };
            v2f vert (appdata v)
            {
                v2f o;
                // 将顶点沿法线方向外拓以创建描边
                float3 viewNormal = UnityObjectToViewPos(v.vertex) + v.normal * _OutlineWidth;
                o.pos = UnityViewToClipPos(viewNormal);
                return o;
            }
            fixed4 frag (v2f i) : SV_Target
            {
                return _OutlineColor;
            }
            ENDCG
        }
        // 第二个 Pass 用于正常渲染物体
        Pass
        {
            Cull Back // 正常渲染物体的正面
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            struct appdata
            {
                float4 vertex : POSITION;
            };
            struct v2f
            {
                float4 pos : SV_POSITION;
            };
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                return o;
            }
            fixed4 frag (v2f i) : SV_Target
            {
                return fixed4(1,1,1,1); // 正常颜色，可根据需要修改
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}