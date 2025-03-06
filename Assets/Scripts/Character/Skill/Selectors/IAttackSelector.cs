using System.Collections;
using System.Collections.Generic;
using UnityEngine;
namespace skill
{
    ///<summary>
    ///
    ///<summary>
    public interface IAttackSelector
    {
        /// <summary>
        /// 搜索目标
        /// </summary>
        /// <param name="skill">技能数据</param>
        /// <param name="skillTF">技能所在的物体的transform</param>
        /// <returns></returns>
        public Transform[] SelectTarget(SkillStatus skill,Transform skillTF);
    }
}

