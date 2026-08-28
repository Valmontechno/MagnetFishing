using UnityEngine;

public class SubmergedItem : MonoBehaviour
{
    new ParticleSystem particleSystem;

    [NotNull(UnityMessageType.Warning)]
    [DynamicHelp(nameof(GetHelpMessage), UnityMessageType.None)]
    public Item item;

    [SerializeField] float randomOffset;

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
        //GUIContent iconContent;
        //if (item != null)
        //{
        //    iconContent = UnityEditor.EditorGUIUtility.IconContent(item.obstacle != null ? "sv_label_1" : "sv_label_4");
        //    gameObject.name = item.name;
        //}
        //else
        //{
        //    iconContent = UnityEditor.EditorGUIUtility.IconContent("sv_label_6");
        //    gameObject.name = "null";
        //}
        //UnityEditor.EditorGUIUtility.SetIconForObject(gameObject, (Texture2D)iconContent.image);
    }
#endif

    private void OnDrawGizmos()
    {
        Gizmos.color = Color.blue;
        Gizmos.matrix = transform.localToWorldMatrix * Matrix4x4.Translate(Vector3.up * 0.5f) * Matrix4x4.Scale(new Vector3(1, 0, 1));

        if (TryGetComponent(out BoxCollider box) && box.enabled)
        {
            Gizmos.DrawWireCube(box.center, box.size);
        }
        else if (TryGetComponent(out SphereCollider sphere) && sphere.enabled)
        {
            Gizmos.DrawWireSphere(sphere.center, sphere.radius);
        }

#if UNITY_EDITOR
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
#endif
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

            transform.position += Utils.XyY(Random.insideUnitCircle * randomOffset, 0);
        }
    }

    private void OnDestroy()
    {
        GameManager.Instance.SubmergedItemVisibilityChanged -= SetVisibility;
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