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

    [Header("Menu")]
    [SerializeField] GameObject menu;
    bool menuOpen = false;
    [Serializable] struct Tab { public Button button; public GameObject content; }
    [SerializeField] Tab[] tabs;

    [Space]
    [SerializeField] Toggle EnableScrollToggle;
    [SerializeField] Slider mouseSensitivitySlider;

    [Space]
    [SerializeField] Transform itemSlotGrid;
    [SerializeField] GameObject itemSlotButtonPrefab;


    [Header("Item Record")]
    [SerializeField] GameObject itemRecord;
    [SerializeField] TMP_InputField itemRecordNameInput;
    [SerializeField] float rotateItemVisualSpeed;
    [SerializeField] ShootingCamera shootingCamera;
    public bool ItemRecordOpen { get; private set; }
    bool itemRecordPauseGame;
    ItemSlot itemSlot;
    Vector2 rotateItemVisualVelocity;


    private void Start()
    {
        gameManager = GameManager.Instance;

        gameManager.InputActions.Player.OpenMenu.performed += OpenMenu;
        gameManager.InputActions.Boat.OpenMenu.performed += OpenMenu;
        gameManager.InputActions.Menu.CloseMenu.performed += CloseMenu;

        menu.SetActive(false);
        itemRecord.SetActive(false);
    }

    private void OnDestroy()
    {
        gameManager.InputActions.Player.OpenMenu.performed -= OpenMenu;
        gameManager.InputActions.Boat.OpenMenu.performed -= OpenMenu;
        gameManager.InputActions.Menu.CloseMenu.performed -= CloseMenu;
    }

    private void Update()
    {
        if (ItemRecordOpen)
        {
            if (gameManager.InputActions.Menu.GrabItemVisual.ReadValue<float>() > 0)
            {
                Vector2 input = gameManager.InputActions.Menu.RotateItemVisual.ReadValue<Vector2>();
                rotateItemVisualVelocity.x = -input.x * rotateItemVisualSpeed;
                rotateItemVisualVelocity.y = input.y * rotateItemVisualSpeed;
            }
            else
            {
                rotateItemVisualVelocity *= 0.9f;
            }

            Vector3 rotation = shootingCamera.transform.eulerAngles;
            rotation.y -= rotateItemVisualVelocity.x * Time.unscaledDeltaTime;
            rotation.x -= rotateItemVisualVelocity.y * Time.unscaledDeltaTime;
            rotation.x = Mathf.Clamp(Utils.Warp180(rotation.x), -90, 90);
            shootingCamera.transform.rotation = Quaternion.Euler(rotation);
        }
    }

    private void OpenMenu(InputAction.CallbackContext context)
    {
        menuOpen = true;
        menu.SetActive(true);
        gameManager.PauseGame();

        EnableScrollToggle.isOn = gameManager.GameSettings.scrollEnabled;
        mouseSensitivitySlider.value = Mathf.Log(gameManager.GameSettings.mouseSensitivity, 2);

        List<Item> items = gameManager.Inventory.Keys.ToList();
        items.Sort((a, b) => gameManager.Inventory[a].registrationIndex - gameManager.Inventory[b].registrationIndex);
        foreach (Item item in items)
        {
            GameObject itemSlotButton = Instantiate(itemSlotButtonPrefab, itemSlotGrid);
            itemSlotButton.GetComponent<ItemSlotButton>().Init(this, item);
        }
    }

    private void CloseMenu(InputAction.CallbackContext context)
    {
        if (menuOpen)
        {
            Resume();
        }
    }

    public void Resume()
    {
        menuOpen = false;
        menu.SetActive(false);
        gameManager.ApplySettings();
        gameManager.UnpauseGame();

        if (ItemRecordOpen)
            CloseItemRecord();

        while (itemSlotGrid.childCount > 0)
            DestroyImmediate(itemSlotGrid.GetChild(0).gameObject);
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

    public void SetMouseSensitivity(float value)
    {
        gameManager.GameSettings.mouseSensitivity = Mathf.Pow(2, value);
    }

    public void OpenItemRecord(Item item, bool pauseGame)
    {
        OpenItemRecord(item, pauseGame, gameManager.Inventory[item]);
    }

    public void OpenItemRecord(Item item, bool pauseGame, ItemSlot itemSlot)
    {
        this.itemSlot = itemSlot;
        ItemRecordOpen = true;
        itemRecordPauseGame = pauseGame;

        if (pauseGame) gameManager.PauseGame();
        itemRecord.SetActive(true);

        itemRecordNameInput.text = itemSlot.userName;
        if (itemSlot.userName == "")
            itemRecordNameInput.Select();

        shootingCamera.StartShooting(item);
    }

    public void CloseItemRecord()
    {
        ItemRecordOpen = false;

        if (itemRecordPauseGame) gameManager.UnpauseGame();
        itemRecord.SetActive(false);

        shootingCamera.EndShooting();
    }

    public void SetItemRecordName(string name)
    {
        itemSlot.userName = name;
    }
}
