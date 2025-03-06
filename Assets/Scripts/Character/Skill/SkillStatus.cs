using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
namespace skill
{
    public enum SkillAttackType
    {
        Single,
        Group
    }
    public enum SelectorType
    {
        Sector,//扇形
        Rectangle//矩形
    }
    ///<summary>
    ///
    ///<summary>
    [Serializable]
    public class SkillStatus
    {
        //技能ID
        public int skillID;
        //技能名称
        public string skillName;
        //技能描述
        public string skillDescription;
        //冷却时间
        public int coolTime;
        //冷却剩余
        public int coolRemain;
        //魔法消耗
        public int costSP;
        //攻击距离
        public float attackDistance;
        //攻击角度
        public float attackAngle;
        //攻击目标
        public string[] attackTargetTags = { "Enemy" };
        //攻击对象数组
        [HideInInspector]
        public Transform[] attackTargets;
        //技能影响类型
        public string[] impactType = { "CostSP", "Damage" };
        //连击的下一个技能编号
        public int nextBatterId;
        //伤害比率
        public float atkRatio;
        //持续时间
        public float durationTime;
        //伤害间隔
        public float atkIntervel;
        [HideInInspector]
        //技能所属
        public GameObject owner;
        //技能预制件名字
        public string prefabName;
        [HideInInspector]
        //预制件对象
        public GameObject skillPrefab;
        //动画名称
        public string animationName;
        //受到攻击的特效名字
        public string hitFxName;
        [HideInInspector]
        //收到攻击的预制件
        public GameObject hitFxPrefab;
        //技能等级
        public int level;
        //攻击类型，单攻，群攻
        public SkillAttackType attackType;
        //选择攻击类型，扇形，矩形
        public SelectorType selectorType;
    }
}

