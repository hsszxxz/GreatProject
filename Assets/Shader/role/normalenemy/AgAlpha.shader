Shader "shader/roles/AgAlpha" {
Properties {
[Header(texture)]
_MainTex ("RGB:颜色 A:透贴", 2d) = "white"{}
_NormTex ("RGB:法线贴图", 2d) = "bump"{}
_ORM ("ORM", 2d) = "black"{}
_DiffWarpTex ("颜色Warp图", 2d) = "gray"{}
_FresWarpTex ("菲涅尔Warp图", 2d) = "gray"{}
[Header(Diffuse)]
_EnvDiffInt ("环境漫反射强度", range(0.0, 10)) = 0.5
_LightCol ("光颜色", color) = (1.0, 1.0, 1.0, 1.0)
_EnvCol ("环境光颜色", color) = (1.0, 1.0, 1.0, 1.0)
_EnvUpCol ("环境天顶颜色", Color) = (1.0, 1.0, 1.0, 1.0)
_EnvSideCol ("环境水平颜色", Color) = (0.5, 0.5, 0.5, 1.0)
_EnvDownCol ("环境地表颜色", Color) = (0.0, 0.0, 0.0, 0.0)
[Header(OutLine)]
_OutlineColor ("外描边颜色", Color) = (1,0,0,1)
_OutlineWidth ("外描边宽度", Range(0, 1)) = 0.01
[Header(effcts)]
_Opacity("透明度",range(0.0,1.0)) = 0.5
_Sequence("序列帧图",2d) = "gray"{}
_RowCount("行数",int) = 1 
_ColCount("列数",int) = 1 
_speed("动画速度",range(0,10)) = 1
_FireCol ("火焰颜色", Color) = (0.0, 0.0, 0.0, 0.0)



}
SubShader {
Tags {
"Queue"="Transparent"//调整渲染顺序
"RenderType"="Transparent"//对应改为Cutout 
"ForceNoShadowCasting"="True"//关闭阴影投射
"IgnoreProjector"="True"//不响应投射器
}
 //描边使用两个Pass，第一个pass沿法线挤出一点，只输出描边的颜色  
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
uniform sampler2D _MainTex;
uniform sampler2D _NormTex;
uniform sampler2D _ORM;
uniform sampler2D _DiffWarpTex;
uniform sampler2D _FresWarpTex;
uniform half3 _LightCol;
uniform half _SpecInt;
uniform half3 _EnvCol;
uniform half _EnvDiffInt;
uniform half _EnvSpecInt;
uniform float3 _EnvUpCol;
uniform float3 _EnvSideCol;
uniform float3 _EnvDownCol;
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
float3 nDirWS : TEXCOORD2;
float3 tDirWS : TEXCOORD3;
float3 bDirWS : TEXCOORD4;
LIGHTING_COORDS(5, 6)
};
// 输入结构>>>顶点Shader>>>输出结构
VertexOutput vert (VertexInput v) {
VertexOutput o = (VertexOutput)0;
o.pos = UnityObjectToClipPos(v.vertex);
o.posWS = mul(unity_ObjectToWorld, v.vertex).xyz;
o.uv0 = v.uv0;
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
// 采样纹理
half4 var_MainTex = tex2D(_MainTex, i.uv0);
half3 var_ORM = tex2D(_ORM, i.uv0);
half3 var_FresWarpTex = tex2D(_FresWarpTex, ndotv).rgb;
// 提取信息
half3 baseCol = var_MainTex.rgb;
half opacity = var_MainTex.a;
half ao = var_ORM.r;
half roughness = var_ORM.g;
half matellic = var_ORM.b;
half shadow = LIGHT_ATTENUATION(i);
// 光照模型
// 漫反射颜色 镜面反射颜色
half3 diffCol = lerp(baseCol, half3(0.0, 0.0, 0.0), matellic);
// 菲涅尔
half3 fresnel = lerp(var_FresWarpTex, 0.0, matellic);
half fresnelRim = fresnel.g;
half fresnelSpec = fresnel.b;
// 光源漫反射
half halfLambert = ndotl * 0.5 + 0.5;
half3 var_DiffWarpTex = tex2D(_DiffWarpTex, half2(halfLambert, 0.2));
half3 dirDiff = roughness *  diffCol * var_DiffWarpTex * _LightCol;
// 光源镜面反射
half phong = pow(max(0.0, vdotr), 1);
half spec = phong * max(0.0, ndotl);
spec = max(spec, fresnelSpec);
spec = spec * _SpecInt;
half3 dirSpec = matellic *spec * _LightCol;
// 环境漫反射
half3 envDiff =diffCol * _EnvCol * _EnvDiffInt;
//3col env
float3 envCol = TriColAmbient ( nDirWS,_EnvUpCol , _EnvSideCol , _EnvDownCol);
// 混合
half3 finalRGB = roughness *  ao * (dirDiff + dirSpec) * shadow + envDiff  + (envCol*0.15);



return float4(finalRGB, 1.0);
}
ENDCG
}
Pass
{
    
    Name "FORWARD_AD"
    Tags {
        "LightMode"="ForwardBase"
    }
    Blend One One //修改混合方式One/SrcAlphaOneMinusSrcAlpha
  

    CGPROGRAM
    #pragma vertex vert
    #pragma fragment frag
    #include "UnityCG.cginc"
    #pragma multi_compile_fwdbase_fullshadows
    #pragma multi_compile_fog
    #pragma target 3.0
    //输入参数
    uniform sampler2D _Sequence; uniform float4 _Sequence_ST;
    uniform float _RowCount;
    uniform float _ColCount;
    uniform float _speed;
    uniform float4 _FireCol;


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
         v.vertex.xyz += v.normal*0.01;
         o.pos = UnityObjectToClipPos( v.vertex );      // 变换顶点信息 并将其塞给输出结构，顶点位置OS>CS
         o.uv0=TRANSFORM_TEX(v.uv0,_Sequence);             // UV信息支持TilingOffset
         //计算序列帧位置变化，播放序列帧
         float ID = floor(_Time.y*3*_speed);
         float VId = floor(ID/_RowCount);
         float UId = ID - VId*_RowCount;
         float UStep = 1/_ColCount;
         float VStep = 1/_RowCount;
         float2 initUV = o.uv0*float2(UStep,VStep) + float2(0.0,(VStep*(_RowCount-1)));
         o.uv0 = initUV + float2(UId*UStep,-VId*VStep);
         return o;                                      // 将输出结构 输出
    }
    //输出结构>>>像素
    half4 frag(VertexOutput i) : COLOR {
    half4 var_MainTex = tex2D(_Sequence, i.uv0); // 采样贴图 RGB颜色 A透贴
    half3 finalRGB = var_MainTex.rgb*_FireCol;
    return half4 (finalRGB,1.0  );
    }
    ENDCG
}
}
FallBack "Diffuse"
}