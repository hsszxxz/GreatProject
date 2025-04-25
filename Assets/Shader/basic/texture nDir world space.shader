Shader "shader/basic/texture nDir world space"{

    Properties {
        _NormalMap ("NormalMap", 2D) = "bump" {}
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
            uniform sampler2D _NormalMap;
        
            //输入结构
            struct VertexInput {
                float4 vertex : POSITION;   //将模型顶点信息输入进来
                float3 normal : NORMAL;     //将模型法线信息输入进来
                float4 tangent : TANGENT;
                float2 uv0 : TEXCOORD0;
            };
            
            //输出结构
            struct VertexOutput {
                float4 pos : SV_POSITION;   //由顶点信息换算而来的顶点屏幕位置
                float2 uv0 : TEXCOORD0;
                float3 nDirWS : TEXCOORD1;   //由模型法线信息换算而来的世界空间法线信息
                float3 tDirWS : TEXCOORD2;
                float3 bDirWS : TEXCOORD3;
            };
            //输入结构>>>顶点shader>>>输出结构
            VertexOutput vert (VertexInput v) {
                  VertexOutput o = (VertexOutput)0;             // 新建一个输出结构
                 o.pos = UnityObjectToClipPos( v.vertex );      // 变换顶点信息 并将其塞给输出结构
                 o.nDirWS = UnityObjectToWorldNormal(v.normal); // 变换法线信息 并将其塞给输出结构
                 o.uv0 = v.uv0;
                 o.tDirWS = normalize( mul( unity_ObjectToWorld, float4( v.tangent.xyz, 0.0 ) ).xyz );
                 o.bDirWS = normalize(cross(o.nDirWS, o.tDirWS) * v.tangent.w);
                 return o;                                      // 将输出结构 输出
            }
            //输出结构>>>像素
            float4 frag(VertexOutput i) : COLOR {
            float3 var_NormalMap = UnpackNormal(tex2D(_NormalMap, i.uv0)).rgb; // 采样法线纹理并解码 切线空间nDi
            float3x3 TBN = float3x3(i.tDirWS, i.bDirWS, i.nDirWS); // 构建TBN矩阵
            float3 nDir = normalize(mul(var_NormalMap, TBN)); // 世界空间nDir
            float3 lDir = _WorldSpaceLightPos0.xyz; // 获取lDir
            float nDotl = dot(nDir, lDir);      // nDir点积lDir
            float halflambert = nDotl * 0.5 + 0.5;       // 映射到0~1
            return float4(halflambert, halflambert, halflambert, 1.0);    // 输出最终颜色
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}
