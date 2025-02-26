using Input;
using MotorSpace;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
namespace Character
{
    public class CharacterControl : MonoBehaviour
    {
        public CharacterBasic characterBasic;
        private Motor characterMotor;
        private void Start()
        {
            characterMotor = new CharacterMotor(transform, characterBasic);
            InputSystem.Instance.planeMoveMethod += characterMotor.BasicPlaneMoveMethod;
            InputSystem.Instance.RegistInputControl();
        }
    }
}
