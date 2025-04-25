Shader "shader/special effects/ab " {
    Properties {
        _MainTex("RGB:基本颜色,A:透贴",2d) = "gray"{}
        _Cutoff("透切阈值",range(0.0,1.0)) = 0.5
    }
    SubShader {
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
            uniform sampler2D _MainTex; uniform float4 _MainTex_ST;
            uniform half _Cutoff;
            //输入结构
            struct VertexInput {
                float4 vertex : POSITION;   //将模型顶点信息输入进来
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
                 o.pos = UnityObjectToClipPos( v.vertex );      // 变换顶点信息 并将其塞给输出结构，顶点位置OS>CS
                 o.uv0=TRANSFORM_TEX(v.uv0,_MainTex);             // UV信息支持TilingOffset
                 return o;                                      // 将输出结构 输出
            }
            //输出结构>>>像素
            half4 frag(VertexOutput i) : COLOR {
            half4 var_MainTex=tex2D(_MainTex,i.uv0);  //采样贴图RGB:基本颜色,A:透贴
            half opacity = var_MainTex.a;
            clip(_Cutoff - opacity);
            return half4(var_MainTex.rgb, 1.0);    // 输出最终颜色
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}
