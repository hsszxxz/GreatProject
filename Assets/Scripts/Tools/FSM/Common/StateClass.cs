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
        None,//��״̬
        Idle,//����
        Dead,//����
        Pursuit,//׷��
        Attacking,//����
        Default,//Ĭ��
        Patrolling//Ѳ��
    }

    public enum FSMTriggerID
    {
        NoHealth,//����Ϊ0
        SawTarget,//����Ŀ��
        ReachTarget,//Ŀ����빥����Χ
        LoseTarget,//��ʧĿ��
        CompletePatrol,//���Ѳ��
        KilledTarget,//��ɱĿ��
        WithoutAttackRange//Ŀ���뿪/���ڹ�����Χ
    }
}

