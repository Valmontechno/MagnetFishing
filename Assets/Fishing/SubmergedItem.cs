using UnityEngine;

public class SubmergedItem : MonoBehaviour
{
    new ParticleSystem particleSystem;

    [NotNull(UnityMessageType.Warning)]
    [DynamicHelp(nameof(GetHelpMessage), UnityMessageType.None)]
    public Item item;

    string GetHelpMessage()
    {
        if (item != null)
            return
                "Masse: " + item.masse.ToString() + "\n" +
                "Obstacle: " + (item.obstacle == null ? "null" : item.obstacle.name);
        else
            return "";
    }

#if UNITY_EDITOR
    private void OnValidate()
    {
        if (TryGetComponent(out Collider collider))
        {
            collider.isTrigger = true;
        }

        GUIContent iconContent;
        if (item != null)
        {
            iconContent = UnityEditor.EditorGUIUtility.IconContent(item.obstacle != null ? "sv_label_1" : "sv_label_4");
            gameObject.name = item.name;
        }
        else
        {
            iconContent = UnityEditor.EditorGUIUtility.IconContent("sv_label_6");
            gameObject.name = "null";
        }
        UnityEditor.EditorGUIUtility.SetIconForObject(gameObject, (Texture2D)iconContent.image);
    }
#endif

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
        if (item == null || GameManager.Instance.Inventory.ContainsKey(item))
        {
            Destroy(gameObject);
        }
        else
        {
            particleSystem = GetComponentInChildren<ParticleSystem>();
            GameManager.Instance.SubmergedItemVisibilityChanged += SetVisibility;
        }
    }

    private void OnDestroy()
    {
        GameManager.Instance.SubmergedItemVisibilityChanged -= SetVisibility;
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

    void SetVisibility(bool visible)
    {
        if (visible)
        {
            particleSystem.Play();
        }
        else
        {
            particleSystem.Stop();
        }
    }
}