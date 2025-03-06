using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
namespace skill
{
    ///<summary>
    ///�����ͷ�����ʼ����Ѱ�ң���Ӧ����
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
            //ѡ��������������
            //�����ռ�.+ö����+AttackSelector     Ϊ�˴���һ������
            string className = string.Format("skill.{0}AttackSelector", skillStatus.selectorType);
            return CreateObject<IAttackSelector>(className);
        }
        public static IImpactEffect[] CreateIImpactEffect(SkillStatus skillStatus)
        {
            IImpactEffect[] impactEffects = new IImpactEffect[skillStatus.impactType.Length];
            //Ӱ��Ч�������淶��
            //�����ռ�.+impactType[?]+Impact
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

