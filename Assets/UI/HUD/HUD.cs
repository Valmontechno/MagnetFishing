using System;
using System.Collections;
using TMPro;
using UnityEngine;
using UnityEngine.Audio;

public class HUD : MonoBehaviour
{
    GameManager gameManager;

    [SerializeField] GameObject interactionTooltip;
    [SerializeField] TextMeshProUGUI interactionTooltipText;
    [SerializeField] GameObject launchMagnetTooltip;
    [SerializeField] Transform toastMessageContainer;
    [SerializeField] GameObject toastTextPrefab;
    [SerializeField] AudioResource achievementSound;
    [SerializeField] Animation achievementAnimation;
    AchievementCard achievementCard;

    private void Awake()
    {
        gameManager = GameManager.Instance;
        gameManager.hud = this;

        achievementCard = achievementAnimation.GetComponentInChildren<AchievementCard>();

        gameManager.OnInteractiveObjectChange += OnInteractiveObjectChange;
    }

    private void OnDestroy()
    {
        gameManager.OnInteractiveObjectChange -= OnInteractiveObjectChange;
    }

    private void OnInteractiveObjectChange()
    {
        if (gameManager.InteractiveObject != null)
        {
            ShowInteractionTooltip(gameManager.InteractiveObject.interactionName);
        }
        else
        {
            HideInteractionTooltip();
        }
    }

    public void ShowInteractionTooltip(string message)
    {
        interactionTooltip.SetActive(true);
        interactionTooltipText.text = message;
    }

    public void HideInteractionTooltip()
    {
        interactionTooltip.SetActive(false);
    }

    public void SetLaunchMagnetTooltipVisibility(bool visible)
    {
        launchMagnetTooltip.SetActive(visible);
    }

    public void ToastMessage(string message)
    {
        GameObject toastMessage = Instantiate(toastTextPrefab, toastMessageContainer);
        toastMessage.GetComponent<TextMeshProUGUI>().text = message;
    }

    public void UnlockAchievement(Achievement achievement)
    {
        achievementCard.Init(achievement, true);
        achievementAnimation.Stop();
        achievementAnimation.Play();
        AudioManager.Instance.PlayUI(achievementSound);
    }
}
