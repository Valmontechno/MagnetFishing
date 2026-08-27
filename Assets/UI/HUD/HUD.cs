using System;
using System.Collections;
using TMPro;
using UnityEngine;

public class HUD : MonoBehaviour
{
    GameManager gameManager;

    [SerializeField] GameObject interactionTooltip;
    [SerializeField] TextMeshProUGUI interactionTooltipText;
    [SerializeField] GameObject launchMagnetTooltip;
    [SerializeField] Transform toastMessageContainer;
    [SerializeField] GameObject toastTextPrefab;

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

    public void SetLaunchMagnetTooltipVisibility(bool visible)
    {
        launchMagnetTooltip.SetActive(visible);
    }

    public void ToastMessage(string message)
    {
        GameObject toastMessage = Instantiate(toastTextPrefab, toastMessageContainer);
        toastMessage.GetComponent<TextMeshProUGUI>().text = message;
    }
}
