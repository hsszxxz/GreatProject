#ifndef MY_CGINC
#define MY_CGINC

//3color env light effect
float3 TriColAmbient (float3 n,float3 ucol, float3 scol,float3 dcol)
{
float uMask = max(0.0, n.g); // 获取朝上部分遮罩
float dMask = max(0.0, -n.g); // 获取朝下部分遮罩
float sMask = 1.0 - uMask - dMask; // 获取侧面部分遮罩
float3 envCol = ucol * uMask +scol * sMask + dcol * dMask; // 混合环境色
return envCol;
}

#endif