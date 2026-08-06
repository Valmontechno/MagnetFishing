using System;
using UnityEngine;
using UnityEngine.InputSystem;
using UnityEngine.UI;

public class Menu : MonoBehaviour
{
    GameManager gameManager;

    [Space]
    [SerializeField] GameObject menu;

    [Serializable] struct Tab { public Button button; public GameObject content; }
    [Space]
    [SerializeField] Tab[] tabs;

    [Space]
    [SerializeField] Toggle EnableScrollToggle;

    private void Start()
    {
        gameManager = GameManager.Instance;

        gameManager.InputActions.Player.OpenMenu.performed += OpenMenu;
        gameManager.InputActions.Boat.OpenMenu.performed += OpenMenu;
        gameManager.InputActions.Menu.CloseMenu.performed += CloseMenu;

        menu.SetActive(false);
    }

    private void OnDestroy()
    {
        gameManager.InputActions.Player.OpenMenu.performed -= OpenMenu;
        gameManager.InputActions.Boat.OpenMenu.performed -= OpenMenu;
        gameManager.InputActions.Menu.CloseMenu.performed -= CloseMenu;
    }

    private void OpenMenu(InputAction.CallbackContext context)
    {
        menu.SetActive(true);
        gameManager.InputActions.Menu.Enable();
        gameManager.PauseGame();

        EnableScrollToggle.isOn = gameManager.GameSettings.scrollEnabled;
    }

    private void CloseMenu(InputAction.CallbackContext context)
    {
        Resume();
    }

    public void Resume()
    {
        menu.SetActive(false);
        gameManager.InputActions.Menu.Disable();
        gameManager.ApplySettings();
        gameManager.UnpauseGame();
    }

    public void SetTab(int index)
    {
        for (int i = 0; i < tabs.Length; i++)
        {
            tabs[i].button.interactable = i != index;
            tabs[i].content.SetActive(i == index);
        }
    }

    public void Quit()
    {
#if UNITY_EDITOR
        UnityEditor.EditorApplication.ExitPlaymode();
#else
        Application.Quit();
#endif
    }

    public void SetScrollEnabled(bool enabled)
    {
        gameManager.GameSettings.scrollEnabled = enabled;
    }
}
