using UnityEngine;

public class Sea : MonoBehaviour
{
    [SerializeField] Transform target;

    private void Update()
    {
        Vector3 pos = target.position;
        pos.x = Mathf.Round(pos.x / 2) * 2;
        pos.y = 0;
        pos.z = Mathf.Round(pos.z / 2) * 2;
        transform.position = pos;
    }
}
