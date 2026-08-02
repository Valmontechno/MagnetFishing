using UnityEngine;

public class FishingHandler : MonoBehaviour
{
    [SerializeField] float scale;
    [SerializeField] BoxCollider2D frame2D;
    [SerializeField] MagnetController magnet2D;
    [SerializeField] Transform fishingFloat;

    private void OnDrawGizmos()
    {
        if (frame2D != null)
        {
            Gizmos.color = Color.yellow;
            Gizmos.matrix = transform.localToWorldMatrix;
            
            Gizmos.DrawWireCube(
                new Vector3(frame2D.offset.x, 0, frame2D.offset.y) * scale,
                new Vector3(frame2D.size.x, 0, frame2D.size.y) * scale
            );
        }
    }

    private void Start()
    {
        magnet2D.StartFishing();
    }

    private void Update()
    {
        fishingFloat.transform.localPosition = new Vector3(
            magnet2D.transform.position.x * scale,
            fishingFloat.transform.localPosition.y,
            magnet2D.transform.position.y * scale
        );
    }
}
