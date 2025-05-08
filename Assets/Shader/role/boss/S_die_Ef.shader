Shader "shader/roles/boss/S_die_Ef" {
        Properties {
                [Header(texture)]
                _MainTex ("RGB:颜色 A:透贴", 2d) = "white"{}
                _MaskTex ("R:高光强度 G:边缘光强度 B:高光染色 A:高光次幂", 2d) = "black"{}
                _NormTex ("RGB:法线贴图", 2d) = "bump"{}
                _MatelnessMask ("金属度遮罩", 2d) = "black"{}
                _EmissionMask ("自发光遮罩", 2d) = "black"{}
                _DiffWarpTex ("颜色Warp图", 2d) = "gray"{}
                _FresWarpTex ("菲涅尔Warp图", 2d) = "gray"{}
                _Cubemap ("环境球", cube) = "_Skybox"{}
                [Header(Diffuse)]
                _EnvDiffInt ("环境漫反射强度", range(0.0, 5.0)) = 0.5
                _LightCol ("光颜色", color) = (1.0, 1.0, 1.0, 1.0)
                _EnvCol ("环境光颜色", color) = (1.0, 1.0, 1.0, 1.0)
                _EnvUpCol ("环境天顶颜色", Color) = (1.0, 1.0, 1.0, 1.0)
                _EnvSideCol ("环境水平颜色", Color) = (0.5, 0.5, 0.5, 1.0)
                _EnvDownCol ("环境地表颜色", Color) = (0.0, 0.0, 0.0, 0.0)
                [Header(Speculer)]
                _SpecPow ("高光次幂", range(0.0, 30.0)) = 5
                _SpecInt ("高光强度", range(0.0, 10.0)) = 5
                _EnvSpecInt ("环境镜面反射强度", range(0.0, 10.0)) = 0.5
                [Header(Rim)]
                _RimCol ("轮廓光颜色", color) = (1.0, 1.0, 1.0, 1.0)
                _RimInt ("轮廓光强度", range(0.0, 3.0)) = 1.0
                [HideInInspector]
                _Color ("Main Color", Color) = (1,1,1,1)
                [HideInInspector]
                _Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
                
                [Header(Emission)]
                _EmitInt ("自发光强度", range(0.0, 10.0)) = 1.0
                [Header(OutLine)]
                _OutlineColor ("外描边颜色", Color) = (0,0,0,1)
                _OutlineWidth ("外描边宽度", Range(0, 1)) = 0.003
                [Header(effects)]
                _NoiseMap("Noise Map", 2D) = "white" {}
                _DissolveThreshold("Dissolve Threshold", Range(0.0, 1.0)) = 0.0
                _LineWidth("Dissolve Line Width", Range(0.0, 0.2)) = 0.1
                [HDR]_DissolveColor("Dissolve First Color", Color) = (0, 0, 1, 1)

                }
                SubShader {
                Tags {
                "RenderType"="Opaque"
                }
                
                
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
            uniform sampler2D _NoiseMap; uniform float4 _NoiseMap_ST;
                uniform half _DissolveThreshold;
                uniform half _LineWidth;
                uniform float3 _DissolveColor;

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
                float2 uv1 : TEXCOORD1;
            };
            //输入结构>>>顶点shader>>>输出结构
            VertexOutput vert (VertexInput v) {
                  VertexOutput o = (VertexOutput)0;             // 新建一个输出结构
                  o.uv1 = TRANSFORM_TEX(v.uv0, _NoiseMap);
                 v.vertex.xyz += v.normal*_OutlineWidth;        //利用法线挤出顶点，关联参数面板控制挤出大小
                 o.pos = UnityObjectToClipPos( v.vertex );      // 变换顶点信息 并将其塞给输出结构，顶点位置OS>CS
                 return o;                                      // 将输出结构 输出
            }
            //输出结构>>>像素
            half4 frag(VertexOutput i) : COLOR {
                
                   
                //采样noise
                fixed3 noise = tex2D(_NoiseMap, i.uv1).rgb;
                clip(noise.r - _DissolveThreshold);
                fixed t = 1 - smoothstep(0.0, _LineWidth, noise.r - _DissolveThreshold);
                half3 finalRGB =lerp(_OutlineColor,_DissolveColor, t * step(0.001, _DissolveThreshold));
            return half4 (finalRGB,1.0) ;
            }
            ENDCG
        }
                        
                Pass {
                Name "FORWARD"
                Tags {
                "LightMode"="ForwardBase"
                }
                CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag
                #include "UnityCG.cginc"
                #include "AutoLight.cginc"
                #include "Lighting.cginc"
                #pragma multi_compile_fwdbase_fullshadows
                #pragma target 3.0
                #include "../../MyCgInclude/MyCginc.cginc"
                // 输入参数
                uniform sampler2D _MainTex; uniform float4 _MainTex_ST;
                uniform sampler2D _MaskTex;
                uniform sampler2D _NormTex; uniform float4 _NormTex_ST;
                uniform sampler2D _MatelnessMask;
                uniform sampler2D _EmissionMask;
                uniform sampler2D _DiffWarpTex;
                uniform sampler2D _FresWarpTex;
                uniform samplerCUBE _Cubemap;
                uniform half3 _LightCol;
                uniform half _SpecPow;
                uniform half _SpecInt;
                uniform half3 _EnvCol;
                uniform half _EnvDiffInt;
                uniform half _EnvSpecInt;
                uniform half3 _RimCol;
                uniform half _RimInt;
                uniform half _EmitInt;
                uniform float3 _EnvUpCol;
                uniform float3 _EnvSideCol;
                uniform float3 _EnvDownCol;
                uniform half _Cutoff;
                uniform half3 _Color;
                uniform sampler2D _NoiseMap; uniform float4 _NoiseMap_ST;
                uniform half _DissolveThreshold;
                uniform half _LineWidth;
                uniform float3 _DissolveColor;
                // 输入结构
                struct VertexInput {
                float4 vertex : POSITION;
                float2 uv0 : TEXCOORD0;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
                };
                // 输出结构
                struct VertexOutput {
                float4 pos : SV_POSITION;
                float3 posWS : TEXCOORD0;
                float2 uv0 : TEXCOORD1;
                float2 uv1 : TEXCOORD2;
                float2 uv2 : TEXCOORD3;
                float3 nDirWS : TEXCOORD4;
                float3 tDirWS : TEXCOORD5;
                float3 bDirWS : TEXCOORD6;
                LIGHTING_COORDS(7, 8)
                };
                // 输入结构>>>顶点Shader>>>输出结构
                VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.posWS = mul(unity_ObjectToWorld, v.vertex).xyz;
                o.uv0 = TRANSFORM_TEX(v.uv0, _MainTex);
                o.uv1 = TRANSFORM_TEX(v.uv0, _NormTex);
                o.uv2 = TRANSFORM_TEX(v.uv0, _NoiseMap);
                o.nDirWS = UnityObjectToWorldNormal(v.normal);
                o.tDirWS = normalize(mul(unity_ObjectToWorld, float4(v.tangent.xyz, 0.0)).xyz);
                o.bDirWS = normalize(cross(o.nDirWS, o.tDirWS) * v.tangent.w);
                TRANSFER_VERTEX_TO_FRAGMENT(o)
                return o;
                }
                // 输出结构>>>像素
                float4 frag(VertexOutput i) : COLOR {
                      
                // 向量准备
                half3 nDirTS = UnpackNormal(tex2D(_NormTex, i.uv0));
                half3x3 TBN = half3x3(i.tDirWS, i.bDirWS, i.nDirWS);
                half3 nDirWS = normalize(mul(nDirTS, TBN));
                half3 vDirWS = normalize(_WorldSpaceCameraPos.xyz - i.posWS);
                half3 vrDirWS = reflect(-vDirWS, nDirWS);
                half3 lDirWS = _WorldSpaceLightPos0.xyz;
                half3 lrDirWS = reflect(-lDirWS, nDirWS);
                // 中间量准备
                half ndotl = dot(nDirWS, lDirWS); //lambert
                half ndotv = dot(nDirWS, vDirWS); //fresnel
                half vdotr = dot(vDirWS, lrDirWS); //phong
                //采样noise
                fixed3 noise = tex2D(_NoiseMap, i.uv2).rgb;
                clip(noise.r - _DissolveThreshold);
                // 采样纹理
                half4 var_MainTex = tex2D(_MainTex, i.uv0);
                half4 var_MaskTex = tex2D(_MaskTex, i.uv0);
                half var_MatelnessMask = tex2D(_MatelnessMask, i.uv0).r;
                half var_EmissionMask = tex2D(_EmissionMask, i.uv0).r;
                half3 var_FresWarpTex = tex2D(_FresWarpTex, ndotv).rgb;
                half3 var_Cubemap = texCUBElod(_Cubemap, float4(vrDirWS, lerp(8.0, 0.0, var_MaskTex.a))).rgb;
                // 提取信息
                half3 baseCol = var_MainTex.rgb;
                half opacity = var_MainTex.a;
                half specInt = var_MaskTex.r;
                half rimInt = var_MaskTex.g;
                half specTint = var_MaskTex.b;
                half specPow = var_MaskTex.a;
                half matellic = var_MatelnessMask;
                half emitInt = var_EmissionMask;
                half3 envCube = var_Cubemap;
                half shadow = LIGHT_ATTENUATION(i);
                // 光照模型
                // 漫反射颜色 镜面反射颜色
                half3 diffCol = lerp(baseCol, half3(0.0, 0.0, 0.0), matellic);
                half3 specCol = lerp(baseCol, half3(0.3, 0.3, 0.3), specTint) * specInt;
                // 菲涅尔
                half3 fresnel = lerp(var_FresWarpTex, 0.0, matellic);
                half fresnelCol = fresnel.r; // 无实际用途
                half fresnelRim = fresnel.g;
                half fresnelSpec = fresnel.b;
                // 光源漫反射
                half halfLambert = ndotl * 0.5 + 0.5;
                half3 var_DiffWarpTex = tex2D(_DiffWarpTex, half2(halfLambert, 0.2));
                half3 dirDiff = diffCol * var_DiffWarpTex * _LightCol;
                // 光源镜面反射
                half phong = pow(max(0.0, vdotr), specPow * _SpecPow);
                half spec = phong * max(0.0, ndotl);
                spec = max(spec, fresnelSpec);
                spec = spec * _SpecInt;
                half3 dirSpec = specCol * spec * _LightCol;
                // 环境漫反射
                half3 envDiff = diffCol * _EnvCol * _EnvDiffInt;
                // 环境镜面反射
                half reflectInt = max(fresnelSpec, matellic) * specInt;
                half3 envSpec = specCol * reflectInt * envCube * _EnvSpecInt;
                // 轮廓光
                half3 rimLight = _RimCol * fresnelRim * rimInt * max(0.0, nDirWS.g) * _RimInt;
                // 自发光
                half3 emission = diffCol * emitInt * _EmitInt;
                //3col env
                float3 envCol = TriColAmbient ( nDirWS,_EnvUpCol , _EnvSideCol , _EnvDownCol);
                clip(opacity - _Cutoff);
                //_LineWidth控制消融颜色作用的范围。与光照颜色进行lerp
                fixed t = 1 - smoothstep(0.0, _LineWidth, noise.r - _DissolveThreshold);
       
                // 混合
                half3 finalRGB = lerp((dirDiff + dirSpec*2.0) * shadow + envDiff*0.6 + envSpec*2.0 + rimLight + emission + (envCol*0.15),_DissolveColor, t * step(0.001, _DissolveThreshold));
                
                
                
                return float4(finalRGB, 1.0);
                }
                ENDCG
                }
                
                }
                FallBack "Legacy Shaders/Transparent/Cutout/VertexLit"
                }