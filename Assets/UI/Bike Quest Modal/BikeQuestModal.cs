using UnityEngine;

public class BikeQuestModal : Modal
{
    [SerializeField] GameObject bike;
    [SerializeField] ShootingCamera shootingCamera;
    [SerializeField] Material obtainedMaterial;
    [SerializeField] Material notObtainedMaterial;

    public override void OpenModal()
    {
        OpenModal(null);
    }

    public void OpenModal(Item newPart)
    {
        base.OpenModal();

        bike.SetActive(true);
        shootingCamera.gameObject.SetActive(true);
        shootingCamera.transform.rotation = Quaternion.identity;

        for (int i = 0; i < GameManager.Instance.bikeItems.Length; i++)
        {
            Transform part = bike.transform.GetChild(i);
            part.GetComponent<Renderer>().material = GameManager.Instance.Inventory.ContainsKey(GameManager.Instance.bikeItems[i]) ? obtainedMaterial : notObtainedMaterial;
            if (GameManager.Instance.bikeItems[i] == newPart)
            {
                part.GetComponent<Animator>().SetTrigger("Obtain");
            }
        }
    }

    public override void CloseModal()
    {
        base.CloseModal();

        bike.SetActive(false);
        shootingCamera.gameObject.SetActive(false);
    }
}
