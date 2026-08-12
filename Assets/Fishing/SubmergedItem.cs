using UnityEditor;
using UnityEngine;

public class SubmergedItem : MonoBehaviour
{
    public Item item;
    private void OnValidate()
    {
        if (TryGetComponent(out Collider collider))
        {
            collider.isTrigger = true;
        }

        if (item != null)
        {
            var iconContent = EditorGUIUtility.IconContent("sv_label_1");
            EditorGUIUtility.SetIconForObject(gameObject, (Texture2D)iconContent.image);
            gameObject.name = item.name;
        }
    }

    private void OnDrawGizmos()
    {
        Gizmos.color = Color.blue;
        Gizmos.matrix = transform.localToWorldMatrix;

        if (TryGetComponent(out BoxCollider box))
        {
            Gizmos.DrawWireCube(box.center, box.size);
        }
    }

    private void Start()
    {
        if (GameManager.Instance.Inventory.ContainsKey(item))
        {
            Destroy(gameObject);
        }
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("FishingFloat") && GameManager.Instance.overlappedSubmergedItem == null)
        {
            GameManager.Instance.overlappedSubmergedItem = this;
        }
    }

    private void OnTriggerExit(Collider other)
    {
        if (other.CompareTag("FishingFloat"))
        {
            GameManager.Instance.overlappedSubmergedItem = null;
        }
    }

    public void Remove()
    {
        Destroy(gameObject);
    }
}