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
            item.GetOffsetAndScale(out Vector3 offset, out Vector3 scale);
            itemGO.transform.localScale = Vector3.Scale(itemGO.transform.localScale, scale);

            if (item.recenter)
            {
                itemGO.transform.rotation *= item.rotation;
                itemGO.transform.position = Vector3.zero - Vector3.Scale(offset, scale);
            }
            else
                itemGO.transform.position = Vector3.zero;


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
