using TMPro;
using UnityEngine;

public class DialogModal : Modal
{
    [SerializeField] TextMeshProUGUI messageText;

    public void OpenModal(string dialog)
    {
        base.OpenModal();

        messageText.text = dialog;

        GameManager.Instance.ShowMouse();
    }

    public override void CloseModal()
    {
        base.CloseModal();

        GameManager.Instance.HideMouse();
    }
}
