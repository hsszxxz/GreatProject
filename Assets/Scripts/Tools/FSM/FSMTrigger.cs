using System.Collections;
using System.Collections.Generic;
using UnityEngine;
namespace FSM
{
    ///<summary>
    ///������
    ///<summary>
    public abstract  class FSMTrigger
    {
        public FSMTriggerID TriggerID { get; set; }
        /// <summary>
        /// ��������ʼ��,дId
        /// </summary>
        public FSMTrigger()
        {
            Init();
        }
        public abstract void Init();
        public abstract bool HandleTrigger(FSMBase fsm); 
    }
}

