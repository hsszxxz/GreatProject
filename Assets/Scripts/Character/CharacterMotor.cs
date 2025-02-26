using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using MotorSpace;
namespace Character
{
    public class CharacterMotor : Motor
    {
        private Transform character;
        private CharacterController controller;
        private float speed;
        private float gravity;
        private float rotationSpeed;
        public CharacterMotor(Transform characterTransform, CharacterBasic characterBasic)
        {
            character = characterTransform;
            controller = characterTransform.GetComponent<CharacterController>();
            speed =characterBasic.CharacterMoveSpeed;
            gravity = characterBasic.CharacterGravity;
            rotationSpeed = characterBasic.CharacterRotationSpeed;
        }
        public override void BasicPlaneMoveMethod(Vector2 dir)
        {
            Vector3 move = character.right*dir.x+ character.forward*dir.y;
            if (move.magnitude > 0.1f)
            {
                Quaternion targetRotation = Quaternion.LookRotation(move);
                character.rotation = Quaternion.Lerp(character.rotation, targetRotation, rotationSpeed * Time.deltaTime);
            }
            move.y = - gravity*Time.deltaTime;
            controller.Move(move * speed * Time.deltaTime);
        }
    }
}
