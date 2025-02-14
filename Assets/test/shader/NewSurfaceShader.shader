// Shader created with Shader Forge v1.40 
// Shader Forge (c) Freya Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.40;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,cgin:,cpap:True,lico:1,lgpr:1,limd:1,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,imps:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:0,bsrc:0,bdst:1,dpts:2,wrdp:True,dith:0,atcv:False,rfrpo:True,rfrpn:Refraction,coma:15,ufog:True,aust:True,igpj:False,qofs:0,qpre:1,rntp:1,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,atwp:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False,fsmp:False;n:type:ShaderForge.SFN_Final,id:874,x:33392,y:32337,varname:node_874,prsc:2|emission-6020-OUT;n:type:ShaderForge.SFN_NormalVector,id:4826,x:31636,y:32680,prsc:2,pt:False;n:type:ShaderForge.SFN_LightVector,id:5165,x:31636,y:32850,varname:node_5165,prsc:2;n:type:ShaderForge.SFN_Dot,id:6776,x:31910,y:32731,varname:node_6776,prsc:2,dt:0|A-4826-OUT,B-5165-OUT;n:type:ShaderForge.SFN_Step,id:6270,x:32359,y:32384,varname:node_6270,prsc:2|A-7881-OUT,B-6776-OUT;n:type:ShaderForge.SFN_Slider,id:9224,x:31506,y:32366,ptovrint:False,ptlb:light shrongth,ptin:_lightshrongth,varname:node_9224,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0.4324516,max:1;n:type:ShaderForge.SFN_Multiply,id:8297,x:31890,y:32410,varname:node_8297,prsc:2|A-9224-OUT,B-1742-RGB;n:type:ShaderForge.SFN_Color,id:1742,x:31612,y:32475,ptovrint:False,ptlb:color,ptin:_color,varname:node_1742,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0.5,c2:0.5,c3:0.5,c4:1;n:type:ShaderForge.SFN_ComponentMask,id:2722,x:32133,y:32126,varname:node_2722,prsc:2,cc1:0,cc2:-1,cc3:-1,cc4:-1|IN-8297-OUT;n:type:ShaderForge.SFN_ComponentMask,id:7881,x:32147,y:32294,varname:node_7881,prsc:2,cc1:1,cc2:-1,cc3:-1,cc4:-1|IN-8297-OUT;n:type:ShaderForge.SFN_ComponentMask,id:6354,x:32158,y:32451,varname:node_6354,prsc:2,cc1:2,cc2:-1,cc3:-1,cc4:-1|IN-8297-OUT;n:type:ShaderForge.SFN_Step,id:4933,x:32359,y:32266,varname:node_4933,prsc:2|A-2722-OUT,B-6776-OUT;n:type:ShaderForge.SFN_Step,id:6069,x:32349,y:32511,varname:node_6069,prsc:2|A-6354-OUT,B-6776-OUT;n:type:ShaderForge.SFN_Append,id:178,x:32607,y:32312,varname:node_178,prsc:2|A-4933-OUT,B-6270-OUT;n:type:ShaderForge.SFN_Append,id:4570,x:32591,y:32476,varname:node_4570,prsc:2|A-178-OUT,B-6069-OUT;n:type:ShaderForge.SFN_RemapRange,id:9757,x:32868,y:32547,varname:node_9757,prsc:2,frmn:0,frmx:1,tomn:1,tomx:0|IN-4570-OUT;n:type:ShaderForge.SFN_Color,id:3418,x:32895,y:32737,ptovrint:False,ptlb:node_3418,ptin:_node_3418,varname:node_3418,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0.5,c2:0.5,c3:0.5,c4:1;n:type:ShaderForge.SFN_Multiply,id:6020,x:33113,y:32563,varname:node_6020,prsc:2|A-9757-OUT,B-3418-RGB;n:type:ShaderForge.SFN_Color,id:9511,x:32932,y:32266,ptovrint:False,ptlb:node_9511,ptin:_node_9511,varname:node_9511,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0.5,c2:0.5,c3:0.5,c4:1;n:type:ShaderForge.SFN_Multiply,id:4254,x:33050,y:32082,varname:node_4254,prsc:2|A-4570-OUT,B-9511-RGB;n:type:ShaderForge.SFN_Multiply,id:5364,x:33301,y:31986,varname:node_5364,prsc:2|B-4254-OUT;proporder:9224-1742-3418;pass:END;sub:END;*/

Shader "ap1/l04/rgb monkey" {
    Properties {
        _lightshrongth ("light shrongth", Range(0, 1)) = 0.4324516
        _color ("color", Color) = (0.5,0.5,0.5,1)
        _node_3418 ("node_3418", Color) = (0.5,0.5,0.5,1)
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
            #pragma multi_compile_instancing
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #pragma multi_compile_fwdbase_fullshadows
            #pragma multi_compile_fog
            #pragma target 3.0
            UNITY_INSTANCING_BUFFER_START( Props )
                UNITY_DEFINE_INSTANCED_PROP( float, _lightshrongth)
                UNITY_DEFINE_INSTANCED_PROP( float4, _color)
                UNITY_DEFINE_INSTANCED_PROP( float4, _node_3418)
            UNITY_INSTANCING_BUFFER_END( Props )
            struct VertexInput {
                UNITY_VERTEX_INPUT_INSTANCE_ID
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                UNITY_VERTEX_INPUT_INSTANCE_ID
                float4 posWorld : TEXCOORD0;
                float3 normalDir : TEXCOORD1;
                LIGHTING_COORDS(2,3)
                UNITY_FOG_COORDS(4)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                UNITY_SETUP_INSTANCE_ID( v );
                UNITY_TRANSFER_INSTANCE_ID( v, o );
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                o.pos = UnityObjectToClipPos( v.vertex );
                UNITY_TRANSFER_FOG(o,o.pos);
                TRANSFER_VERTEX_TO_FRAGMENT(o)
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                UNITY_SETUP_INSTANCE_ID( i );
                i.normalDir = normalize(i.normalDir);
                float3 normalDirection = i.normalDir;
                float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
////// Lighting:
////// Emissive:
                float _lightshrongth_var = UNITY_ACCESS_INSTANCED_PROP( Props, _lightshrongth );
                float4 _color_var = UNITY_ACCESS_INSTANCED_PROP( Props, _color );
                float3 node_8297 = (_lightshrongth_var*_color_var.rgb);
                float node_6776 = dot(i.normalDir,lightDirection);
                float3 node_4570 = float3(float2(step(node_8297.r,node_6776),step(node_8297.g,node_6776)),step(node_8297.b,node_6776));
                float4 _node_3418_var = UNITY_ACCESS_INSTANCED_PROP( Props, _node_3418 );
                float3 emissive = ((node_4570*-1.0+1.0)*_node_3418_var.rgb);
                float3 finalColor = emissive;
                fixed4 finalRGBA = fixed4(finalColor,1);
                UNITY_APPLY_FOG(i.fogCoord, finalRGBA);
                return finalRGBA;
            }
            ENDCG
        }
        Pass {
            Name "FORWARD_DELTA"
            Tags {
                "LightMode"="ForwardAdd"
            }
            Blend One One
            
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_instancing
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #pragma multi_compile_fwdadd_fullshadows
            #pragma multi_compile_fog
            #pragma target 3.0
            UNITY_INSTANCING_BUFFER_START( Props )
                UNITY_DEFINE_INSTANCED_PROP( float, _lightshrongth)
                UNITY_DEFINE_INSTANCED_PROP( float4, _color)
                UNITY_DEFINE_INSTANCED_PROP( float4, _node_3418)
            UNITY_INSTANCING_BUFFER_END( Props )
            struct VertexInput {
                UNITY_VERTEX_INPUT_INSTANCE_ID
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                UNITY_VERTEX_INPUT_INSTANCE_ID
                float4 posWorld : TEXCOORD0;
                float3 normalDir : TEXCOORD1;
                LIGHTING_COORDS(2,3)
                UNITY_FOG_COORDS(4)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                UNITY_SETUP_INSTANCE_ID( v );
                UNITY_TRANSFER_INSTANCE_ID( v, o );
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                o.pos = UnityObjectToClipPos( v.vertex );
                UNITY_TRANSFER_FOG(o,o.pos);
                TRANSFER_VERTEX_TO_FRAGMENT(o)
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                UNITY_SETUP_INSTANCE_ID( i );
                i.normalDir = normalize(i.normalDir);
                float3 normalDirection = i.normalDir;
                float3 lightDirection = normalize(lerp(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz - i.posWorld.xyz,_WorldSpaceLightPos0.w));
////// Lighting:
                float3 finalColor = 0;
                fixed4 finalRGBA = fixed4(finalColor * 1,0);
                UNITY_APPLY_FOG(i.fogCoord, finalRGBA);
                return finalRGBA;
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}
