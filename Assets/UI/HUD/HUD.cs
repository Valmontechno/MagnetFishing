using System;
using TMPro;
using UnityEngine;

public class HUD : MonoBehaviour
{
    GameManager gameManager;

    [SerializeField] GameObject interactionTooltip;
    [SerializeField] TextMeshProUGUI interactionTooltipText;

    private void Start()
    {
        gameManager = GameManager.Instance;

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
}
