using System.Collections;
using UnityEngine;
using UnityEngine.Rendering;

public class MagnetController : MonoBehaviour
{
    GameManager gameManager;
    Rigidbody2D rb;

    [Space]
    public Transform startPoint;
    [SerializeField] float startRadius;

    [Space]
    [SerializeField] float maxMouseMove;
    [SerializeField] float moveForce;
    [SerializeField] float pullForce;
    [SerializeField] float pushForce;

    [Space]
    public bool scrollEnabled;
    [SerializeField] float scrollPullForce;
    [SerializeField] float scrollPushForce;
    [SerializeField, Range(0, 1)] float scrollPullDrag;

    [Space]
    [SerializeField] float gravity;
    [SerializeField] float masse;
    public const float refMasse = 3;
    [SerializeField] float releaseFactor;

    Vector2 mouseInput = Vector2.zero;
    float scrollInput = 0;
    bool holding = false;

    public enum State { Fishing, Success, Failure }
    public State CurrentState { get; private set; }

    private void Awake()
    {
        gameManager = GameManager.Instance;
        rb = GetComponent<Rigidbody2D>();

        gameObject.SetActive(false);
    }

    private void OnEnable()
    {
        gameManager.InputActions.Fishing.Enable();
    }

    private void OnDisable()
    {
        gameManager.InputActions.Fishing.Disable();
    }

    public void ResetPosition()
    {
        transform.position = startPoint.position;
        rb.linearVelocity = Vector3.zero;
    }

    public void StartFishing(float masse)
    {
        CurrentState = State.Fishing;

        this.masse = masse;

        gameObject.SetActive(true);
    }

    void EndFishing(State state)
    {
        CurrentState = state;
        gameObject.SetActive(false);
    }

    private void Update()
    {
        mouseInput += gameManager.InputActions.Fishing.Move.ReadValue<Vector2>();
        if (scrollEnabled)
            scrollInput += gameManager.InputActions.Fishing.Pull.ReadValue<float>();
        holding = gameManager.InputActions.Fishing.Hold.ReadValue<float>() > 0;

        if (transform.position.y <= 0)
        {
            EndFishing(State.Success);
        }
    }

    private void FixedUpdate()
    {
        mouseInput = Vector2.ClampMagnitude(mouseInput, maxMouseMove);

        //Vector2 pos2start = (Vector2)startPoint.position - (Vector2)transform.position;
        //bool isGrounded = pos2start.magnitude <= startRadius;
        bool isGrounded = transform.position.y >= startPoint.position.y - startRadius;

        Vector2 velocity = Vector2.zero;

        if (holding)
        {
            velocity.x = mouseInput.x * moveForce / 1000;
            velocity.y = mouseInput.y * (mouseInput.y < 0 ? pullForce : (isGrounded ? 0 : pushForce * masse / refMasse)) / 1000;
            velocity.y += scrollInput * (scrollInput < 0 ? scrollPullForce : (isGrounded ? 0 : scrollPushForce * masse / refMasse));
            velocity /= masse;
        }

        if (!isGrounded)
        {
            velocity.y += gravity * (holding ? 1 : releaseFactor) * masse;
        }

        rb.linearVelocity = velocity;

        mouseInput = Vector2.zero;
        scrollInput *= scrollPullDrag;
    }
}
