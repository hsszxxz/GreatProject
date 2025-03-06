using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Character;
namespace skill
{
    ///<summary>
    ///
    ///<summary>
    public class CharacterSkillManage : MonoBehaviour
    {
        //�����б�
        public SkillStatus[] skillStatus;
        private CharacterControl characterControl;
        private CharacterBasic characterBasic;
        private void Start ()
        {
            for (int i = 0; i < skillStatus.Length; i++)
            {
                InitSkill(skillStatus[i]);
            }
            characterControl = GetComponent<CharacterControl>();
            characterBasic = characterControl.characterBasic;
        }
        //��ʼ��
        private void InitSkill(SkillStatus skill)
        {
            skill.skillPrefab = ResourceManager.Load<GameObject>(skill.prefabName);
            skill.owner = gameObject;
        }
        //�����ͷ���������ȴ������
        public SkillStatus PrepareSkill(int id)
        {
            SkillStatus skill = skillStatus.ArrayFind(s => s.skillID == id);
            if (skill != default(SkillStatus) && skill.coolRemain<=0&& skill.costSP <= characterBasic.characterSP)
            {
                return skill;
            }
            else
            {
                return null;
            }
        }
        //���ɼ���
        public void GenerateSkill(SkillStatus skill)
        {
           // GameObject skillGo= Instantiate(skill.skillPrefab, transform.position, transform.rotation);
            GameObject skillGo = GameObjectPool.Instance.CreateObject(skill.prefabName, skill.skillPrefab, transform.position, transform.rotation);

            SkillDeployer skillDeployer = skillGo.GetComponent<SkillDeployer>();
            skillDeployer.SkillStatus = skill;
            skillDeployer.DeployerSkill();

            GameObjectPool.Instance.CollectObject(skillGo,skill.durationTime);
            //Destroy(skillGo,skill.durationTime);
            StartCoroutine(CoolTimeDown(skill));
        }
        //������ȴ
        private IEnumerator CoolTimeDown(SkillStatus skill)
        {
            skill.coolRemain = skill.coolTime;
            while (skill.coolRemain > 0)
            {
                yield return new WaitForSeconds(1);
                skill.coolRemain--;
            }
        }
    }
}

