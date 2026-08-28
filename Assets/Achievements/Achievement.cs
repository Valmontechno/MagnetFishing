using UnityEngine;

[CreateAssetMenu(fileName = "Achievement", menuName = "Scriptable Objects/Achievement")]
public class Achievement : ScriptableObject
{
    public string title;
#if UNITY_EDITOR
    [ScriptableObjectIcon]
#endif
    public Sprite icon;
    [Multiline] public string description;
}
