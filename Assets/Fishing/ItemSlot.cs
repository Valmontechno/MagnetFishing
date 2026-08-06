using UnityEngine;

public class ItemSlot
{
    public int registrationIndex;
    public string userName;

    public ItemSlot(int registrationIndex)
    {
        this.registrationIndex = registrationIndex;
        userName = "";
    }
}
