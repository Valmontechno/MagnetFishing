using UnityEngine;

public class BoatController : MonoBehaviour
{
    GameManager gameManager;
    Rigidbody rb;

    [SerializeField] float accel;
    [SerializeField] float maxSpeed;
    [SerializeField, Range(0, 1)] float drag;
    [SerializeField] float angularAccel;

    private void Start()
    {
        gameManager = GameManager.Instance;
        rb = GetComponent<Rigidbody>();
    }

    private void FixedUpdate()
    {
        Vector2 moveInput = gameManager.InputActions.Boat.Move.ReadValue<Vector2>();

        rb.linearVelocity *= drag;
        rb.linearVelocity += moveInput.y * accel * transform.forward;
        rb.maxLinearVelocity = maxSpeed;

        rb.angularVelocity += new Vector3(0, moveInput.x * angularAccel, 0);

        //print(rb.linearVelocity.magnitude);
    }
}
