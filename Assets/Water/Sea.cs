using UnityEngine;

public class Sea : MonoBehaviour
{
    [SerializeField] Transform target;

    Material material;

    const int ripplesCount = 20;
    readonly Vector4[] ripples = new Vector4[ripplesCount];
    int rippleIndex = 0;

    private void Awake()
    {
        GameManager.Instance.sea = this;

        material = GetComponent<MeshRenderer>().material;
    }

    private void Update()
    {
        Vector3 pos = target.position;
        pos.x = Mathf.Round(pos.x / 2) * 2;
        pos.y = 0;
        pos.z = Mathf.Round(pos.z / 2) * 2;
        transform.position = pos;
    }

    public void GenerateRipple(Vector2 pos, float radius)
    {
        ripples[rippleIndex] = new(pos.x, pos.y, radius, Time.time);
        material.SetVectorArray("_ripples", ripples);
        rippleIndex = (rippleIndex + 1) % ripplesCount;
    }
}
