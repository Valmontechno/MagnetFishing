using UnityEngine;
using UnityEngine.UI;

public class ItemSlotButton : MonoBehaviour
{
    [SerializeField] Image image;

    Menu menu;
    Item item;

    public void Init(Menu menu, Item item)
    {
        this.menu = menu;
        this.item = item;

        image.sprite = item.icon;
    }

    public void OnClick()
    {
        menu.OpenItemRecord(item, false);
    }
}
