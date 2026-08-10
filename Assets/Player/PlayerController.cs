using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;

public class PlayerController : MonoBehaviour
{
    GameManager gameManager;
    CharacterController characterController;
    FishingHandler fishingHandler;

    [Space]
    [SerializeField] new Transform camera;
    [SerializeField] GameObject visual;
    [SerializeField] Transform fishingPivot;
    [SerializeField] Target target;

    [Space]
    [SerializeField] float maxSpeed;
    [SerializeField] float accel;
    [SerializeField] float decel;
    [SerializeField] float gravity;

    Vector2 horizontalVelocity;
    float verticalVelocity;

    bool canLaunchMagnet = false;

    private void Awake()
    {
        gameManager = GameManager.Instance;
        gameManager.player = this;

        characterController = GetComponent<CharacterController>();
        fishingHandler = fishingPivot.GetComponentInChildren<FishingHandler>();

        gameManager.InputActions.Player.Interact.performed += Interact;
        gameManager.InputActions.Player.LaunchMagnet.performed += LaunchMagnet;
    }

    private void OnDestroy()
    {
        gameManager.InputActions.Player.Interact.performed -= Interact;
        gameManager.InputActions.Player.LaunchMagnet.performed -= LaunchMagnet;
    }

    private void OnEnable()
    {
        gameManager.InputActions.Player.Enable();

        target.gameObject.SetActive(true);
    }

    private void OnDisable()
    {
        gameManager.InputActions.Player.Disable();

        target.gameObject.SetActive(false);
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

        Vector3 forward = camera.forward;
        Vector3 right = camera.right;
        forward.y = 0f;
        right.y = 0f;
        forward.Normalize();
        right.Normalize();

        if (Mathf.Abs(moveInput.x) > 0.01)
            horizontalVelocity.x += moveInput.x * accel * Time.deltaTime;
        else
            horizontalVelocity.x = Mathf.MoveTowards(horizontalVelocity.x, 0, decel * Time.deltaTime);

        if (Mathf.Abs(moveInput.y) > 0.01)
            horizontalVelocity.y += moveInput.y * accel * Time.deltaTime;
        else
            horizontalVelocity.y = Mathf.MoveTowards(horizontalVelocity.y, 0, decel * Time.deltaTime);

        horizontalVelocity = Vector2.ClampMagnitude(horizontalVelocity, maxSpeed);

        if (characterController.isGrounded)
            verticalVelocity = -0.5f;
        else
            verticalVelocity += gravity * Time.deltaTime;

        characterController.Move((verticalVelocity * Vector3.up + horizontalVelocity.x * right + horizontalVelocity.y * forward) * Time.deltaTime);
    }

    void UpdateFishing()
    {
        fishingPivot.SetPositionAndRotation(Utils.SetY(fishingPivot.position, 0), Quaternion.Euler(0, camera.eulerAngles.y, 0));

        canLaunchMagnet = fishingHandler.CanLaunch();
        target.SetVisible(canLaunchMagnet);
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
    }

    public void ExitBoat(Vector3 position)
    {
        enabled = true;
        visual.SetActive(true);

        characterController.enabled = false;
        transform.position = position;
        characterController.enabled = true;
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
        horizontalVelocity = Vector2.zero;
        verticalVelocity = 0;

        target.SetVisible(false);

        yield return StartCoroutine(fishingHandler.Fishing());

        enabled = true;
    }
}
