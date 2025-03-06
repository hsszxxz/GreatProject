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
        Sector,//����
        Rectangle//����
    }
    ///<summary>
    ///
    ///<summary>
    [Serializable]
    public class SkillStatus
    {
        //����ID
        public int skillID;
        //��������
        public string skillName;
        //��������
        public string skillDescription;
        //��ȴʱ��
        public int coolTime;
        //��ȴʣ��
        public int coolRemain;
        //ħ������
        public int costSP;
        //��������
        public float attackDistance;
        //�����Ƕ�
        public float attackAngle;
        //����Ŀ��
        public string[] attackTargetTags = { "Enemy" };
        //������������
        [HideInInspector]
        public Transform[] attackTargets;
        //����Ӱ������
        public string[] impactType = { "CostSP", "Damage" };
        //��������һ�����ܱ��
        public int nextBatterId;
        //�˺�����
        public float atkRatio;
        //����ʱ��
        public float durationTime;
        //�˺����
        public float atkIntervel;
        [HideInInspector]
        //��������
        public GameObject owner;
        //����Ԥ�Ƽ�����
        public string prefabName;
        [HideInInspector]
        //Ԥ�Ƽ�����
        public GameObject skillPrefab;
        //��������
        public string animationName;
        //�ܵ���������Ч����
        public string hitFxName;
        [HideInInspector]
        //�յ�������Ԥ�Ƽ�
        public GameObject hitFxPrefab;
        //���ܵȼ�
        public int level;
        //�������ͣ�������Ⱥ��
        public SkillAttackType attackType;
        //ѡ�񹥻����ͣ����Σ�����
        public SelectorType selectorType;
    }
}

