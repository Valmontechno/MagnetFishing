using TMPro;
using UnityEngine;

public class ItemRecordModal : Modal
{
    [SerializeField] TextMeshProUGUI itemNameText;
    //[SerializeField] TMP_InputField itemRecordNameInput;
    [SerializeField] float rotateItemVisualSpeed;
    [SerializeField] ShootingCamera shootingCamera;

    ItemSlot itemSlot;
    Vector2 rotateItemVisualVelocity;

    public void OpenModal(Item item)
    {
        OpenModal(item, GameManager.Instance.Inventory[item]);
    }

    public void OpenModal(Item item, ItemSlot itemSlot)
    {
        base.OpenModal();

        this.itemSlot = itemSlot;

        itemNameText.text = item.itemName;

        //itemRecordNameInput.text = itemSlot.userName;
        //if (itemSlot.userName == "")
        //    itemRecordNameInput.Select();

        shootingCamera.StartShooting(item);
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
        base.CloseModal();

        shootingCamera.EndShooting();
    }

    public void SetItemRecordName(string name)
    {
        itemSlot.userName = name;
    }
}
