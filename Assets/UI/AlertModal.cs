using TMPro;
using UnityEngine;

public class AlertModal : Modal
{
    [SerializeField] TextMeshProUGUI messageText;

    bool showMouse;

    public void OpenModal(string message, bool showMouse)
    {
        this.showMouse = showMouse;

        base.OpenModal();

        //if (showMouse)
        //    GameManager.Instance.ShowMouse();

        messageText.text = message;
    }

    //public override void CloseModal()
    //{
    //    base.CloseModal(false);

    //    if (showMouse)
    //        GameManager.Instance.HideMouse();
    //}
}
