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