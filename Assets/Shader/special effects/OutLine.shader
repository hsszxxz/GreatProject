Shader "shader/special effects/OutLine"
{
    Properties
    {
        
        [Header(OutLine)]
        _OutlineColor ("外描边颜色", Color) = (0,0,0,1)
        _OutlineWidth ("外描边宽度", Range(0, 1)) = 0.01
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        // 第一个 Pass 用于渲染描边
        Pass
        {
            
            Name "OutLinePass"
            Tags {
                "LightMode"="ForwardBase"
            }
            Cull Front

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #pragma multi_compile_fwdbase_fullshadows
            #pragma multi_compile_fog
            #pragma target 3.0
            //输入参数
            uniform half _OutlineWidth;
            uniform half4 _OutlineColor;

            //输入结构
            struct VertexInput {
                float4 vertex : POSITION;   //将模型顶点信息输入进来
                float4 normal : NORMAL;    //  获取法线
                float2 uv0 : TEXCOORD0;           //采样贴图用
            };
            //输出结构
            struct VertexOutput {
                float4 pos : SV_POSITION;   //由顶点信息换算而来的顶点屏幕位置
                float2 uv0 : TEXCOORD0;           //采样贴图用
            };
            //输入结构>>>顶点shader>>>输出结构
            VertexOutput vert (VertexInput v) {
                  VertexOutput o = (VertexOutput)0;             // 新建一个输出结构
                 v.vertex.xyz += v.normal*_OutlineWidth;        //利用法线挤出顶点，关联参数面板控制挤出大小
                 o.pos = UnityObjectToClipPos( v.vertex );      // 变换顶点信息 并将其塞给输出结构，顶点位置OS>CS
                 return o;                                      // 将输出结构 输出
            }
            //输出结构>>>像素
            half4 frag(VertexOutput i) : COLOR {
            return _OutlineColor ;
            }
            ENDCG
        }
       
    }
    FallBack "Diffuse"
}