using UnityEngine;

public class SoccerGoalQuest : MonoBehaviour
{
    [SerializeField] Achievement achievement;

    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Ball"))
        {
            GameManager.Instance.UnlockAchievement(achievement);
        }
    }
}
