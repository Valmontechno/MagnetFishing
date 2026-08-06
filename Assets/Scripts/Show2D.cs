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
        Gizmos.matrix = transform.localToWorldMatrix;

        if (TryGetComponent(out BoxCollider2D box))
        {
            if (fill)
                Gizmos.DrawCube(box.offset, box.size);
            else
                Gizmos.DrawWireCube(box.offset, box.size);
        }
        else if (TryGetComponent(out CircleCollider2D circle))
        {
            if (fill)
                Gizmos.DrawSphere(circle.offset, circle.radius);
            else
                Gizmos.DrawWireSphere(circle.offset, circle.radius);
        }
    }
}
