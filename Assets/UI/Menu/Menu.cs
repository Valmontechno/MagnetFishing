using System;
using System.Collections.Generic;
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
    [SerializeField] Toggle EnableScrollToggle;
    [SerializeField] Slider mouseSensitivitySlider;

    [Space]
    [SerializeField] Transform itemSlotGrid;
    [SerializeField] GameObject itemSlotButtonPrefab;


    [Header("Modals")]
    public ItemRecordModal itemRecordModal;
    public BikeQuestModal bikeQuestModal;


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
    }

    private void OnDestroy()
    {
        gameManager.InputActions.Player.OpenMenu.performed -= OpenMenu;
        gameManager.InputActions.Boat.OpenMenu.performed -= OpenMenu;
        gameManager.InputActions.Menu.CloseMenu.performed -= CloseMenu;
    }

    private void Update()
    {
        //if (itemRecordModal.IsOpen)
        //{
        //    if (gameManager.InputActions.Menu.GrabItemVisual.ReadValue<float>() > 0)
        //    {
        //        Vector2 input = gameManager.InputActions.Menu.RotateItemVisual.ReadValue<Vector2>();
        //        rotateItemVisualVelocity.x = -input.x * rotateItemVisualSpeed;
        //        rotateItemVisualVelocity.y = input.y * rotateItemVisualSpeed;
        //    }
        //    else
        //    {
        //        rotateItemVisualVelocity *= 0.9f;
        //    }

        //    Vector3 rotation = shootingCamera.transform.eulerAngles;
        //    rotation.y -= rotateItemVisualVelocity.x * Time.unscaledDeltaTime;
        //    rotation.x -= rotateItemVisualVelocity.y * Time.unscaledDeltaTime;
        //    rotation.x = Mathf.Clamp(Utils.Warp180(rotation.x), -90, 90);
        //    shootingCamera.transform.rotation = Quaternion.Euler(rotation);
        //}
    }

    private void OpenMenu(InputAction.CallbackContext context)
    {
        IsMenuOpen = true;
        menu.SetActive(true);
        gameManager.PauseGame();
        gameManager.ShowMouse();
        hud.gameObject.SetActive(false);

        EnableScrollToggle.isOn = gameManager.GameSettings.scrollEnabled;
        mouseSensitivitySlider.value = Mathf.Log(gameManager.GameSettings.mouseSensitivity, 2);

        List<Item> items = gameManager.Inventory.Keys.ToList();
        items.Sort((a, b) => gameManager.Inventory[a].registrationIndex - gameManager.Inventory[b].registrationIndex);
        foreach (Item item in items)
        {
            GameObject itemSlotButton = Instantiate(itemSlotButtonPrefab, itemSlotGrid);
            itemSlotButton.GetComponent<ItemSlotButton>().Init(this, item);
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
            //CloseItemRecord();

        while (itemSlotGrid.childCount > 0)
            DestroyImmediate(itemSlotGrid.GetChild(0).gameObject);

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
    }

    public void SetMouseSensitivity(float value)
    {
        gameManager.GameSettings.mouseSensitivity = Mathf.Pow(2, value);
    }

    //public void OpenItemRecord(Item item, bool pauseGame)
    //{
    //    OpenItemRecord(item, pauseGame, gameManager.Inventory[item]);
    //}

    //public void OpenItemRecord(Item item, bool pauseGame, ItemSlot itemSlot)
    //{
    //    this.itemSlot = itemSlot;

    //    itemRecordModal.OpenModal(pauseGame);

    //    itemRecordNameInput.text = itemSlot.userName;
    //    if (itemSlot.userName == "")
    //        itemRecordNameInput.Select();

    //    shootingCamera.StartShooting(item);
    //}

    //public void CloseItemRecord()
    //{
    //    itemRecordModal.CloseModal();

    //    shootingCamera.EndShooting();
    //}

    //public void SetItemRecordName(string name)
    //{
    //    itemSlot.userName = name;
    //}
}
