using System.Data.Common;
using TMPro;
using UnityEngine;
using UnityEngine.Audio;
using UnityEngine.UI;
using static ShopModal;

public class ShopItemButton : MonoBehaviour
{
    GameManager gameManager;

    Button button;

    [Space]
    [SerializeField] TextMeshProUGUI nameText;
    [SerializeField] TextMeshProUGUI costText;
    [SerializeField] Image image;

    [Space]
    [SerializeField] Color costColor;
    [SerializeField] string boughtMessage;
    [SerializeField] AudioResource buySound;

    ShopModal shopModal;
    ShopItem shopItem;

    public void Init(ShopModal shopModal, ShopItem shopItem)
    {
        gameManager = GameManager.Instance;

        button = GetComponent<Button>();

        this.shopModal = shopModal;
        this.shopItem = shopItem;

        UpdateButton();
    }

    public void UpdateButton()
    {
        nameText.text = shopItem.itemName;
        image.sprite = shopItem.icon;

        if (gameManager.GameState.Contains(shopItem.state))
        {
            GetComponent<Button>().interactable = false;
            costText.text = boughtMessage;
        }
        else
        {
            costText.text = $"{shopItem.cost} <color=#{ColorUtility.ToHtmlStringRGB(costColor)}>¤</color>";
        }
    }

    public void Buy()
    {
        if (gameManager.money < shopItem.cost)
        {
            AudioManager.Instance.PlayUI(UISound.Error);
        }
        else
        {
            gameManager.money -= shopItem.cost;
            gameManager.GameState.Add(shopItem.state);
            shopItem.action?.Invoke();

            UpdateButton();
            AudioManager.Instance.PlayUI(buySound);

            if (shopItem.message != "")
            {
                gameManager.menu.Alert(shopItem.message);
            }
        }
    }
}
