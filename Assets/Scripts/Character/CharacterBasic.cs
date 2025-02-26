using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
namespace Character
{

    [Serializable]
    public class CharacterBasic
    {
        [Tooltip("角色移动速度")]
        public float CharacterMoveSpeed;
        [Tooltip("角色受到的重力")]
        public float CharacterGravity;
        [Tooltip("角色的旋转速度")]
        public float CharacterRotationSpeed;
    }
}
