using UnityEngine;

public class GameManager : MonoBehaviour
{
    public static GameManager Instance {get; private set;}

    public InputActions InputActions {get; private set;}

    public Sea sea;


    private void Awake()
    {
        if (Instance == null)
        {
            Instance = this;
            DontDestroyOnLoad(this);

            InputActions = new();
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
}
