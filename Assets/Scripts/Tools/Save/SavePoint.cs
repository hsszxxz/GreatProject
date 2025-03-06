using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
namespace save
{
    /// <summary>
    /// 一个存档数据
    /// </summary>
    [Serializable]
    public class SavePoint
    {
        // 存档ID
        public int saveID;

        // 私有字段，最后保存时间
        private DateTime lastSaveTime;

        // 公共属性，获取最后保存时间
        public DateTime LastSaveTime
        {
            get
            {
                // 如果 lastSaveTime 是默认值，则尝试将字符串解析为 DateTime
                if (lastSaveTime == default(DateTime))
                {
                    DateTime.TryParse(lastSaveTimeString, out lastSaveTime);
                }
                return lastSaveTime; // 返回最后保存时间
            }
        }

        // 用于持久化的字符串，Json不支持 DateTime 类型
        [SerializeField] private string lastSaveTimeString;

        // 构造函数，初始化存档ID和最后保存时间
        public SavePoint(int saveID, DateTime lastSaveTime)
        {
            this.saveID = saveID; // 设置存档ID
            this.lastSaveTime = lastSaveTime; // 设置最后保存时间
            lastSaveTimeString = lastSaveTime.ToString(); // 将 DateTime 转换为字符串
        }

        // 更新最后保存时间
        public void UpdateTime(DateTime lastSaveTime)
        {
            this.lastSaveTime = lastSaveTime; // 更新最后保存时间
            lastSaveTimeString = lastSaveTime.ToString(); // 将新的 DateTime 转换为字符串
        }
    }

}

