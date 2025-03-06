using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using Unity.VisualScripting;
using UnityEngine;
namespace save
{
    /// <summary>
    /// 数据存档存储持久化管理器
    /// </summary>
    public class SaveSystemManager : MonoSingleton<SaveSystemManager>
    {
        private SaveSystemData saveSystemData;//存档系统数据

        // 存档的保存
        private const string saveDirName = "saveData";
        // 设置的保存：1.全局数据的保存（分辨率、按键设置） 2.存档的设置保存。
        // 常规情况下，存档系统自行维护
        private const string settingDirName = "setting";

        // 存档文件夹路径
        private string saveDirPath;
        private string settingDirPath;

        // 存档中对象的缓存字典 
        // <存档ID,<文件名称，实际的对象>>
        private Dictionary<int, Dictionary<string, object>> cacheDic = new Dictionary<int, Dictionary<string, object>>();

        #region 初始化
        public override void Init()
        {
            base.Init();
            // 存档文件夹路径
            saveDirPath = Application.persistentDataPath + "/" + saveDirName;
            settingDirPath = Application.persistentDataPath + "/" + settingDirName;
            Debug.Log("存储管理器初始化成功");
            //检查路径并创建目录
            CheckAndCreateDir();
            // 初始化SaveSystemData
            InitSaveSystemData();
            // 清除存档缓存字典
            CleanCache();
        }
        #endregion

        #region 保存、获取全局设置存档
        /// <summary>
        /// 加载设置，全局生效，不关乎任何一个存档
        /// </summary>
        public T LoadSetting<T>(string fileName) where T : class
        {
            return LoadFile<T>(settingDirPath + "/" + fileName);
        }
        /// <summary>
        /// 加载设置，全局生效，不关乎任何一个存档
        /// </summary>
        public T LoadSetting<T>() where T : class
        {
            return LoadSetting<T>(typeof(T).Name);
        }
        /// <summary>
        /// 保存设置，全局生效，不关乎任何一个存档
        /// </summary>
        public void SaveSetting(object saveObject, string fileName)
        {
            SaveFile(saveObject, settingDirPath + "/" + fileName);
        }

        /// <summary>
        /// 保存设置，全局生效，不关乎任何一个存档
        /// </summary>
        public void SaveSetting(object saveObject)
        {
            SaveSetting(saveObject, saveObject.GetType().Name);
        }

        /// <summary>
        /// 删除所有设置存档
        /// </summary>
        public void DeleteAllSetting()
        {
            if (Directory.Exists(settingDirPath))
            {
                // 直接删除目录
                Directory.Delete(settingDirPath, true);
            }
            CheckAndCreateDir();
        }
        #endregion

        #region 创建、获取、删除某一项用户存档
        /// <summary>
        /// 获取SaveItem
        /// </summary>
        public SavePoint GetSaveItem(int id)
        {
            for (int i = 0; i < saveSystemData.saveItemList.Count; i++)
            {
                if (saveSystemData.saveItemList[i].saveID == id)
                {
                    return saveSystemData.saveItemList[i];
                }
            }
            return null;
        }
        /// <summary>
        /// 获取SaveItem
        /// </summary>
        public SavePoint GetSaveItem(SavePoint savePoint)
        {
            GetSaveItem(savePoint.saveID);
            return null;
        }

        /// <summary>
        /// 添加一个存档
        /// </summary>
        /// <returns></returns>
        public SavePoint CreateSaveItem()
        {
            saveSystemData.currID += 1;
            SavePoint saveItem = new SavePoint(saveSystemData.currID, DateTime.Now);
            saveSystemData.saveItemList.Add(saveItem);
            // 更新SaveSystemData 写入磁盘
            UpdateSaveSystemData();
            return saveItem;
        }

        /// <summary>
        /// 删除存档
        /// </summary>
        /// <param name="saveID">存档的ID</param>
        public void DeleteSaveItem(int saveID)
        {
            string itemDir = GetSavePath(saveID, false);
            // 如果路径存在 且 有效
            if (itemDir != null)
            {
                // 把这个存档下的文件递归删除
                Directory.Delete(itemDir, true);
            }
            saveSystemData.saveItemList.Remove(GetSaveItem(saveID));
            // 移除缓存
            RemoveCache(saveID);
            // 更新SaveSystemData 写入磁盘
            UpdateSaveSystemData();
        }
        /// <summary>
        /// 删除存档
        /// </summary>
        public void DeleteSaveItem(SavePoint saveItem)
        {
            DeleteSaveItem(saveItem.saveID);
        }
        #endregion

        #region 保存、获取、删除用户存档中某一对象
        /// <summary>
        /// 保存对象至某个存档中
        /// </summary>
        /// <param name="saveObject">要保存的对象</param>
        /// <param name="saveFileName">保存的文件名称</param>
        /// <param name="saveID">存档的ID</param>
        public void SaveObject(object saveObject, string saveFileName, int saveID = 0)
        {
            // 存档所在的文件夹路径
            string dirPath = GetSavePath(saveID, true);
            // 具体的对象要保存的路径
            string savePath = dirPath + "/" + saveFileName;
            // 具体的保存
            SaveFile(saveObject, savePath);
            // 更新存档时间
            GetSaveItem(saveID).UpdateTime(DateTime.Now);
            // 更新SaveSystemData 写入磁盘
            UpdateSaveSystemData();

            // 更新缓存
            SetCache(saveID, saveFileName, saveObject);

        }

        /// <summary>
        /// 保存对象至某个存档中
        /// </summary>
        /// <param name="saveObject">要保存的对象</param>
        /// <param name="saveFileName">保存的文件名称</param>
        public void SaveObject(object saveObject, string saveFileName, SavePoint saveItem)
        {
            SaveObject(saveObject, saveFileName, saveItem.saveID);
        }
        /// <summary>
        /// 保存对象至某个存档中
        /// </summary>
        /// <param name="saveObject">要保存的对象</param>
        /// <param name="saveID">存档的ID</param>
        public void SaveObject(object saveObject, int saveID = 0)
        {
            SaveObject(saveObject, saveObject.GetType().Name, saveID);
        }
        /// <summary>
        /// 保存对象至某个存档中
        /// </summary>
        /// <param name="saveObject">要保存的对象</param>
        /// <param name="saveID">存档的ID</param>
        public void SaveObject(object saveObject, SavePoint saveItem)
        {
            SaveObject(saveObject, saveObject.GetType().Name, saveItem);
        }

        /// <summary>
        /// 从某个具体的存档中加载某个对象
        /// </summary>
        /// <typeparam name="T">要返回的实际类型</typeparam>
        /// <param name="saveFileName">文件名称</param>
        /// <param name="id">存档ID</param>
        public T LoadObject<T>(string saveFileName, int saveID = 0) where T : class
        {
            T obj = GetCache<T>(saveID, saveFileName);
            if (obj == null)
            {
                // 存档所在的文件夹路径
                string dirPath = GetSavePath(saveID);
                if (dirPath == null) return null;
                // 具体的对象要保存的路径
                string savePath = dirPath + "/" + saveFileName;
                obj = LoadFile<T>(savePath);
                SetCache(saveID, saveFileName, obj);
            }
            return obj;
        }

        /// <summary>
        /// 从某个具体的存档中加载某个对象
        /// </summary>
        /// <typeparam name="T">要返回的实际类型</typeparam>
        /// <param name="saveFileName">文件名称</param>
        public T LoadObject<T>(string saveFileName, SavePoint saveItem) where T : class
        {
            return LoadObject<T>(saveFileName, saveItem.saveID);
        }


        /// <summary>
        /// 从某个具体的存档中加载某个对象
        /// </summary>
        /// <typeparam name="T">要返回的实际类型</typeparam>
        /// <param name="id">存档ID</param>
        public T LoadObject<T>(int saveID = 0) where T : class
        {
            return LoadObject<T>(typeof(T).Name, saveID);
        }

        /// <summary>
        /// 从某个具体的存档中加载某个对象
        /// </summary>
        /// <typeparam name="T">要返回的实际类型</typeparam>
        /// <param name="saveItem">存档项</param>
        public T LoadObject<T>(SavePoint saveItem) where T : class
        {
            return LoadObject<T>(typeof(T).Name, saveItem.saveID);
        }

        /// <summary>
        /// 删除某个存档中的某个对象
        /// </summary>
        /// <param name="saveID">存档的ID</param>
        public void DeleteObject<T>(string saveFileName, int saveID) where T : class
        {
            //清空缓存中对象
            if (GetCache<T>(saveID, saveFileName) != null)
            {
                RemoveCache(saveID, saveFileName);
            }
            // 存档对象所在的文件路径
            string dirPath = GetSavePath(saveID);
            string savePath = dirPath + "/" + saveFileName;
            //删除对应的文件
            File.Delete(savePath);

        }

        /// <summary>
        /// 删除某个存档中的某个对象
        /// </summary>
        /// <param name="saveID">存档的ID</param>
        public void DeleteObject<T>(string saveFileName, SavePoint saveItem) where T : class
        {
            DeleteObject<T>(saveFileName, saveItem.saveID);
        }

        /// <summary>
        /// 删除某个存档中的某个对象
        /// </summary>
        /// <param name="saveID">存档的ID</param>
        public void DeleteObject<T>(int saveID) where T : class
        {
            DeleteObject<T>(typeof(T).Name, saveID);
        }

        /// <summary>
        /// 删除某个存档中的某个对象
        /// </summary>
        /// <param name="saveID">存档的ID</param>
        public void DeleteObject<T>(SavePoint saveItem) where T : class
        {
            DeleteObject<T>(typeof(T).Name, saveItem.saveID);
        }
        #endregion

        #region 获取、删除所有用户存档

        /// <summary>
        /// 获取所有存档
        /// 最新的在最后面
        /// </summary>
        /// <returns></returns>
        public List<SavePoint> GetAllSaveItem()
        {
            return saveSystemData.saveItemList;
        }

        /// <summary>
        /// 获取所有存档
        /// 创建最新的在最前面
        /// </summary>
        /// <returns></returns>
        public List<SavePoint> GetAllSaveItemByCreatTime()
        {
            List<SavePoint> saveItems = new List<SavePoint>(saveSystemData.saveItemList.Count);

            for (int i = 0; i < saveSystemData.saveItemList.Count; i++)
            {
                saveItems.Add(saveSystemData.saveItemList[saveSystemData.saveItemList.Count - (i + 1)]);
            }
            return saveItems;
        }

        /// <summary>
        /// 获取所有存档
        /// 最新更新的在最上面
        /// </summary>
        /// <returns></returns>
        public List<SavePoint> GetAllSaveItemByUpdateTime()
        {
            List<SavePoint> saveItems = new List<SavePoint>(saveSystemData.saveItemList.Count);
            for (int i = 0; i < saveSystemData.saveItemList.Count; i++)
            {
                saveItems.Add(saveSystemData.saveItemList[i]);
            }
            OrderByUpdateTimeComparer orderBy = new OrderByUpdateTimeComparer();
            saveItems.Sort(orderBy);
            return saveItems;
        }

        private class OrderByUpdateTimeComparer : IComparer<SavePoint>
        {
            public int Compare(SavePoint x, SavePoint y)
            {
                if (x.LastSaveTime > y.LastSaveTime)
                {
                    return -1;
                }
                else
                {
                    return 1;
                }
            }
        }

        /// <summary>
        /// 获取所有存档
        /// 万能解决方案
        /// </summary>
        public List<SavePoint> GetAllSaveItem<T>(Func<SavePoint, T> orderFunc, bool isDescending = false)
        {
            if (isDescending)
            {
                return saveSystemData.saveItemList.OrderByDescending(orderFunc).ToList();
            }
            else
            {
                return saveSystemData.saveItemList.OrderBy(orderFunc).ToList();
            }

        }

        /// <summary>
        /// 删除所有用户存档信息
        /// </summary>
        public void DeleteAllSaveItem()
        {
            if (Directory.Exists(saveDirPath))
            {
                // 直接删除目录
                Directory.Delete(saveDirPath, true);
            }
            CheckAndCreateDir();
            InitSaveSystemData();
        }

        /// <summary>
        /// 删除所有存档信息
        /// </summary>
        public void DeleteAll()
        {
            CleanCache();
            DeleteAllSaveItem();
            DeleteAllSetting();
        }
        /// <summary>
        /// 输出当前的存档ID
        /// </summary>
        /// <returns></returns>
        #endregion

        #region 更新、获取、删除用户存档缓存
        /// <summary>
        /// 设置缓存
        /// </summary>
        /// <param name="saveID">存档ID</param>
        /// <param name="fileName">文件名称</param>
        /// <param name="saveObject">要缓存的对象</param>
        private void SetCache(int saveID, string fileName, object saveObject)
        {
            // 缓存字典中是否有这个SaveID
            if (cacheDic.ContainsKey(saveID))
            {
                // 这个存档中有没有这个文件
                if (cacheDic[saveID].ContainsKey(fileName))
                {
                    cacheDic[saveID][fileName] = saveObject;
                }
                else
                {
                    cacheDic[saveID].Add(fileName, saveObject);
                }
            }
            else
            {
                cacheDic.Add(saveID, new Dictionary<string, object>() { { fileName, saveObject } });
            }
        }

        /// <summary>
        /// 获取缓存
        /// </summary>
        /// <param name="saveID">存档ID</param>
        /// <param name="saveObject">要缓存的对象</param>
        private T GetCache<T>(int saveID, string fileName) where T : class
        {
            // 缓存字典中是否有这个SaveID
            if (cacheDic.ContainsKey(saveID))
            {
                // 这个存档中有没有这个文件
                if (cacheDic[saveID].ContainsKey(fileName))
                {
                    return cacheDic[saveID][fileName] as T;
                }
                else
                {
                    return null;
                }
            }
            else
            {
                return null;
            }
        }

        /// <summary>
        /// 移除缓存
        /// </summary>
        private void RemoveCache(int saveID)
        {
            cacheDic.Remove(saveID);
        }

        /// <summary>
        /// 移除缓存中的某一个对象
        /// </summary>
        private void RemoveCache(int saveID, string fileName)
        {
            cacheDic[saveID].Remove(fileName);
        }

        /// <summary>
        /// 清除存档缓存
        /// </summary>
        public void CleanCache()
        {
            cacheDic.Clear();
        }
        #endregion

        #region 内部工具函数
        /// <summary>
        /// 获取存档系统数据
        /// </summary>
        /// <returns></returns>
        //初始化SaveSystemData，存放SavePoint的列表
        private void InitSaveSystemData()
        {
            saveSystemData = LoadFile<SaveSystemData>(saveDirPath + "/SaveSystemData");
            if (saveSystemData == null)
            {
                saveSystemData = new SaveSystemData();
                UpdateSaveSystemData();
            }
        }

        private void UpdateSaveSystemData()
        {
            SaveFile(saveSystemData, saveDirPath + "/SaveSystemData");
        }
        //创建两个大的目录
        private void CheckAndCreateDir()
        {
            // 确保路径的存在
            if (Directory.Exists(saveDirPath) == false)
            {
                Directory.CreateDirectory(saveDirPath);
            }
            if (Directory.Exists(settingDirPath) == false)
            {
                Directory.CreateDirectory(settingDirPath);
            }
        }

        private string GetSavePath(int saveID, bool createDir = true)
        {
            // 验证是否有某个存档
            if (GetSaveItem(saveID) == null) Debug.LogWarning("saveID 存档不存在！");

            string saveDir = saveDirPath + "/" + saveID;
            // 确定文件夹是否存在
            if (Directory.Exists(saveDir) == false)
            {
                if (createDir)
                {
                    Directory.CreateDirectory(saveDir);
                }
                else
                {
                    return null;
                }
            }

            return saveDir;
        }
        private void SaveFile(object saveObject, string path)
        {
            SaveTool.SaveJson(saveObject, path);
        }

        private T LoadFile<T>(string path) where T : class
        {
            return SaveTool.LoadJson<T>(path);
        }
        #endregion
    }

}

