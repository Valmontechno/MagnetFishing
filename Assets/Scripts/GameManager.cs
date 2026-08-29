using System;
using System.Collections.Generic;
using UnityEngine;

public class GameManager : MonoBehaviour
{
    public static GameManager Instance {get; private set;}

    public InputActions InputActions {get; private set;}

    [HideInInspector] public Sea sea;
    [HideInInspector] public PlayerController player;
    [HideInInspector] public Menu menu;
    [HideInInspector] public HUD hud;

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
    public int Seed { get; private set; }

    public int money;
    public Dictionary<Item, ItemSlot> Inventory { get; private set; }
    public List<Achievement> Achievements { get; private set; }
    public HashSet<string> GameState { get; private set; }
    public GameSettings GameSettings { get; private set; }

    readonly bool[] pausedInputsState = new bool[3];

    public Item[] bikeItems;

    public int itemCount;


    private void Awake()
    {
        if (Instance == null)
        {
            Instance = this;
            DontDestroyOnLoad(this);

            InputActions = new();

            Inventory = new();
            Achievements = new();
            GameState = new();
            GameSettings = new();

            Seed = UnityEngine.Random.Range(int.MinValue, int.MaxValue);
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

//#if !UNITY_EDITOR
//    void OnGUI()
//    {
//        GUI.Label(
//            new Rect(10, 10, 300, 30),
//            $"FPS: {(1f / Time.unscaledDeltaTime):F0}"
//        );
//    }
//#endif

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

    public void UnlockAchievement(Achievement achievement)
    {
        if (achievement == null || Achievements.Contains(achievement)) return;

        Achievements.Add(achievement);
        hud.UnlockAchievement(achievement);
    }

    public int GetTotalGramMasse()
    {
        int gramMasse = 0;
        foreach (Item item in Inventory.Keys)
        {
            gramMasse += item.gramMasse;
        }
        return gramMasse;
    }
}
