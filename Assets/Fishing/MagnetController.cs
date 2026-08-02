using UnityEngine;

public class MagnetController : MonoBehaviour
{
    GameManager gameManager;
    Rigidbody2D rb;

    [Space]
    [SerializeField] Transform startPoint;
    [SerializeField] float startRadius;

    [Space]
    [SerializeField] float maxMouseMove;
    [SerializeField] float moveForce;
    [SerializeField] float pullForce;
    [SerializeField] float pushForce;

    [Space]
    [SerializeField] bool scrollEnabled;
    [SerializeField] float scrollPullForce;
    [SerializeField, Range(0, 1)] float scrollPullDrag;

    [Space]
    [SerializeField] float gravity;
    [SerializeField] float masse;
    [SerializeField] float releaseFactor;

    Vector2 mouseInput = Vector2.zero;
    float scrollInput = 0;
    bool holding = false;

    private void Awake()
    {
        gameManager = GameManager.Instance;
        rb = GetComponent<Rigidbody2D>();
    }

    public void StartFishing()
    {
        gameObject.SetActive(true);

        transform.position = startPoint.position;
        rb.linearVelocity = Vector3.zero;
    }

    private void Update()
    {
        mouseInput += gameManager.InputActions.Fishing.Move.ReadValue<Vector2>();
        if (scrollEnabled)
            scrollInput += gameManager.InputActions.Fishing.Pull.ReadValue<float>();
        holding = gameManager.InputActions.Fishing.Hold.ReadValue<float>() > 0;
    }

    private void FixedUpdate()
    {
        mouseInput = Vector2.ClampMagnitude(mouseInput, maxMouseMove);

        Vector2 pos2start = (Vector2)startPoint.position - (Vector2)transform.position;
        bool isGrounded = pos2start.magnitude <= startRadius;

        Vector2 velocity = Vector2.zero;

        if (holding)
        {
            velocity.x = mouseInput.x * moveForce / 1000;
            velocity.y = mouseInput.y * (mouseInput.y < 0 ? pullForce : (isGrounded ? 0 : pushForce)) / 1000;
            velocity.y += Mathf.Min(scrollInput, 0) * scrollPullForce;
            velocity /= masse;
        }

        if (!isGrounded)
            velocity += gravity * (holding ? 1 : releaseFactor) * masse * pos2start.normalized;

        rb.linearVelocity = velocity;

        mouseInput = Vector2.zero;
        scrollInput *= scrollPullDrag;
    }
}
