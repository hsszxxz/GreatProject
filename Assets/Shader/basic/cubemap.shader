// Shader created with Shader Forge v1.40 
// Shader Forge (c) Freya Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.40;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,cgin:,cpap:True,lico:1,lgpr:1,limd:1,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,imps:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:0,bsrc:0,bdst:1,dpts:2,wrdp:True,dith:0,atcv:False,rfrpo:True,rfrpn:Refraction,coma:15,ufog:True,aust:True,igpj:False,qofs:0,qpre:1,rntp:1,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,atwp:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False,fsmp:False;n:type:ShaderForge.SFN_Final,id:9452,x:33366,y:32775,varname:node_9452,prsc:2|emission-4031-OUT;n:type:ShaderForge.SFN_ViewVector,id:2938,x:32032,y:32686,varname:node_2938,prsc:2;n:type:ShaderForge.SFN_Vector1,id:8295,x:31984,y:32835,varname:node_8295,prsc:2,v1:-1;n:type:ShaderForge.SFN_Multiply,id:9891,x:32240,y:32766,varname:node_9891,prsc:2|A-2938-OUT,B-8295-OUT;n:type:ShaderForge.SFN_Tex2d,id:1009,x:31945,y:32959,ptovrint:False,ptlb:mormalmap,ptin:_mormalmap,varname:node_1009,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:bbab0a6f7bae9cf42bf057d8ee2755f6,ntxv:3,isnm:True;n:type:ShaderForge.SFN_Transform,id:42,x:32139,y:32991,varname:node_42,prsc:2,tffrom:2,tfto:0|IN-1009-RGB;n:type:ShaderForge.SFN_Reflect,id:8917,x:32415,y:32882,varname:node_8917,prsc:2|A-9891-OUT,B-42-XYZ;n:type:ShaderForge.SFN_Slider,id:74,x:32395,y:33091,ptovrint:False,ptlb:cubemap power,ptin:_cubemappower,varname:node_74,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:2,max:7;n:type:ShaderForge.SFN_Cubemap,id:2465,x:32726,y:32888,ptovrint:False,ptlb:cubemap,ptin:_cubemap,varname:node_2465,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,cube:eb876be0ed9a47d4c8bc9726ffe3b2c7,pvfc:0|DIR-8917-OUT,MIP-74-OUT;n:type:ShaderForge.SFN_Fresnel,id:4584,x:32607,y:33178,varname:node_4584,prsc:2|NRM-42-XYZ,EXP-8692-OUT;n:type:ShaderForge.SFN_Slider,id:8692,x:32275,y:33312,ptovrint:False,ptlb:fresnel power,ptin:_fresnelpower,varname:node_8692,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:5;n:type:ShaderForge.SFN_Multiply,id:7692,x:32953,y:33056,varname:node_7692,prsc:2|A-2465-RGB,B-4584-OUT;n:type:ShaderForge.SFN_Multiply,id:4031,x:33190,y:33097,varname:node_4031,prsc:2|A-7692-OUT,B-7045-OUT;n:type:ShaderForge.SFN_Slider,id:7045,x:32916,y:33287,ptovrint:False,ptlb:finish power,ptin:_finishpower,varname:node_7045,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:2,max:5;proporder:1009-74-2465-8692-7045;pass:END;sub:END;*/

Shader "shader/basic/cubemap" {
    Properties {
        _mormalmap ("mormalmap", 2D) = "bump" {}
        _cubemappower ("cubemap power", Range(0, 7)) = 2
        _cubemap ("cubemap", Cube) = "_Skybox" {}
        _fresnelpower ("fresnel power", Range(0, 5)) = 0
        _finishpower ("finish power", Range(0, 5)) = 2
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
            uniform sampler2D _mormalmap; uniform float4 _mormalmap_ST;
            uniform samplerCUBE _cubemap;
            UNITY_INSTANCING_BUFFER_START( Props )
                UNITY_DEFINE_INSTANCED_PROP( float, _cubemappower)
                UNITY_DEFINE_INSTANCED_PROP( float, _fresnelpower)
                UNITY_DEFINE_INSTANCED_PROP( float, _finishpower)
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
                float3 _mormalmap_var = UnpackNormal(tex2D(_mormalmap,TRANSFORM_TEX(i.uv0, _mormalmap)));
                float3 node_42 = mul( _mormalmap_var.rgb, tangentTransform ).xyz;
                float _cubemappower_var = UNITY_ACCESS_INSTANCED_PROP( Props, _cubemappower );
                float _fresnelpower_var = UNITY_ACCESS_INSTANCED_PROP( Props, _fresnelpower );
                float _finishpower_var = UNITY_ACCESS_INSTANCED_PROP( Props, _finishpower );
                float3 emissive = ((texCUBElod(_cubemap,float4(reflect((viewDirection*(-1.0)),node_42.rgb),_cubemappower_var)).rgb*pow(1.0-max(0,dot(node_42.rgb, viewDirection)),_fresnelpower_var))*_finishpower_var);
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
