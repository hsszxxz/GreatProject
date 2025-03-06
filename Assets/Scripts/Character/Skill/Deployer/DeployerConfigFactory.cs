using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
namespace skill
{
    ///<summary>
    ///帮助释放器初始化（寻找）对应对象
    ///<summary>
    public static class DeployerConfigFactory 
    {
        private static Dictionary<string, object> cache;
        static DeployerConfigFactory()
        {
            cache = new Dictionary<string, object>();
        }
        public static IAttackSelector CreateIAttackSelector(SkillStatus skillStatus)
        {
            //skillStatus.selectorType
            //选区对象命名规则
            //命名空间.+枚举名+AttackSelector     为了创建一个对象
            string className = string.Format("skill.{0}AttackSelector", skillStatus.selectorType);
            return CreateObject<IAttackSelector>(className);
        }
        public static IImpactEffect[] CreateIImpactEffect(SkillStatus skillStatus)
        {
            IImpactEffect[] impactEffects = new IImpactEffect[skillStatus.impactType.Length];
            //影响效果命名规范：
            //命名空间.+impactType[?]+Impact
            for (int i = 0; i < skillStatus.impactType.Length; i++)
            {
                string impactName = string.Format("skill.{0}Impact", skillStatus.impactType[i]);
                impactEffects[i] = CreateObject<IImpactEffect>(impactName);
            }
            return impactEffects;
        }
        private static T CreateObject<T>(string className) where T : class
        {
            if (!cache.ContainsKey(className))
            {
                Type type = Type.GetType(className);
                 object instance =Activator.CreateInstance(type);
                cache.Add(className, instance);
            }
            return cache[className] as T;
        }
    }
}

