using TMPro;
using UnityEngine;

public class AchievementCard : MonoBehaviour
{
    [SerializeField] TextMeshProUGUI titleText;
    [SerializeField] TextMeshProUGUI descriptionText;

    public void Init(Achievement achievement)
    {
        titleText.text = achievement.title;
        descriptionText.text = achievement.description;
    }
}
