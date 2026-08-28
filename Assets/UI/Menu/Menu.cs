using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using TMPro;
using UnityEngine;
using UnityEngine.Audio;
using UnityEngine.InputSystem;
using UnityEngine.UI;

public class Menu : MonoBehaviour
{
    GameManager gameManager;
    AudioManager audioManager;

    [Header("Menu")]
    [SerializeField] GameObject menu;
    [SerializeField] HUD hud;
    public bool IsMenuOpen { get; private set; }
    [Serializable] struct Tab { public Button button; public GameObject content; }
    [SerializeField] Tab[] tabs;

    [Space]
    [SerializeField] Toggle enableScrollToggle;
    [SerializeField] Slider mouseSensitivitySlider;
    [Multiline, SerializeField] string enableScrollMessage;

    [Space]
    [SerializeField] TextMeshProUGUI moneyText;
    [SerializeField] Transform itemSlotGrid;
    [SerializeField] GameObject itemSlotButtonPrefab;

    [Space]
    [SerializeField] Transform achievementCardGrid;
    [SerializeField] GameObject achievementCardPrefab;
    [ReorderableList] [SerializeField] Achievement[] achievements;


    [Header("Modals")]
    public ItemRecordModal itemRecordModal;
    public BikeQuestModal bikeQuestModal;
    [SerializeField] AlertModal alertModal;
    public int openModalCount = 0;



    private void Awake()
    {
        gameManager = GameManager.Instance;
        gameManager.menu = this;
        audioManager = AudioManager.Instance;

        IsMenuOpen = false;
    }

    private void Start()
    {
        gameManager.InputActions.Player.OpenMenu.performed += OpenMenu;
        gameManager.InputActions.Boat.OpenMenu.performed += OpenMenu;
        gameManager.InputActions.Menu.CloseMenu.performed += CloseMenu;

        menu.SetActive(false);
        itemRecordModal.CloseModal();

        for (int i = 0; i < tabs.Length; i++)
        {
            tabs[i].button.interactable = i != 0;
            tabs[i].content.SetActive(i == 0);
        }
    }

    private void OnDestroy()
    {
        gameManager.InputActions.Player.OpenMenu.performed -= OpenMenu;
        gameManager.InputActions.Boat.OpenMenu.performed -= OpenMenu;
        gameManager.InputActions.Menu.CloseMenu.performed -= CloseMenu;
    }

    private void OpenMenu(InputAction.CallbackContext context)
    {
        IsMenuOpen = true;
        menu.SetActive(true);
        gameManager.PauseGame();
        gameManager.ShowMouse();
        hud.gameObject.SetActive(false);

        enableScrollToggle.isOn = gameManager.GameSettings.scrollEnabled;
        mouseSensitivitySlider.value = Mathf.Log(gameManager.GameSettings.mouseSensitivity, 2);

        int money = gameManager.money;
        float gramMass = gameManager.GetTotalGramMasse() / 1000f;
        moneyText.text = string.Format(CultureInfo.GetCultureInfo("fr-FR"), "{0:N0}\n{1:N3}", money, gramMass);

        List<Item> items = gameManager.Inventory.Keys.ToList();
        items.Sort((a, b) => gameManager.Inventory[b].registrationIndex - gameManager.Inventory[a].registrationIndex);
        foreach (Item item in items)
        {
            GameObject itemSlotButton = Instantiate(itemSlotButtonPrefab, itemSlotGrid);
            itemSlotButton.GetComponent<ItemSlotButton>().Init(this, item);
        }

        foreach (Achievement achievement in achievements)
        {
            GameObject achievementCard = Instantiate(achievementCardPrefab, achievementCardGrid);
            achievementCard.GetComponent<AchievementCard>().Init(achievement, gameManager.Achievements.Contains(achievement));
        }

        audioManager.PlayUI(UISound.Open);
    }

    private void CloseMenu(InputAction.CallbackContext context)
    {
        if (IsMenuOpen)
        {
            Resume();
        }
    }

    public void Resume()
    {
        IsMenuOpen = false;
        menu.SetActive(false);
        gameManager.ApplySettings();
        gameManager.UnpauseGame();
        gameManager.HideMouse();
        hud.gameObject.SetActive(true);

        if (itemRecordModal.IsOpen)
            itemRecordModal.CloseModal();
        if (alertModal.IsOpen)
            alertModal.CloseModal();

        Debug.Assert(openModalCount == 0);

        while (itemSlotGrid.childCount > 0)
            DestroyImmediate(itemSlotGrid.GetChild(0).gameObject);
        while (achievementCardGrid.childCount > 0)
            DestroyImmediate(achievementCardGrid.GetChild(0).gameObject);

        audioManager.PlayUI(UISound.Close);
    }

    public void SetTab(int index)
    {
        for (int i = 0; i < tabs.Length; i++)
        {
            tabs[i].button.interactable = i != index;
            tabs[i].content.SetActive(i == index);
        }
        audioManager.PlayUI(UISound.Tab);
    }

    public void Quit()
    {
        audioManager.PlayUI(UISound.Close);
        gameManager.QuitGame();
    }

    public void SetScrollEnabled(bool enabled)
    {
        audioManager.PlayUI(UISound.Click);
        gameManager.GameSettings.scrollEnabled = enabled;

        if (enabled)
        {
            Alert(enableScrollMessage, false);
        }
    }

    public void SetMouseSensitivity(float value)
    {
        gameManager.GameSettings.mouseSensitivity = Mathf.Pow(2, value);
    }

    public void Alert(string message, bool showMouse=false)
    {
        alertModal.OpenModal(message, showMouse);
    }
}
