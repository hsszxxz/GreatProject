using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Character;
namespace skill
{
    ///<summary>
    ///
    ///<summary>
    public class CostSPImpact : IImpactEffect
    {
        public void Execute(SkillDeployer deployer)
        {
            var status =deployer.SkillStatus.owner.GetComponent<CharacterBasic>();
            if (status == null)
            {
                Debug.LogError("未找到技能释放者");
            }
            else
            {
                //status.characterSP -= deployer.SkillStatus.costSP;
            }
        }
    }
}

