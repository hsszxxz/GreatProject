using System.Collections;
using System.Collections.Generic;
using UnityEngine;
namespace FSM
{
    ///<summary>
    ///
    ///<summary>
    public enum FSMStateID
    {
        None,//无状态
        Idle,//待机
        Dead,//死亡
        Pursuit,//追逐
        Attacking,//攻击
        Default,//默认
        Patrolling//巡逻
    }

    public enum FSMTriggerID
    {
        NoHealth,//生命为0
        SawTarget,//发现目标
        ReachTarget,//目标进入攻击范围
        LoseTarget,//丢失目标
        CompletePatrol,//完成巡逻
        KilledTarget,//击杀目标
        WithoutAttackRange//目标离开/不在攻击范围
    }
}

