using System.Collections;
using System.Collections.Generic;
using UnityEngine;
namespace skill
{
    ///<summary>
    ///�����ͷ���
    ///<summary>
    public class CloseSkillDeployer : SkillDeployer
    {
        public override void DeployerSkill()
        {
            CalculateTargets();
            ImpactTargets();
        }
    }
}

