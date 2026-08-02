using System;
using UnityEngine;

[RequireComponent(typeof(Collider2D))]
public class Show2D : MonoBehaviour
{
    [SerializeField] Color color = Color.white;
    [SerializeField] bool fill = true;

    private void OnDrawGizmos()
    {
        if (!enabled) return;

        Gizmos.color = color;

        if (TryGetComponent(out BoxCollider2D box))
        {
            if (fill)
                Gizmos.DrawCube(transform.position + (Vector3)box.offset, box.size);
            else
                Gizmos.DrawWireCube(transform.position + (Vector3)box.offset, box.size);
        }
        else if (TryGetComponent(out CircleCollider2D circle))
        {
            if (fill)
                Gizmos.DrawSphere(transform.position + (Vector3)circle.offset, circle.radius);
            else
                Gizmos.DrawWireSphere(transform.position + (Vector3)circle.offset, circle.radius);
        }
    }
}
