#ifndef MY_CGINC
#define MY_CGINC

//3color env light effect

//参数面板
// 
// _EnvUpCol ("环境天顶颜色", Color) = (1.0, 1.0, 1.0, 1.0)
// _EnvSideCol ("环境水平颜色", Color) = (0.5, 0.5, 0.5, 1.0)
// _EnvDownCol ("环境地表颜色", Color) = (0.0, 0.0, 0.0, 0.0)
// 
//函数部分
float3 TriColAmbient (float3 n,float3 ucol, float3 scol,float3 dcol)
{
float uMask = max(0.0, n.g); // 获取朝上部分遮罩
float dMask = max(0.0, -n.g); // 获取朝下部分遮罩
float sMask = 1.0 - uMask - dMask; // 获取侧面部分遮罩
float3 envCol = ucol * uMask +scol * sMask + dcol * dMask; // 混合环境色
return envCol;
}

#endif