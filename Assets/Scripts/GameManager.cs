using System;
using System.Collections.Generic;
using UnityEngine;

public class GameManager : MonoBehaviour
{
    public static GameManager Instance {get; private set;}

    public InputActions InputActions {get; private set;}

    [HideInInspector] public Sea sea;
    [HideInInspector] public PlayerController player;

    [HideInInspector] public SubmergedItem overlappedSubmergedItem = null;

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
        Cursor.visible = false;
        Cursor.lockState = CursorLockMode.Locked;
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

        Cursor.visible = true;
        Cursor.lockState = CursorLockMode.None;

        InputActions.Menu.Enable();
    }

    public void UnpauseGame()
    {
        Time.timeScale = 1;

        if (pausedInputsState[0]) InputActions.Fishing.Enable();
        if (pausedInputsState[1]) InputActions.Player.Enable();
        if (pausedInputsState[2]) InputActions.Boat.Enable();

        Cursor.visible = false;
        Cursor.lockState = CursorLockMode.Locked;

        InputActions.Menu.Disable();
    }

    public void ApplySettings()
    {
        FindAnyObjectByType<MagnetController>(FindObjectsInactive.Include).scrollEnabled = GameSettings.scrollEnabled;
    }
}
