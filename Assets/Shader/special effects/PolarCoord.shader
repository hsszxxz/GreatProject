Shader "shader/special effects/PolarCoord"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Opacity("透明度",range(0.0,1.0)) = 0.5
        [HDR]_Color("color",Color) = (1.0,1.0,1.0,1.0)
    }
    SubShader
    {
        Tags { 
                "Queue"="Transparent"//调整渲染顺序
                "RenderType"="Transparent"//对应改为Cutout 
                "ForceNoShadowCasting"="True"//关闭阴影投射
                "IgnoreProjector"="True"//不响应投射器
         }
        LOD 100

        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }
            Blend One OneMinusSrcAlpha //修改混合方式One/SrcAlphaOneMinusSrcAlpha

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #pragma multi_compile_fwdbase_fullshadows
            #pragma multi_compile_fog
            #pragma target 3.0
            //输入参数
            uniform sampler2D _MainTex; 
            uniform half _Opacity;
            uniform half4 _Color;
            

            //输入结构
            struct VertexInput {
                float4 vertex :POSITION;   //将模型顶点信息输入进来
                float2 uv0 : TEXCOORD0;           //采样贴图用
                float4 color :COLOR;             //顶点色
            };
            //输出结构
            struct VertexOutput {
                float4 pos : SV_POSITION;   //由顶点信息换算而来的顶点屏幕位置
                float2 uv0 : TEXCOORD0;           //采样贴图用
                float color : COLOR;
            };
            //输入结构>>>顶点shader>>>输出结构
            VertexOutput vert (VertexInput v) {
                  VertexOutput o = (VertexOutput)0;             // 新建一个输出结构
                 o.pos = UnityObjectToClipPos( v.vertex );      // 变换顶点信息 并将其塞给输出结构，顶点位置OS>CS
                 o.uv0= v.uv0;                                   
                 o.color = v.color;
                 return o;                                        // 将输出结构 输出
            }
            //输出结构>>>像素
            half4 frag(VertexOutput i) : COLOR {

            i.uv0 = i.uv0 - float2(0.5,0.5);
            float theta = atan2(i.uv0.y , i.uv0.x);
            theta = theta / 3.1415926 * 0.5 +0.5;
            float r = length(i.uv0) + frac(_Time.x*3);
            i.uv0 = float2(theta , r);  

            half4 var_MainTex = tex2D(_MainTex, i.uv0); // 采样贴图 RGB颜色 A透贴
            half3 finalRGB = (1-var_MainTex.rgb)*_Color;
            half opacity = (1-var_MainTex.r) * _Opacity * i.color.r;
            return half4(finalRGB * opacity, opacity);
            }
            ENDCG
        }
    }
}
