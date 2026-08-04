using UnityEngine;

public class RippleGenerator : MonoBehaviour
{
    [SerializeField] float radius = 1;
    [SerializeField] float maxRadius = 1;
    [SerializeField] float minSpeed;

    Vector2 previousPos;

    private void OnEnable()
    {
        previousPos = transform.position;
    }

    private void Update()
    {
        Vector2 position = new(transform.position.x, transform.position.z);
        float speed = Vector2.Distance(previousPos, position) / Time.deltaTime;

        if (speed >= minSpeed)
        {
            GameManager.Instance.sea.GenerateRipple(position, Mathf.Min(radius * speed, maxRadius));
            
        }

        previousPos = position;
    }
}
