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
    Animator animator;

    [Space]
    [SerializeField] GameObject boatPlayerVisual;
    [SerializeField] new GameObject camera;
    CinemachineOrbitalFollow orbitalFollow;
    [SerializeField] Transform fishingPivot;
    [SerializeField] GameObject fishingFloat;
    [SerializeField] Target target;
    [SerializeField] HUD hud;

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
    [SerializeField] float interactionMaxSpeed;
    [SerializeField] float exitSlopLimit;
    [SerializeField] LayerMask checkGroundLayer;
    [SerializeField] Transform checkGroundRayOrigin;
    [SerializeField] float checkGroundOffset;
    [SerializeField] float checkGroundDistance;
    [SerializeField] string exitMessage;

    [Space]
    [SerializeField] float floatMaxDistance;
    [SerializeField] float floatMinDistance;
    bool canLaunchMagnet = false;
    //bool magnetLaunched = false;
    //Vector2 relativeFloatPos;

    [Space]
    [SerializeField] Achievement enterboatAchievement;

    Vector2 moveInput, lookInput;

    readonly Vector3[] directions = new Vector3[] { Vector3.forward, Vector3.back, Vector3.right, Vector3.left };
    bool canExitBoat = false;
    Vector3 exitPosition;
    float exitRotationY;

    private void Awake()
    {
        gameManager = GameManager.Instance;
        rb = GetComponent<Rigidbody>();
        orbitalFollow = camera.GetComponent<CinemachineOrbitalFollow>();
        fishingHandler = fishingPivot.GetComponentInChildren<FishingHandler>(true);
        animator = boatPlayerVisual.GetComponent<Animator>();

        gameManager.InputActions.Boat.LaunchMagnet.performed += LaunchMagnet;
        gameManager.InputActions.Boat.ExitBoat.performed += ExitBoat;
    }

    private void OnDestroy()
    {
        gameManager.InputActions.Boat.LaunchMagnet.performed -= LaunchMagnet;
        gameManager.InputActions.Boat.ExitBoat.performed -= ExitBoat;
    }

    private void OnEnable()
    {
        gameManager.InputActions.Boat.Enable();

        orbitalFollow.VerticalAxis.Value = orbitalFollow.VerticalAxis.Center;
        target.gameObject.SetActive(true);
    }

    private void OnDisable()
    {
        gameManager.InputActions.Boat.Disable();

        target.gameObject.SetActive(false);
    }

    //private void OnDrawGizmosSelected()
    //{
    //    Gizmos.color = Color.green;
    //    Gizmos.DrawWireSphere(transform.position, floatMinDistance);
    //    Gizmos.DrawWireSphere(transform.position, floatMaxDistance);
    //}

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

        //if (magnetLaunched && Vector2.Distance(relativeFloatPos, transform.position) >= floatMinDistance && fishingHandler.CanFish())
        //{
        //    StartFishing();
        //}

        canExitBoat = CheckCanExit();
        if (canExitBoat)
            hud.ShowInteractionTooltip(exitMessage);
        else
            hud.HideInteractionTooltip();
    }

    void Navigate()
    {
        rb.linearVelocity += moveInput.y * accel * transform.forward;
        rb.angularVelocity += new Vector3(0, moveInput.x * angularAccel * (moveInput.y >= 0 ? 1 : -1), 0);

        transform.rotation = Quaternion.Euler(0, transform.eulerAngles.y, 0);

        //print(rb.linearVelocity.magnitude);
    }

    private void Update()
    {
        moveInput = gameManager.InputActions.Boat.Move.ReadValue<Vector2>();
        lookInput = gameManager.InputActions.Boat.Look.ReadValue<Vector2>();

        UpdateFishing();
        Look();

        animator.SetFloat("Speed", Mathf.Clamp01(moveInput.magnitude));
        animator.SetFloat("Direction", moveInput.y >= 0 ? 1 : -1);
    }

    void UpdateFishing()
    {
        //if (magnetLaunched)
        //{
        //    fishingPivot.LookAt(Utils.SetY(fishingFloat.transform.position, 0), Vector3.up);

        //    relativeFloatPos = Utils.XZ(fishingFloat.transform.position - transform.position);
        //    relativeFloatPos = Vector2.ClampMagnitude(relativeFloatPos, floatMaxDistance);
        //    fishingFloat.transform.position = Utils.XyY(relativeFloatPos) + transform.position;
        //}
        //else
        //{
            fishingPivot.transform.position = Utils.SetY(fishingPivot.transform.position, 0);
            fishingPivot.rotation = Quaternion.Euler(0, camera.transform.rotation.eulerAngles.y, 0);

            canLaunchMagnet = fishingHandler.CanLaunch() && rb.linearVelocity.magnitude <= interactionMaxSpeed;
            target.SetVisible(canLaunchMagnet);
        //}
    }

    void Look()
    {
        orbitalFollow.HorizontalAxis.Center = Utils.Warp180(transform.eulerAngles.y);

        recenterCameraTargetSpeed = 0;
        if (Mathf.Abs(lookInput.x) > 0.1)
        {
            recenterCameraTimer = recenterCameraDelay;
        }
        else
        {
            recenterCameraTimer -= Time.deltaTime;

            if (recenterCameraTimer <= 0 && moveInput.sqrMagnitude > 0.01)
            {
                recenterCameraTargetSpeed = Mathf.Abs(moveInput.x) > 0.1 ? recenterCameraTurnSpeed : recenterCameraForwardSpeed;
            }
        }

        recenterCameraSpeed = Mathf.MoveTowards(recenterCameraSpeed, recenterCameraTargetSpeed, recenterCameraAccel * Time.deltaTime);
        orbitalFollow.HorizontalAxis.Value = Utils.Warp180(Mathf.MoveTowardsAngle(orbitalFollow.HorizontalAxis.Value - orbitalFollow.HorizontalAxis.Center, 0, recenterCameraSpeed * Time.deltaTime) + orbitalFollow.HorizontalAxis.Center);
    }

    bool CheckCanExit()
    {
        if (rb.linearVelocity.magnitude > interactionMaxSpeed) return false;

        foreach (Vector3 direction in directions)
        {
            if (Physics.Raycast(checkGroundRayOrigin.position + transform.TransformDirection(direction) * checkGroundOffset + Vector3.up * 3, Vector3.down, out RaycastHit hit, 10, checkGroundLayer))
            {
                if (hit.collider.gameObject.layer == LayerMask.NameToLayer("CanLand") && Vector3.Angle(Vector3.up, hit.normal) <= exitSlopLimit)
                {
                    exitPosition = hit.point;
                    exitRotationY = Vector2.SignedAngle(Utils.XZ(exitPosition - transform.position), Vector2.up);
                    return true;
                }
            }
        }

        return false;
    }

    private void LaunchMagnet(InputAction.CallbackContext context)
    {
        //if (magnetLaunched)
        //{
        //    magnetLaunched = false;
        //    fishingFloat.SetActive(false);
        //}
        if (canLaunchMagnet)
        {
            //magnetLaunched = true;
            //target.SetVisible(false);
            //fishingFloat.SetActive(true);
            //fishingFloat.transform.position = target.transform.position;

            StartCoroutine(Fishing());
        }
    }

    //void StartFishing()
    //{
    //    StartCoroutine(Fishing());
    //}

    IEnumerator Fishing()
    {
        enabled = false;
        rb.linearVelocity = Vector3.zero;
        rb.angularVelocity = Vector3.zero;
        animator.SetFloat("Speed", 0);

        target.SetVisible(false);

        yield return StartCoroutine(fishingHandler.Fishing());

        enabled = true;
        //magnetLaunched = false;
    }

    public void EnterBoat()
    {
        enabled = true;
        camera.SetActive(true);
        ResetCamera();
        gameManager.player.EnterBoat();
        boatPlayerVisual.SetActive(true);
        hud.HideInteractionTooltip();
        gameManager.UnlockAchievement(enterboatAchievement);
    }

    private void ExitBoat(InputAction.CallbackContext context)
    {
        if (!canExitBoat) return;

        enabled = false;
        camera.SetActive(false);
        gameManager.player.ExitBoat(exitPosition, exitRotationY);
        boatPlayerVisual.SetActive(false);
        hud.HideInteractionTooltip();
    }
}
