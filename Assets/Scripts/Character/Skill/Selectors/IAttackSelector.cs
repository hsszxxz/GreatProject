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
        /// ����Ŀ��
        /// </summary>
        /// <param name="skill">��������</param>
        /// <param name="skillTF">�������ڵ������transform</param>
        /// <returns></returns>
        public Transform[] SelectTarget(SkillStatus skill,Transform skillTF);
    }
}

