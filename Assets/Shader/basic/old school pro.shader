Shader "shader/basic/code old school pro"{
 Properties {
    [Header(texture)]
        _MainTex ("RGB:基础颜色 A:高光次幂", 2D) = "white" {}
        _NormTex ("RGB:法线贴图", 2D) = "bump" {}
        _SpecTex ("RGB:高光颜色 A:高光次幂", 2D) = "gray" {}
        _EmitTex ("RGB:环境贴图", 2d) = "black" {}
        _Cubemap ("RGB:环境贴图", cube) = "_Skybox" {}
    
    [Header(Diffuse)]
        _MainCol ("基本色", Color) = (0.5, 0.5, 0.5, 1.0)
        _EnvDiffInt ("环境漫反射强度", Range(0, 1)) = 0.2
        _EnvUpCol ("环境天顶颜色", Color) = (1.0, 1.0, 1.0, 1.0)
        _EnvSideCol ("环境水平颜色", Color) = (0.5, 0.5, 0.5, 1.0)
        _EnvDownCol ("环境地表颜色", Color) = (0.0, 0.0, 0.0, 0.0)
   
    [Header(Speculer)]
        _SpecPow ("高光次幂",Range(1,90)) = 30
        _EnvSpecInt ("环境镜面反射强度",Range(0,5)) = 0.2
        _FresnelPow ("菲涅尔次幂",Range(0,10)) = 0
        _CubemapMip ("环境球mip",Range(0,10)) = 0.2
   
    [Header(Emission)]
        _EmitInt ("自发光强度",Range(0,10)) = 1
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
            #include "AutoLight.cginc"
            #include "Lighting.cginc"
            #pragma multi_compile_fwdbase_fullshadows
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_instancing
            #include "UnityCG.cginc"
            #pragma fragmentoption ARB_precision_hint_fastest
            #pragma multi_compile_shadowcaster
            #pragma multi_compile_fog
            #pragma target 3.0

            #include "../MyCgInclude/MyCginc.cginc"
            //输入参数
            //texture
            uniform sampler2D _MainTex;
            uniform sampler2D _NormTex;
            uniform sampler2D _SpecTex;
            uniform sampler2D _EmitTex;
            uniform samplerCUBE _Cubemap;
            //Diffuse
            uniform float3 _MainCol;
            uniform float _EnvDiffInt;
            uniform float3 _EnvUpCol;
            uniform float3 _EnvSideCol;
            uniform float3 _EnvDownCol;
            //Specular
            uniform float _SpecPow;
            uniform float _FresnelPow;
            uniform float _EnvSpecInt;
            uniform float _CubemapMip;
            // Emission
            uniform float _EmitInt;



            //输入结构
            struct VertexInput {
                float4 vertex : POSITION;   //将模型顶点信息输入进来
                float4 normal : NORMAL;     //将模型法线信息输入进来
                float2 uv0 : TEXCOORD0;     //将模型uv信息输入进来 0通道 共4通道  
                float4 tangent : TANGENT;   //将模型切线信息输入进来
            };
            //输出结构
            struct VertexOutput {
                float4 pos : SV_POSITION;   //由顶点信息换算而来的顶点屏幕位置
                float2 uv0 : TEXCOORD0;      //将模型信息用像素shader采样贴图       
                float3 nDirWS : TEXCOORD1;   //由模型法线信息换算而来的世界空间法线信息
                float3 tDirWS : TEXCOORD2;   //世界空间切线信息
                float3 bDirWS : TEXCOORD3;   //世界空间副切线信息
                float4 posWS : TEXCOORD4;    //世界空间顶点位置
                LIGHTING_COORDS(5,6)        // 投影相关
            };
            //输入结构>>>顶点shader>>>输出结构
            VertexOutput vert (VertexInput v) {
                  VertexOutput o = (VertexOutput)0;             // 新建一个输出结构
                 o.pos = UnityObjectToClipPos( v.vertex );      // 变换顶点信息 并将其塞给输出结构
                 o.nDirWS = UnityObjectToWorldNormal(v.normal); // 变换法线信息 并将其塞给输出结构
                 o.posWS = mul(unity_ObjectToWorld, v.vertex); // 顶点位置 OS>WS
                 o.uv0 = v.uv0;
                 o.tDirWS = normalize(mul(unity_ObjectToWorld, float4(v.tangent.xyz, 0.0)).xyz); // 切线方向 OS>WS
                 o.bDirWS = normalize(cross(o.nDirWS, o.tDirWS) * v.tangent.w); // 副切线方向
                 TRANSFER_VERTEX_TO_FRAGMENT(o)                 // 投影相关
                 return o;                                      // 将输出结构 输出
            }
            //输出结构>>>像素
            float4 frag(VertexOutput i) : COLOR {
           //准备向量
            float3 nDirTS = UnpackNormal(tex2D(_NormTex,i.uv0)).rgb;
            float3x3 TBN = float3x3(i.tDirWS,i.bDirWS,i.nDirWS);
            float3 nDirWS =normalize(mul(nDirTS,TBN));
            float3 vDirWS = normalize(_WorldSpaceCameraPos.xyz - i.posWS.xyz);
            float3 vrDirWS = reflect(-vDirWS, nDirWS);     //用于cubmap
            float3 lDirWS = _WorldSpaceLightPos0.xyz;
            float3 lrDirWS = reflect(-lDirWS, nDirWS);     //用于光照模型
            //准备点积结果
            float ndotl = dot(nDirWS, lDirWS);   //世界空间lambert
            float vdotr = dot(vDirWS, lrDirWS);  //phone光照模型
            float vdotn = dot(vDirWS, nDirWS);   //fresnel
            // 采样纹理
            float4 var_MainTex = tex2D(_MainTex, i.uv0);
            float4 var_SpecTex = tex2D(_SpecTex, i.uv0);
            float3 var_EmitTex = tex2D(_EmitTex, i.uv0).rgb;
            float3 var_Cubemap = texCUBElod(_Cubemap, float4(vrDirWS, lerp(_CubemapMip, 0.0, var_SpecTex.a))).rgb;
            //光照模型（直接光照部分）
            float3 baseCol = var_MainTex.rgb * _MainCol;
            float lambert = max(0.0, ndotl);
            float specCol = var_SpecTex.rgb;
            float specPow = lerp(1, _SpecPow, var_SpecTex.a);
            float phong = pow(max(0.0, vdotr), specPow);
            float shadow = LIGHT_ATTENUATION(i);
            float3 dirLighting = (baseCol * lambert + specCol * phong) * _LightColor0 * shadow;
            //光照模型（环境光照部分）
            float3 envCol = TriColAmbient ( nDirWS, _EnvUpCol,  _EnvSideCol, _EnvDownCol); //使用3col方法
            float fresnel = pow(max(0.0, 1.0 - vdotn), _FresnelPow); // 菲涅尔
            float occlusion = var_MainTex.a;
            float3 envLighting = (baseCol * envCol * _EnvDiffInt + var_Cubemap * fresnel * _EnvSpecInt * var_SpecTex.a) * occlusion;
            // 光照模型(自发光部分)
            float3 emission = var_EmitTex * _EmitInt;
            // 返回结果
            float3 finalRGB = dirLighting + envLighting + emission;
            return float4(finalRGB, 1.0);

            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}
