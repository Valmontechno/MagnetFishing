using System;
using System.Collections.Generic;
using System.Linq;
using TMPro;
using UnityEngine;
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

    [Space]
    [SerializeField] Transform itemSlotGrid;
    [SerializeField] GameObject itemSlotButtonPrefab;


    [Header("Item Record")]
    [SerializeField] GameObject itemRecord;
    [SerializeField] TMP_InputField itemRecordNameInput;
    [SerializeField] float rotateItemVisualSpeed;
    [SerializeField] GameObject shootingCamera;
    GameObject shootingItem;
    public bool ItemRecordOpen { get; private set; }
    bool itemRecordPauseGame;
    ItemSlot itemSlot;


    private void Start()
    {
        gameManager = GameManager.Instance;
        gameManager.InputActions.Menu.Enable();

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
        if (ItemRecordOpen && shootingItem != null && gameManager.InputActions.Menu.GrabItemVisual.ReadValue<float>() > 0)
        {
            Vector2 input = gameManager.InputActions.Menu.RotateItemVisual.ReadValue<Vector2>();
            shootingItem.transform.Rotate(Vector3.up, -input.x * rotateItemVisualSpeed * Time.unscaledDeltaTime, Space.World);
            shootingItem.transform.Rotate(Vector3.right, input.y * rotateItemVisualSpeed * Time.unscaledDeltaTime, Space.World);
        }
    }

    private void OpenMenu(InputAction.CallbackContext context)
    {
        menuOpen = true;
        menu.SetActive(true);
        gameManager.PauseGame();

        EnableScrollToggle.isOn = gameManager.GameSettings.scrollEnabled;

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

        shootingCamera.SetActive(true);
        if (item.visual != null)
        {
            shootingItem = Instantiate(item.visual);
            shootingItem.layer = LayerMask.NameToLayer("ItemShooting");
            shootingItem.transform.SetPositionAndRotation(Vector3.zero, Quaternion.identity);
        }
    }

    public void CloseItemRecord()
    {
        ItemRecordOpen = false;

        if (itemRecordPauseGame) gameManager.UnpauseGame();
        itemRecord.SetActive(false);

        shootingCamera.SetActive(false);
        if (shootingItem != null)
            Destroy(shootingItem);
    }

    public void SetItemRecordName(string name)
    {
        itemSlot.userName = name;
    }
}
