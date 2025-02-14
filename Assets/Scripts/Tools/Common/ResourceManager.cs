using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using UnityEngine;
using UnityEngine.Networking;
//ͨ����������Դ
public class ResourceManager
{
    private static Dictionary<string,string> configMap;
    //��ʼ����ľ�̬���ݳ�Ա
    //�౻����ʱִֻ��һ��
    static ResourceManager()
    {
        string fileContent = GetConfigFile("ConfigMap.txt");
        BuildMap(fileContent);
    }
    private static void BuildMap(string fileContent)
    {
        configMap = new Dictionary<string, string>();
        using (StringReader stringReader = new StringReader(fileContent))
        {
            //�������˳�using����飬���Զ��ͷ��ڴ�
            string line;
            while ((line = stringReader.ReadLine()) != null)
            {
                string[] keyValue = line.Split('=');
                configMap.Add(keyValue[0], keyValue[1]);
            }
        }
    }
    public static string GetConfigFile(string fileName)
    {
        //ConfigMap.txt
        //    var url = new System.Uri(Path.Combine(Application.streamingAssetsPath, "ConfigMap.txt"));
        //    UnityWebRequest request = UnityWebRequest.Get(url);
        //    request.SendWebRequest();
        var url = new System.Uri(Path.Combine(Application.streamingAssetsPath, fileName));
        UnityWebRequest request = UnityWebRequest.Get(url);
        request.SendWebRequest();
        if (request.error == null )
        {
            while (true)
            {
                if (request.downloadHandler.isDone)
                {
                    return request.downloadHandler.text;
                }
            }
        }
        else
        {
            Debug.LogError("��ȡConfigMap�ļ�ʧ��");
            return string.Empty;
        }
    }
    public static T Load<T>(string name)where T : Object
    {
        string path = configMap[name];
        return Resources.Load<T>(path);
    }
}