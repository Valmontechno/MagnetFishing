using System;
using UnityEngine;
using UnityEngine.InputSystem;

public class BoatController : MonoBehaviour
{
    GameManager gameManager;
    Rigidbody rb;
    FishingHandler fishingHandler;

    [Space]
    [SerializeField] new GameObject camera;
    [SerializeField] Transform fishingPivot;
    [SerializeField] GameObject fishingFloat;
    [SerializeField] Target target;

    [Space]
    [SerializeField] float accel;
    [SerializeField] float maxSpeed;
    [SerializeField, Range(0, 1)] float drag;
    [SerializeField] float angularAccel;

    [Space]
    [SerializeField] float launchMaxSpeed;
    [SerializeField] float floatMaxDistance;
    [SerializeField] float floatMinDistance;
    bool canLaunchMagnet = false;
    bool magnetLaunched = false;
    Vector2 relativeFloatPos;

    private void Awake()
    {
        gameManager = GameManager.Instance;
        rb = GetComponent<Rigidbody>();
        fishingHandler = GetComponentInChildren<FishingHandler>(true);

        gameManager.InputActions.Boat.LaunchMagnet.performed += LaunchMagnet;
    }

    private void OnDestroy()
    {
        gameManager.InputActions.Boat.LaunchMagnet.performed -= LaunchMagnet;
    }

    private void OnEnable()
    {
        gameManager.InputActions.Boat.Enable();
        camera.SetActive(true);
    }

    private void OnDisable()
    {
        gameManager.InputActions.Boat.Disable();
        camera.SetActive(false);
    }

    private void OnDrawGizmosSelected()
    {
        Gizmos.color = Color.green;
        Gizmos.DrawWireSphere(transform.position, floatMinDistance);
        Gizmos.DrawWireSphere(transform.position, floatMaxDistance);
    }

    private void FixedUpdate()
    {
        Navigate();

        if (magnetLaunched && Vector2.Distance(relativeFloatPos, transform.position) >= floatMinDistance && fishingHandler.CanFish())
        {
            StartFishing();
        }
    }

    void Navigate()
    {
        Vector2 moveInput = gameManager.InputActions.Boat.Move.ReadValue<Vector2>();

        rb.linearVelocity *= drag;
        rb.linearVelocity += moveInput.y * accel * transform.forward;
        rb.maxLinearVelocity = maxSpeed;

        rb.angularVelocity += new Vector3(0, moveInput.x * angularAccel, 0);

        //print(rb.linearVelocity.magnitude);
    }

    private void Update()
    {
        if (magnetLaunched)
        {
            fishingPivot.LookAt(Utils.SetY(fishingFloat.transform.position, 0), Vector3.up);

            relativeFloatPos = Utils.XZ(fishingFloat.transform.position - transform.position);
            relativeFloatPos = Vector2.ClampMagnitude(relativeFloatPos, floatMaxDistance);
            fishingFloat.transform.position = Utils.XyY(relativeFloatPos) + transform.position;
        }
        else
        {
            fishingPivot.rotation = Quaternion.Euler(0, camera.transform.rotation.eulerAngles.y, 0);

            canLaunchMagnet = target.CanLaunch() && rb.linearVelocity.magnitude <= launchMaxSpeed;
            target.SetVisible(canLaunchMagnet);
        }
    }

    private void LaunchMagnet(InputAction.CallbackContext context)
    {
        if (magnetLaunched)
        {
            magnetLaunched = false;
            fishingFloat.SetActive(false);
        }
        else if (canLaunchMagnet)
        {
            magnetLaunched = true;
            target.SetVisible(false);
            fishingFloat.SetActive(true);
            fishingFloat.transform.position = target.transform.position;
        }
    }

    void StartFishing()
    {
        enabled = false;
        rb.linearVelocity = Vector3.zero;
        rb.angularVelocity = Vector3.zero;

        fishingHandler.StartFishing(EndFishing);
    }

    void EndFishing()
    {
        enabled = true;
        magnetLaunched = false;
    }
}
