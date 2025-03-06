using System.Collections;
using System.Collections.Generic;
using UnityEngine;
namespace skill
{
    ///<summary>
    ///影响效果的算法
    ///<summary>
    public interface IImpactEffect
    {
        void Execute(SkillDeployer deployer);
    }
}

