using System;
using System.Collections;
using System.Collections.Generic;
using Unity.Cinemachine;
using UnityEngine;
using UnityEngine.Audio;
using UnityEngine.InputSystem;
using UnityEngine.UIElements;

public class PlayerController : MonoBehaviour
{
    GameManager gameManager;
    AudioManager audioManager;
    CharacterController characterController;
    Animator animator;
    TrailRenderer trailRenderer;
    FishingHandler fishingHandler;
    CinemachineInputAxisController cinemachineInputAxisController;
    CinemachineOrbitalFollow orbitalFollow;

    [Space]
    [SerializeField] new CinemachineOrbitalFollow camera;
    [SerializeField] GameObject drowningCamera;
    [SerializeField] GameObject visual;
    [SerializeField] Transform fishingPivot;
    [SerializeField] Target target;
    [SerializeField] HUD hud;

    [Space]
    [SerializeField] float maxSpeed;
    [SerializeField] float accel;
    [SerializeField] float runningMaxSpeed;
    [SerializeField] float runningAccel;
    [SerializeField] float decel;
    [SerializeField] float gravity;
    [SerializeField] float visualRotationSpeed;

    [Space]
    [SerializeField] float trailDuration;
    [SerializeField] float trailSpeed;

    [Space]
    [SerializeField] AudioResource ploufSound;

    [Space]
    [SerializeField] Achievement splashAchievement;

    bool isRunning = false;
    Vector2 horizontalVelocity;
    float verticalVelocity;
    public Vector3 Velocity => new(horizontalVelocity.x, verticalVelocity, horizontalVelocity.y);

    bool drowning = false;
    Vector3 lastSecurePosition;
    int drowningCount = 0;

    bool canLaunchMagnet = false;

    private void Awake()
    {
        gameManager = GameManager.Instance;
        gameManager.player = this;
        audioManager = AudioManager.Instance;

        characterController = GetComponent<CharacterController>();
        animator = visual.GetComponent<Animator>();
        trailRenderer = GetComponentInChildren<TrailRenderer>();
        fishingHandler = fishingPivot.GetComponentInChildren<FishingHandler>();
        cinemachineInputAxisController = camera.GetComponent<CinemachineInputAxisController>();
        orbitalFollow = camera.GetComponent<CinemachineOrbitalFollow>();

        gameManager.InputActions.Player.Interact.performed += Interact;
        gameManager.InputActions.Player.LaunchMagnet.performed += LaunchMagnet;
        gameManager.InputActions.Player.Run.performed += Run;
    }

    private void OnDestroy()
    {
        gameManager.InputActions.Player.Interact.performed -= Interact;
        gameManager.InputActions.Player.LaunchMagnet.performed -= LaunchMagnet;
        gameManager.InputActions.Player.Run.performed -= Run;
    }

    private void OnEnable()
    {
        gameManager.InputActions.Player.Enable();
        cinemachineInputAxisController.enabled = true;

        target.gameObject.SetActive(true);
    }

    private void OnDisable()
    {
        gameManager.InputActions.Player.Disable();
        cinemachineInputAxisController.enabled = false;

        target.gameObject.SetActive(false);
    }

    void Teleport(Vector3 position)
    {
        bool chEnabled = characterController.enabled;
        characterController.enabled = false;
        transform.position = position;
        characterController.enabled = chEnabled;
    }

    private void Update()
    {
        Move();
        UpdateFishing();
    }

    void Move()
    {
        Vector2 moveInput = gameManager.InputActions.Player.Move.ReadValue<Vector2>();
        moveInput = Vector2.ClampMagnitude(moveInput, 1);

        Vector3 forward = camera.transform.forward;
        Vector3 right = camera.transform.right;
        forward.y = 0f;
        right.y = 0f;
        forward.Normalize();
        right.Normalize();

        if (Mathf.Abs(moveInput.x) > 0.01)
            horizontalVelocity.x += moveInput.x * (isRunning ? runningAccel : accel) * Time.deltaTime;
        else
            horizontalVelocity.x = Mathf.MoveTowards(horizontalVelocity.x, 0, decel * Time.deltaTime);

        if (Mathf.Abs(moveInput.y) > 0.01)
            horizontalVelocity.y += moveInput.y * (isRunning ? runningAccel : accel) * Time.deltaTime;
        else
            horizontalVelocity.y = Mathf.MoveTowards(horizontalVelocity.y, 0, decel * Time.deltaTime);

        horizontalVelocity = Vector2.ClampMagnitude(horizontalVelocity, (isRunning ? runningMaxSpeed : maxSpeed));

        if (characterController.isGrounded)
            verticalVelocity = -0.5f;
        else
            verticalVelocity += gravity * Time.deltaTime;

        characterController.Move((verticalVelocity * Vector3.up + horizontalVelocity.x * right + horizontalVelocity.y * forward) * Time.deltaTime);

        if (drowning)
        {
            Vector3 pos = transform.position;
            pos.y = Math.Max(pos.y, -3);
            Teleport(pos);
        }

        if (moveInput.sqrMagnitude > 0.01) {
            Vector3 rotation = visual.transform.rotation.eulerAngles;
            float targetRotY = camera.transform.eulerAngles.y - Vector2.SignedAngle(Vector2.up, moveInput);
            rotation.y = Mathf.MoveTowardsAngle(rotation.y, targetRotY, visualRotationSpeed * Time.deltaTime);
            visual.transform.rotation = Quaternion.Euler(rotation);
        }
        else
        {
            isRunning = false;
        }

        if (horizontalVelocity.sqrMagnitude < 0.01)
            animator.SetFloat("Speed", 0);
        else if (!isRunning)
            animator.SetFloat("Speed", 1);
        else
            animator.SetFloat("Speed", 2);

        trailRenderer.time = Mathf.MoveTowards(trailRenderer.time, isRunning ? trailDuration : 0, trailSpeed * Time.deltaTime);
    }

    private void Run(InputAction.CallbackContext context)
    {
        isRunning = gameManager.GameState.Contains("can-run");
    }

    void UpdateFishing()
    {
        fishingPivot.SetPositionAndRotation(Utils.SetY(fishingPivot.position, 0), Quaternion.Euler(0, camera.transform.eulerAngles.y, 0));

        canLaunchMagnet = fishingHandler.CanLaunch();
        target.SetVisible(canLaunchMagnet);
        hud.SetLaunchMagnetTooltipVisibility(canLaunchMagnet);
    }

    private void FixedUpdate()
    {
        if (drowning) return; 

        if (transform.position.y < 0)
        {
            StartCoroutine(Drowning());
        }
        else if (characterController.isGrounded)
        {
            lastSecurePosition = transform.position;
        }
    }

    IEnumerator Drowning()
    {
        drowning = true;

        drowningCount++;
        if (drowningCount == 3)
        {
            gameManager.UnlockAchievement(splashAchievement);
        }

        gameManager.InputActions.Player.Disable();
        camera.enabled = false;

        gameManager.sea.GenerateRipple(Utils.XZ(transform.position), 1.25f);

        audioManager.PlaySFXAt(ploufSound, transform.position);

        yield return new WaitForSeconds(2);

        gameManager.InputActions.Player.Enable();
        camera.enabled = true;

        Teleport(lastSecurePosition);

        horizontalVelocity = Vector2.zero;
        verticalVelocity = 0;

        drowning = false;
    }

    private void Interact(InputAction.CallbackContext context)
    {
        if (gameManager.InteractiveObject != null)
        {
            gameManager.InteractiveObject.Interact();
        }
    }

    public void EnterBoat()
    {
        enabled = false;
        visual.SetActive(false);
        GameManager.Instance.sea.SetTargetPosition(Vector2.zero);
    }

    public void ExitBoat(Vector3 position, float rotationY)
    {
        enabled = true;
        visual.SetActive(true);

        Teleport(position);
        SetRotation(rotationY);
    }

    private void LaunchMagnet(InputAction.CallbackContext context)
    {
        if (canLaunchMagnet)
        {
            StartCoroutine(Fishing());
        }

    }

    IEnumerator Fishing()
    {
        enabled = false;
        animator.SetFloat("Speed", 0);
        animator.SetTrigger("Throw");
        SetRotation(camera.transform.eulerAngles.y);

        horizontalVelocity = Vector2.zero;
        verticalVelocity = 0;

        target.SetVisible(false);

        yield return StartCoroutine(fishingHandler.Fishing());

        enabled = true;
        gameManager.InputActions.Player.Enable();
    }

    void SetRotation(float y)
    {
        visual.transform.rotation = Quaternion.Euler(0, y, 0);
        orbitalFollow.HorizontalAxis.Value = y;
    }
}
