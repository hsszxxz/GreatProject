// Shader created with Shader Forge v1.40 
// Shader Forge (c) Freya Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.40;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,cgin:,cpap:True,lico:1,lgpr:1,limd:1,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,imps:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:0,bsrc:0,bdst:1,dpts:2,wrdp:True,dith:0,atcv:False,rfrpo:True,rfrpn:Refraction,coma:15,ufog:True,aust:True,igpj:False,qofs:0,qpre:1,rntp:1,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,atwp:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False,fsmp:False;n:type:ShaderForge.SFN_Final,id:740,x:33895,y:32484,varname:node_740,prsc:2|emission-5941-OUT;n:type:ShaderForge.SFN_Tex2d,id:8757,x:31791,y:32731,ptovrint:False,ptlb:normalmap,ptin:_normalmap,varname:node_8757,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:3,isnm:True;n:type:ShaderForge.SFN_Transform,id:9770,x:32001,y:32731,varname:node_9770,prsc:2,tffrom:2,tfto:0|IN-8757-RGB;n:type:ShaderForge.SFN_Transform,id:6371,x:32152,y:32503,varname:node_6371,prsc:2,tffrom:0,tfto:3|IN-9770-XYZ;n:type:ShaderForge.SFN_ComponentMask,id:1594,x:32419,y:32512,varname:node_1594,prsc:2,cc1:0,cc2:1,cc3:-1,cc4:-1|IN-6371-XYZ;n:type:ShaderForge.SFN_RemapRange,id:8935,x:32776,y:32459,varname:node_8935,prsc:2,frmn:-1,frmx:1,tomn:0,tomx:1|IN-1594-OUT;n:type:ShaderForge.SFN_Tex2d,id:6172,x:32980,y:32538,ptovrint:False,ptlb:matcap,ptin:_matcap,varname:node_6172,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:a43e58694130be44f92501b7a3cfbaba,ntxv:1,isnm:False|UVIN-8935-OUT;n:type:ShaderForge.SFN_Slider,id:9995,x:32836,y:33009,ptovrint:False,ptlb:fresnel power,ptin:_fresnelpower,varname:node_9995,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:3.575094,max:10;n:type:ShaderForge.SFN_Fresnel,id:3153,x:33160,y:32790,varname:node_3153,prsc:2|NRM-9770-XYZ,EXP-9995-OUT;n:type:ShaderForge.SFN_Multiply,id:5945,x:33344,y:32612,varname:node_5945,prsc:2|A-6172-RGB,B-3153-OUT;n:type:ShaderForge.SFN_Multiply,id:5941,x:33613,y:32725,varname:node_5941,prsc:2|A-5945-OUT,B-1684-OUT;n:type:ShaderForge.SFN_Slider,id:1684,x:33456,y:32990,ptovrint:False,ptlb:finishl power,ptin:_finishlpower,varname:node_1684,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:1,max:5;proporder:8757-6172-9995-1684;pass:END;sub:END;*/

Shader "ap1/l09/matcap +fresnel" {
    Properties {
        _normalmap ("normalmap", 2D) = "bump" {}
        _matcap ("matcap", 2D) = "gray" {}
        _fresnelpower ("fresnel power", Range(0, 10)) = 3.575094
        _finishlpower ("finishl power", Range(0, 5)) = 1
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
            #pragma multi_compile_fwdbase_fullshadows
            #pragma multi_compile_fog
            #pragma target 3.0
            uniform sampler2D _normalmap; uniform float4 _normalmap_ST;
            uniform sampler2D _matcap; uniform float4 _matcap_ST;
            UNITY_INSTANCING_BUFFER_START( Props )
                UNITY_DEFINE_INSTANCED_PROP( float, _fresnelpower)
                UNITY_DEFINE_INSTANCED_PROP( float, _finishlpower)
            UNITY_INSTANCING_BUFFER_END( Props )
            struct VertexInput {
                UNITY_VERTEX_INPUT_INSTANCE_ID
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                UNITY_VERTEX_INPUT_INSTANCE_ID
                float2 uv0 : TEXCOORD0;
                float4 posWorld : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
                float3 tangentDir : TEXCOORD3;
                float3 bitangentDir : TEXCOORD4;
                UNITY_FOG_COORDS(5)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                UNITY_SETUP_INSTANCE_ID( v );
                UNITY_TRANSFER_INSTANCE_ID( v, o );
                o.uv0 = v.texcoord0;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                o.tangentDir = normalize( mul( unity_ObjectToWorld, float4( v.tangent.xyz, 0.0 ) ).xyz );
                o.bitangentDir = normalize(cross(o.normalDir, o.tangentDir) * v.tangent.w);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                o.pos = UnityObjectToClipPos( v.vertex );
                UNITY_TRANSFER_FOG(o,o.pos);
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                UNITY_SETUP_INSTANCE_ID( i );
                i.normalDir = normalize(i.normalDir);
                float3x3 tangentTransform = float3x3( i.tangentDir, i.bitangentDir, i.normalDir);
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 normalDirection = i.normalDir;
////// Lighting:
////// Emissive:
                float3 _normalmap_var = UnpackNormal(tex2D(_normalmap,TRANSFORM_TEX(i.uv0, _normalmap)));
                float3 node_9770 = mul( _normalmap_var.rgb, tangentTransform ).xyz;
                float2 node_8935 = (mul( UNITY_MATRIX_V, float4(node_9770.rgb,0) ).xyz.rgb.rg*0.5+0.5);
                float4 _matcap_var = tex2D(_matcap,TRANSFORM_TEX(node_8935, _matcap));
                float _fresnelpower_var = UNITY_ACCESS_INSTANCED_PROP( Props, _fresnelpower );
                float _finishlpower_var = UNITY_ACCESS_INSTANCED_PROP( Props, _finishlpower );
                float3 emissive = ((_matcap_var.rgb*pow(1.0-max(0,dot(node_9770.rgb, viewDirection)),_fresnelpower_var))*_finishlpower_var);
                float3 finalColor = emissive;
                fixed4 finalRGBA = fixed4(finalColor,1);
                UNITY_APPLY_FOG(i.fogCoord, finalRGBA);
                return finalRGBA;
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}
