using save;
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
namespace save
{
    ///<summary>
    ///
    ///<summary>
    /// <summary>
    /// 存档系统数据类
    /// </summary>
    [Serializable]
    public class SaveSystemData
    {
        // 当前的存档ID
        public int currID = 0;
        // 所有存档的列表
        public List<SavePoint> saveItemList = new List<SavePoint>();
    }

}

