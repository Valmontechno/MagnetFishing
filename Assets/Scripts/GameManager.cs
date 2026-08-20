using System;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

public class GameManager : MonoBehaviour
{
    public static GameManager Instance {get; private set;}

    public InputActions InputActions {get; private set;}

    [HideInInspector] public Sea sea;
    [HideInInspector] public PlayerController player;
    [HideInInspector] public Menu menu;

    [HideInInspector] public SubmergedItem overlappedSubmergedItem = null;

    public event Action<bool> SubmergedItemVisibilityChanged;

    InteractiveObject interactiveObject;
    public InteractiveObject InteractiveObject
    {
        get => interactiveObject;
        set
        {
            interactiveObject = value;
            OnInteractiveObjectChange?.Invoke();
        }
    }

    public event Action OnInteractiveObjectChange;

    public Dictionary<Item, ItemSlot> Inventory { get; private set; }
    public GameSettings GameSettings { get; private set; }

    readonly bool[] pausedInputsState = new bool[3];

    public Item[] bikeItems;


    private void Awake()
    {
        if (Instance == null)
        {
            Instance = this;
            DontDestroyOnLoad(this);

            InputActions = new();

            Inventory = new();
            GameSettings = new();
        }
        else
        {
            Destroy(this);
        }
    }

    private void Start()
    {
        HideMouse();
    }

#if !UNITY_EDITOR
    void OnGUI()
    {
        GUI.Label(
            new Rect(10, 10, 300, 30),
            $"FPS: {(1f / Time.unscaledDeltaTime):F0}"
        );
    }
#endif

    public void PauseGame()
    {
        Time.timeScale = 0;

        pausedInputsState[0] = InputActions.Fishing.enabled;
        pausedInputsState[1] = InputActions.Player.enabled;
        pausedInputsState[2] = InputActions.Boat.enabled;
        InputActions.Fishing.Disable();
        InputActions.Player.Disable();
        InputActions.Boat.Disable();

        InputActions.Menu.Enable();
    }

    public void UnpauseGame()
    {
        Time.timeScale = 1;

        if (pausedInputsState[0]) InputActions.Fishing.Enable();
        if (pausedInputsState[1]) InputActions.Player.Enable();
        if (pausedInputsState[2]) InputActions.Boat.Enable();

        InputActions.Menu.Disable();
    }

    public void ShowMouse()
    {
        Cursor.visible = true;
        Cursor.lockState = CursorLockMode.None;
    }

    public void HideMouse()
    {
        Cursor.visible = false;
        Cursor.lockState = CursorLockMode.Locked;
    }

    public void QuitGame()
    {
#if UNITY_EDITOR
        UnityEditor.EditorApplication.ExitPlaymode();
#else
        Application.Quit();
#endif
    }

    public void ApplySettings()
    {
        FindAnyObjectByType<MagnetController>(FindObjectsInactive.Include).scrollEnabled = GameSettings.scrollEnabled;
    }

    public void SetSubmergedItemVisibility(bool visible)
    {
        SubmergedItemVisibilityChanged?.Invoke(visible);
    }
}
