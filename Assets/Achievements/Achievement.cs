using UnityEngine;

[CreateAssetMenu(fileName = "Achievement", menuName = "Scriptable Objects/Achievement")]
public class Achievement : ScriptableObject
{
    public string title;
    [ScriptableObjectIcon] public Sprite icon;
    [Multiline] public string description;
}
