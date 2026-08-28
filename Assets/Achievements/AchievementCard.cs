using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class AchievementCard : MonoBehaviour
{
    [SerializeField] TextMeshProUGUI titleText;
    [SerializeField] Image image;

    public void Init(Achievement achievement, bool uncloked)
    {
        image.sprite = achievement.icon;

        if (uncloked)
        {
            titleText.text = $"<size=18><b>{achievement.title}</b></size><size=8>\n\n</size>{achievement.description}";
        }
        else
        {
            titleText.text = "<size=18><b>???</b></size><size=8>";
            image.color = Color.black;
        }
    
    }
}
