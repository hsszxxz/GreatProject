Shader "shader/basic/halflambert binpong (old school)" {
    Properties {
        _MainCol ("颜色", color) = (1.0, 1.0, 1.0, 1.0)
        _SpecularPow ("高光次幂", range(1, 90)) = 30
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
            uniform float3 _MainCol;
            uniform float _SpecularPow;
            //输入结构
            struct VertexInput {
                float4 vertex : POSITION;   //将模型顶点信息输入进来
                float3 normal : NORMAL;     //将模型法线信息输入进来
            };
            //输出结构
            struct VertexOutput {
                float4 posCS :  SV_POSITION;   //裁剪空间
                float4 posWS :  TEXCOORD0;   //由顶点信息换算而来的顶点屏幕位置
                float3 nDirWS : TEXCOORD1;   //由模型法线信息换算而来的世界空间法线信息
            };
            //输入结构>>>顶点shader>>>输出结构
            VertexOutput vert (VertexInput v) {
                  VertexOutput o = (VertexOutput)0;             // 新建一个输出结构
                 o.posCS = UnityObjectToClipPos( v.vertex );      // 变换顶点信息 并将其塞给输出结构
                 o.posWS = mul(unity_ObjectToWorld, v.vertex);  // 变换顶点位置 OS>WS
                 o.nDirWS = UnityObjectToWorldNormal(v.normal); // 变换法线信息 并将其塞给输出结构
                 return o;                                      // 将输出结构 输出
            }
            //输出结构>>>像素
            float4 frag(VertexOutput i) : COLOR {
            //准备向量
            float3 nDir = i.nDirWS;
            float3 lDir = _WorldSpaceLightPos0.xyz;
            float3 vDir = normalize(_WorldSpaceCameraPos.xyz - i.posWS.xyz);
            float3 hDir = normalize(vDir + lDir);
            //准备点积结果
            float ndotl = dot(nDir, lDir);
            float ndoth = dot(nDir, hDir);
            //光照模型
            float lambert = max(0.0, ndotl);
            float blinnPhong = pow(max(0.0, ndoth), _SpecularPow);
            float3 finalRGB = _MainCol * lambert + blinnPhong;
            
            //返回结果
            return float4(finalRGB, 1.0); //输出最终颜色
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}