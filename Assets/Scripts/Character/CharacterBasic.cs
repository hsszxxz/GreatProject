using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
namespace Character
{

    [Serializable]
    public class CharacterBasic
    {
        [Tooltip("��ɫ�ƶ��ٶ�")]
        public float CharacterMoveSpeed;
        [Tooltip("��ɫ�ܵ�������")]
        public float CharacterGravity;
        [Tooltip("��ɫ����ת�ٶ�")]
        public float CharacterRotationSpeed;
    }
}
