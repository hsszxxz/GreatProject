using System.Collections;
using System.Collections.Generic;
using UnityEngine;
namespace FSM
{
    ///<summary>
    ///条件类
    ///<summary>
    public abstract  class FSMTrigger
    {
        public FSMTriggerID TriggerID { get; set; }
        /// <summary>
        /// 必须做初始化,写Id
        /// </summary>
        public FSMTrigger()
        {
            Init();
        }
        public abstract void Init();
        public abstract bool HandleTrigger(FSMBase fsm); 
    }
}

