using System;
using System.Collections;
using Unity.Cinemachine;
using UnityEngine;
using UnityEngine.InputSystem;

public class BoatController : MonoBehaviour
{
    GameManager gameManager;
    Rigidbody rb;
    FishingHandler fishingHandler;

    [Space]
    [SerializeField] new GameObject camera;
    CinemachineOrbitalFollow orbitalFollow;
    [SerializeField] Transform fishingPivot;
    [SerializeField] GameObject fishingFloat;
    [SerializeField] Target target;

    [Space]
    [SerializeField] float accel;
    [SerializeField] float angularAccel;

    [Space]
    [SerializeField] float recenterCameraForwardSpeed;
    [SerializeField] float recenterCameraTurnSpeed;
    [SerializeField] float recenterCameraAccel;
    [SerializeField] float recenterCameraDelay;
    float recenterCameraSpeed;
    float recenterCameraTargetSpeed;
    float recenterCameraTimer = 0;

    [Space]
    [SerializeField] float launchMaxSpeed;
    [SerializeField] float floatMaxDistance;
    [SerializeField] float floatMinDistance;
    bool canLaunchMagnet = false;
    bool magnetLaunched = false;
    Vector2 relativeFloatPos;

    Vector2 moveInput;

    private void Awake()
    {
        gameManager = GameManager.Instance;
        rb = GetComponent<Rigidbody>();
        orbitalFollow = camera.GetComponent<CinemachineOrbitalFollow>();
        fishingHandler = GetComponentInChildren<FishingHandler>(true);

        gameManager.InputActions.Boat.LaunchMagnet.performed += LaunchMagnet;

        ResetCamera();
    }

    private void OnDestroy()
    {
        gameManager.InputActions.Boat.LaunchMagnet.performed -= LaunchMagnet;
    }

    private void OnEnable()
    {
        gameManager.InputActions.Boat.Enable();
        camera.SetActive(true);

        orbitalFollow.VerticalAxis.Value = orbitalFollow.VerticalAxis.Center;
    }

    private void OnDisable()
    {
        gameManager.InputActions.Boat.Disable();
        //camera.SetActive(false);
    }

    private void OnDrawGizmosSelected()
    {
        Gizmos.color = Color.green;
        Gizmos.DrawWireSphere(transform.position, floatMinDistance);
        Gizmos.DrawWireSphere(transform.position, floatMaxDistance);
    }

    void ResetCamera()
    {
        orbitalFollow.HorizontalAxis.Center = Utils.Warp180(transform.eulerAngles.y);
        orbitalFollow.HorizontalAxis.Value = orbitalFollow.HorizontalAxis.Center;
        orbitalFollow.VerticalAxis.Value = orbitalFollow.VerticalAxis.Center;
        recenterCameraSpeed = 0;
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
        rb.linearVelocity += moveInput.y * accel * transform.forward;
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

        Vector2 lookInput = gameManager.InputActions.Boat.Look.ReadValue<Vector2>();
        moveInput = gameManager.InputActions.Boat.Move.ReadValue<Vector2>();

        orbitalFollow.HorizontalAxis.Center = Utils.Warp180(transform.eulerAngles.y);

        recenterCameraTargetSpeed = 0;
        if (Mathf.Abs(lookInput.x) > 0.1)
        {
            recenterCameraTimer = recenterCameraDelay;
        }
        else
        {
            recenterCameraTimer -= Time.deltaTime;

            if (recenterCameraTimer <= 0 && moveInput.y > 0.1)
            {
                recenterCameraTargetSpeed = Mathf.Abs(moveInput.x) > 0.1 ? recenterCameraTurnSpeed : recenterCameraForwardSpeed;
            }
        }

        recenterCameraSpeed = Mathf.MoveTowards(recenterCameraSpeed, recenterCameraTargetSpeed, recenterCameraAccel * Time.deltaTime);
        orbitalFollow.HorizontalAxis.Value = Utils.Warp180(Mathf.MoveTowardsAngle(orbitalFollow.HorizontalAxis.Value - orbitalFollow.HorizontalAxis.Center, 0, recenterCameraSpeed * Time.deltaTime) + orbitalFollow.HorizontalAxis.Center);
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
        StartCoroutine(Fishing());
    }

    IEnumerator Fishing()
    {
        enabled = false;
        rb.linearVelocity = Vector3.zero;
        rb.angularVelocity = Vector3.zero;

        yield return StartCoroutine(fishingHandler.Fishing());

        enabled = true;
        magnetLaunched = false;
    }
}
