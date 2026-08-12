using UnityEngine;

public class BikeQuestModal : Modal
{
    [SerializeField] GameObject bike;
    [SerializeField] ShootingCamera shootingCamera;
    [SerializeField] Material obtainedMaterial;
    [SerializeField] Material notObtainedMaterial;

    public override void OpenModal()
    {
        base.OpenModal();

        bike.SetActive(true);
        shootingCamera.gameObject.SetActive(true);
        shootingCamera.transform.rotation = Quaternion.identity;

        for (int i = 0; i < GameManager.Instance.bikeItems.Length; i++)
        {
            bike.transform.GetChild(i).GetComponent<Renderer>().material = GameManager.Instance.Inventory.ContainsKey(GameManager.Instance.bikeItems[i]) ? obtainedMaterial : notObtainedMaterial;
        }
    }

    public override void CloseModal()
    {
        base.CloseModal();

        bike.SetActive(false);
        shootingCamera.gameObject.SetActive(false);
    }
}
