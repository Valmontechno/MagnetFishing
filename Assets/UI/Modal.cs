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

        if (!GameManager.Instance.menu.IsMenuOpen)
        {
            GameManager.Instance.PauseGame();
        }
        gameObject.SetActive(true);

        AudioManager.Instance.PlayUI(UISound.Open);
    }

    public virtual void CloseModal()
    {
        if (!IsOpen) return;

        IsOpen = false;

        if (!GameManager.Instance.menu.IsMenuOpen)
        {
            GameManager.Instance.UnpauseGame();
        }
        gameObject.SetActive(false);

        AudioManager.Instance.PlayUI(UISound.Close);
    }
}
