Shader "shader/basic/3clo light"{
 Properties {
        _EnvUP ("env up", Color) = (1,1,1,1)
        _EnvDown ("env down", Color) = (0,0,0,1)
        _EnvSide ("env side", Color) = (0.4,0.4,0.4,1)
        _Occlusion ("texue", 2D) = "white" {}
 }
    
    SubShader {
        Tags {
            "RenderType"="Opaque"
        }
        LOD 100
        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }
            
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #pragma multi_compile_fwdbase_fullshadows
            #pragma multi_compile_fog
            #pragma target 3.0
            //输入参数
            uniform float3 _EnvUP;
            uniform float3 _EnvSide;
            uniform float3 _EnvDown;
            uniform sampler2D _Occlusion;
            //输入结构
            struct VertexInput {
                float4 vertex : POSITION;   //将模型顶点信息输入进来
                float3 normal : NORMAL;     //将模型法线信息输入进来
                float2 uv0 : TEXCOORD0;     //将模型uv信息输入进来 0通道 共4通道  
            };
            //输出结构
            struct VertexOutput {
                float4 pos : SV_POSITION;   //由顶点信息换算而来的顶点屏幕位置
                float3 nDirWS : TEXCOORD0;   //由模型法线信息换算而来的世界空间法线信息
                float2 uv : TEXCOORD1;      //将模型信息用像素shader采样贴图       
            };
            //输入结构>>>顶点shader>>>输出结构
            VertexOutput vert (VertexInput v) {
                  VertexOutput o = (VertexOutput)0;             // 新建一个输出结构
                 o.pos = UnityObjectToClipPos( v.vertex );      // 变换顶点信息 并将其塞给输出结构
                 o.nDirWS = UnityObjectToWorldNormal(v.normal); // 变换法线信息 并将其塞给输出结构
                 o.uv = v.uv0;
                 return o;                                      // 将输出结构 输出
            }
            //输出结构>>>像素
            float4 frag(VertexOutput i) : COLOR {
           //准备向量
            float3 nDir = i.nDirWS;                 // 获取nDir
            //计算各部位遮罩
            float UpMask = max(0.0 , nDir.g);
            float DownMask = max(0.0 , -nDir.g);
            float SideMask =  1.0 - UpMask - DownMask;
            //混合环境色
            float3 env = _EnvUP * UpMask + _EnvDown * DownMask + _EnvSide * SideMask;
            //采样贴图
            float occlution = tex2D(_Occlusion, i.uv);
            //计算环境光照
            float3 envlighting = env * occlution;
            //返回最终值
            return float4(envlighting , 1.0);    // 输出最终颜色
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}
