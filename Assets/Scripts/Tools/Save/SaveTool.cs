using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEngine;
namespace save
{
    ///<summary>
    ///
    ///<summary>
    public static class SaveTool
    {
        public static void SaveJson(object saveObject, string path)
        {
            string jsonData = JsonUtility.ToJson(saveObject);
            File.WriteAllText(path, jsonData);
        }
        public static T LoadJson<T>(string path) where T : class
        {
            if (!File.Exists(path))
            {
                return null;
            }
            string jsonData = File.ReadAllText(path);
            return JsonUtility.FromJson<T>(jsonData);
        }
    }
}

