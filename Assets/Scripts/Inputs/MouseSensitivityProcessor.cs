using UnityEngine;
using UnityEngine.InputSystem;

#if UNITY_EDITOR
[UnityEditor.InitializeOnLoad]
#endif
public class MouseSensitivityProcessor : InputProcessor<Vector2>
{
#if UNITY_EDITOR
    static MouseSensitivityProcessor()
    {
        Initialize();
    }
#endif

    [RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.BeforeSceneLoad)]
    static void Initialize()
    {
        InputSystem.RegisterProcessor<MouseSensitivityProcessor>();
    }

    public override Vector2 Process(Vector2 value, InputControl control)
    {
        if (GameManager.Instance != null)
            return value * GameManager.Instance.GameSettings.mouseSensitivity;
        else
            return value;
    }
}