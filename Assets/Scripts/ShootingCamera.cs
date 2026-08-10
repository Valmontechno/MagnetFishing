using UnityEngine;

public class ShootingCamera : MonoBehaviour
{
    [SerializeField] Quaternion defaultRotation;

    GameObject itemGO;

    public void StartShooting(Item item)
    {
        if (item.visual == null)
        {
            itemGO = null;
        }
        else
        {
            gameObject.SetActive(true);
            transform.rotation = defaultRotation;

            itemGO = Instantiate(item.visual);
            itemGO.transform.SetPositionAndRotation(Vector3.zero, Quaternion.identity);
            itemGO.transform.localScale = item.GetScale();

            foreach (Renderer renderer in itemGO.GetComponentsInChildren<Renderer>())
            {
                renderer.gameObject.layer = LayerMask.NameToLayer("ItemShooting");
            }
        }
    }

    public void EndShooting()
    {
        if (itemGO != null)
        {
            gameObject.SetActive(false);
            DestroyImmediate(itemGO);
        }
    }
}
