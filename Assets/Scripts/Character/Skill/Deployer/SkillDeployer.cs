using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
namespace skill
{
    ///<summary>
    ///¼¼ÄÜÊÍ·ÅÆ÷
    ///<summary>
    public abstract class SkillDeployer : MonoBehaviour
    {
        private SkillStatus skillStatus;
        public SkillStatus SkillStatus
        {
            get
            {
                return skillStatus;
            }
            set
            {
                skillStatus = value;
                InitDeployer();
            }
        }
        private IAttackSelector selector;
        private IImpactEffect[] impactArray;
        private void InitDeployer()
        {
            selector = DeployerConfigFactory.CreateIAttackSelector(skillStatus);
            impactArray = DeployerConfigFactory.CreateIImpactEffect(skillStatus);
        }
        public void CalculateTargets()
        {
           skillStatus.attackTargets = selector.SelectTarget(skillStatus, transform);
        }
        public void ImpactTargets()
        {
            for (int i = 0; i < impactArray.Length; i++)
            {
                impactArray[i].Execute(this);
            }
        }
        public abstract void DeployerSkill();
    }
}

