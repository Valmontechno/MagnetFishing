using System;
using UnityEngine;
using UnityEngine.Events;

public class ShopModal : Modal
{
    [Serializable]
    public class ShopItem
    {
        public string state;
        public string itemName;
        public Sprite icon;
        public int cost;
        public UnityEvent action;
        [Multiline] public string message;
    }

    [SerializeField] Transform shopItemGrid;
    [SerializeField] GameObject shopItemButtonPrefab;
    [SerializeField] GameObject boat;

    [SerializeField] ShopItem[] shopItems;

    public override void OpenModal()
    {
        base.OpenModal();

        GameManager.Instance.ShowMouse();

        while (shopItemGrid.childCount > 0)
            DestroyImmediate(shopItemGrid.GetChild(0).gameObject);
        foreach (ShopItem shopItem in shopItems)
        {
            ShopItemButton button = Instantiate(shopItemButtonPrefab, shopItemGrid).GetComponent<ShopItemButton>();
            button.Init(this, shopItem);
        }
    }

    public override void CloseModal()
    {
        base.CloseModal();

        GameManager.Instance.HideMouse();
    }

    public void UnlockBoat()
    {
        boat.SetActive(true);
    }
}
