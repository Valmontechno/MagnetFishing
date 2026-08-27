using System;
using UnityEngine;

public class Modal : MonoBehaviour
{
    public bool IsOpen { get; private set; } = false;

    void Awake()
    {
        if (!IsOpen)
        {
            gameObject.SetActive(false);
        }
    }

    public virtual void OpenModal()
    {
        IsOpen = true;
        GameManager.Instance.menu.openModalCount++;

        if (!GameManager.Instance.menu.IsMenuOpen && GameManager.Instance.menu.openModalCount == 1)
        {
            GameManager.Instance.PauseGame();
        }
        gameObject.SetActive(true);

        GameManager.Instance.hud.HideInteractionTooltip();

        AudioManager.Instance.PlayUI(UISound.Open);
    }

    public virtual void CloseModal()
    {
        if (!IsOpen) return;

        IsOpen = false;
        GameManager.Instance.menu.openModalCount--;

        if (!GameManager.Instance.menu.IsMenuOpen && GameManager.Instance.menu.openModalCount == 0)
        {
            GameManager.Instance.UnpauseGame();
        }
        gameObject.SetActive(false);

        AudioManager.Instance.PlayUI(UISound.Close);
    }
}
