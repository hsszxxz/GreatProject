using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Character;
namespace FSM
{
    ///<summary>
    ///没有生命条件
    ///<summary>
    public class NoHealthTrigger : FSMTrigger
    {
        public override bool HandleTrigger(FSMBase fsm)
        {
            return fsm.characterBasic.blood <= 0;
        }

        public override void Init()
        {
            TriggerID = FSMTriggerID.NoHealth;
        }
    }
}

