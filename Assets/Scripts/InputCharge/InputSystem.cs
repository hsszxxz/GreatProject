using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem.XR;
using UnityEngine.Windows;
namespace Input
{
    public delegate void PlaneMoveMethod(Vector2 dir);
    public class InputSystem : MonoSingleton<InputSystem>
    {
        private InputControl control;
        public event PlaneMoveMethod planeMoveMethod;
        private bool isMove = false;
        private Vector2 moveDir = Vector2.zero;
        public override void Init()
        {
            base.Init();
            control = new InputControl();
        }
        public void RegistInputControl()
        {
            isMove = true;
            control.MainSceneMap.Move.performed += input => { moveDir =input.ReadValue<Vector2>(); };
            control.MainSceneMap.Move.canceled += Input => { moveDir = Vector2.zero; };
            control.Enable();
        }
        private void Update()
        {
            if (isMove)
            {
                planeMoveMethod.Invoke(moveDir);
            }
        }
    }
}
