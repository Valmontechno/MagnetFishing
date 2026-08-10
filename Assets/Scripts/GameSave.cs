using System.Collections.Generic;
using UnityEngine;

public class GameSettings
{
    public bool scrollEnabled = false;
    public float mouseSensitivity = 1;
}

public class GameSave
{
    public Dictionary<Item, ItemSlot> inventory;
    public GameSettings gameSettings;
}
