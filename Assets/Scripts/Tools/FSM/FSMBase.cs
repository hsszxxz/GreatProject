using System.Collections;
using System.Collections.Generic;
using UnityEditorInternal;
using UnityEngine;
using Character;
namespace FSM
{
    ///<summary>
    ///
    ///<summary>
    public class FSMBase : MonoBehaviour
    {
        private List<FSMState> states;
        [Tooltip("默认状态ID")]
        public FSMStateID defaultStateID;
        private FSMState currentState;
        private FSMState defaultState;

        #region 查找数据
        [HideInInspector]
        public CharacterBasic characterBasic;
        private CharacterControl characterControl;
        private void InitComponent()
        {
            characterControl = GetComponent<CharacterControl>();
            characterBasic = characterControl.characterBasic;
        }
        #endregion

        private void Start()
        {
            InitComponent();
            ConfigFSM();
            InitDefualtState();
        }
        private void ConfigFSM()
        {
            states = new List<FSMState>();
            IdleState idle = new IdleState();
            idle.AddMap(FSMTriggerID.NoHealth, FSMStateID.Dead);
            states.Add(idle);
            DeadState dead = new DeadState();
            states.Add(dead);
        }
        private void InitDefualtState()
        {
            defaultState = states.Find(s=> s.StateID == defaultStateID);
            currentState = defaultState;
            currentState.EnterState(this);
        }
        public void Update()
        {
            currentState.Reason(this);//检测
            currentState.ActionState(this);
        }
        public void ChangeActiveState(FSMStateID stateID)
        {
            currentState.ExitState(this);
            currentState = stateID== FSMStateID.Default ? defaultState : states.Find(s => s.StateID == stateID);
            currentState.EnterState(this);
        }
    }
}

