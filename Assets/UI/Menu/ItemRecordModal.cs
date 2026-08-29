using System.Collections;
using System.Globalization;
using TMPro;
using UnityEngine;
using UnityEngine.Audio;
using UnityEngine.InputSystem;
using UnityEngine.UI;

public class ItemRecordModal : Modal
{
    [SerializeField] TextMeshProUGUI itemNameText;
    //[SerializeField] TMP_InputField itemRecordNameInput;
    [SerializeField] TextMeshProUGUI moneyText;
    [SerializeField] TextMeshProUGUI moneySuffix;
    [SerializeField] Button closeButton;
    [SerializeField] AudioResource moneySound;
    [SerializeField] AudioResource endMoneySound;
    [SerializeField] float rotateItemVisualSpeed;
    [SerializeField] ShootingCamera shootingCamera;
    [SerializeField] string buttonMessage0;
    [SerializeField] string buttonMessage1;
    [SerializeField] Item chestContentItem;

    Item item;
    ItemSlot itemSlot;
    bool isNewItem;
    Vector2 rotateItemVisualVelocity;

    bool isClosing = true;

    public void OpenModal(Item item)
    {
        OpenModal(item, GameManager.Instance.Inventory[item], false);
    }

    public void OpenModal(Item item, ItemSlot itemSlot, bool isNewItem)
    {
        isClosing = false;
        this.item = item;
        this.isNewItem = isNewItem;

        base.OpenModal();

        this.itemSlot = itemSlot;

        //closeButton.interactable = true;

        moneyText.text = string.Format(CultureInfo.GetCultureInfo("fr-FR"), "+{0:N3}", item.gramMasse / 1000f);
        moneySuffix.gameObject.SetActive(false);

        itemNameText.text = item.itemName;

        //itemRecordNameInput.text = itemSlot.userName;
        //if (itemSlot.userName == "")
        //    itemRecordNameInput.Select();

        shootingCamera.StartShooting(item);

        closeButton.GetComponentInChildren<TextMeshProUGUI>().text = isNewItem ? buttonMessage0 : buttonMessage1;
    }

    private void Update()
    {
        if (GameManager.Instance.InputActions.Menu.GrabItemVisual.ReadValue<float>() > 0)
        {
            Vector2 input = GameManager.Instance.InputActions.Menu.RotateItemVisual.ReadValue<Vector2>();
            rotateItemVisualVelocity.x = -input.x * rotateItemVisualSpeed;
            rotateItemVisualVelocity.y = input.y * rotateItemVisualSpeed;
        }
        else
        {
            rotateItemVisualVelocity *= 0.9f;
        }

        Vector3 rotation = shootingCamera.transform.eulerAngles;
        rotation.y -= rotateItemVisualVelocity.x * Time.unscaledDeltaTime;
        rotation.x -= rotateItemVisualVelocity.y * Time.unscaledDeltaTime;
        rotation.x = Mathf.Clamp(Utils.Warp180(rotation.x), -90, 90);
        shootingCamera.transform.rotation = Quaternion.Euler(rotation);
    }

    public override void CloseModal()
    {
        if (gameObject.activeInHierarchy)
        {
            StartCoroutine(CloseModalRoutine());
        }
        else
        {
            base.CloseModal();

            shootingCamera.EndShooting();
        }
    }

    IEnumerator CloseModalRoutine()
    {
        if (isNewItem && !isClosing)
        {
            isClosing = true;

            float gramMass;
            float totalGramMass;
            int money;

            //closeButton.interactable = false;
            closeButton.GetComponentInChildren<TextMeshProUGUI>().text = buttonMessage1;

            moneySuffix.gameObject.SetActive(true);
            float strticTotalGramMasse = GameManager.Instance.GetTotalGramMasse();

            const float stepDuration = 0.01f;
            float duration = Utils.Remap(item.gramMasse, 10, 30000, 0.5f, 2f);
            int step = Mathf.CeilToInt(item.gramMasse / (duration / stepDuration));
            for (int i = 0; i <= item.gramMasse; i += step)
            {
                int ic = Mathf.Min(i, item.gramMasse);
                gramMass = item.gramMasse - ic;
                totalGramMass = strticTotalGramMasse + (item == chestContentItem ? 0 : ic);
                money = GameManager.Instance.money - item.gramMasse + ic;
                moneyText.text = string.Format(CultureInfo.GetCultureInfo("fr-FR"), "+{0:N3}\n{1:N3}\n{2:N0}", gramMass / 1000f, totalGramMass / 1000f, money);

                AudioManager.Instance.PlayUI(moneySound);

                yield return new WaitForSecondsRealtime(stepDuration);
            }

            totalGramMass = strticTotalGramMasse + item.gramMasse;
            money = GameManager.Instance.money;
            moneyText.text = string.Format(CultureInfo.GetCultureInfo("fr-FR"), "+0\n{1:N3}\n{2:N0}", 0, totalGramMass / 1000f, money);

            AudioManager.Instance.PlayUI(endMoneySound);
        }
        else
        {
            base.CloseModal();

            shootingCamera.EndShooting();
        }
    }

    public void SetItemRecordName(string name)
    {
        itemSlot.userName = name;
    }
}
