using System.Collections;
using System.Collections.Generic;
using UnityEngine;
namespace FSM
{
    ///<summary>
    ///
    ///<summary>
    public class IdleState:FSMState
    {
        public override void Init()
        {
            StateID = FSMStateID.Idle;
        }
        public override void EnterState(FSMBase fsm)
        {
            base.EnterState(fsm);   
            //可以放一个播动画的
        }
        public override void ExitState(FSMBase fsm)
        {
            base.ExitState(fsm);
        }
    }
}

