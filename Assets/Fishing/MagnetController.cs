using System;
using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.Assertions.Must;
using UnityEngine.InputSystem;
using UnityEngine.UI;

public class MagnetController : MonoBehaviour
{
    GameManager gameManager;
    Rigidbody2D rb;
    AudioSource audioSource;

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

    [Space]
    [SerializeField] GameObject powerBar;
    [SerializeField] Image powerBarForeground;
    [SerializeField] Gradient powerBarGradient;
    [SerializeField] Color powerlessColor;
    [SerializeField] float maxPower;
    [SerializeField] float powerCounsumeSpeed;
    [SerializeField] float powerRegenerateSpeed;
    [SerializeField] float groundSlopeLimit;
    float power;
    bool isPowerless = false;

    [Space]
    [SerializeField] GameObject fishingHUD;

    [Space]
    [SerializeField] private float soundMinSpeed;
    [SerializeField] private float soundMaxSpeed;
    Vector3 prevPos = Vector3.zero;
    [SerializeField, Range(0f, 1f)] private float soundVolume;
    [SerializeField] float soundNotHoldVolumeFactor;
    [SerializeField] float soundVolumeModifSpeed;
    float soundVolumeTarget;

    Vector2 mouseInput = Vector2.zero;
    float scrollInput = 0;
    bool holding = false;

    bool isGrounded;
    readonly HashSet<Collider2D> groundColliders = new();

    public enum State { Fishing, Success, Failure, Aborted }
    public State CurrentState { get; private set; }

    private void Awake()
    {
        gameManager = GameManager.Instance;
        rb = GetComponent<Rigidbody2D>();
        audioSource = GetComponent<AudioSource>();

        gameObject.SetActive(false);

        gameManager.InputActions.Fishing.Abort.performed += AbortFishing;
    }

    private void OnDestroy()
    {
        gameManager.InputActions.Fishing.Abort.performed -= AbortFishing;
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

        prevPos = transform.position;
        soundVolumeTarget = 0;
    }

    public void StartFishing(float masse)
    {
        CurrentState = State.Fishing;

        this.masse = masse;
        if (gameManager.GameState.Contains("has-super-magnet"))
            this.masse = this.masse / 2;
        this.masse = Mathf.Max(this.masse, 1);

        power = maxPower;
        groundColliders.Clear();

        //powerBar.SetActive(true);
        fishingHUD.SetActive(true);
        gameObject.SetActive(true);

        audioSource.Play();
    }

    public void EndFishing(State state)
    {
        CurrentState = state;

        //powerBar.SetActive(false);
        fishingHUD.SetActive(false);
        gameObject.SetActive(false);

        audioSource.Stop();
    }

    private void Update()
    {
        mouseInput += gameManager.InputActions.Fishing.Move.ReadValue<Vector2>();
        if (scrollEnabled)
            scrollInput += gameManager.InputActions.Fishing.Pull.ReadValue<float>();
        holding = !isPowerless && gameManager.InputActions.Fishing.Hold.ReadValue<float>() > 0;


        if (isGrounded || groundColliders.Count > 0)
        {
            power = Mathf.Min(power + powerRegenerateSpeed * Time.deltaTime, maxPower);
            if (power >= maxPower)
                isPowerless = false;
        }
        else
        {
            power = Mathf.Max(power - powerCounsumeSpeed * Time.deltaTime, 0);
            if (power <= 0)
                isPowerless = true;
        }

        powerBarForeground.fillAmount = power / maxPower;
        if (isPowerless)
            powerBarForeground.color = powerlessColor;
        else
            powerBarForeground.color = powerBarGradient.Evaluate(powerBarForeground.fillAmount);


        if (transform.position.y <= 0)
        {
            EndFishing(State.Success);
        }
        //else if (power <= 0)
        //{
        //    EndFishing(State.Failure);
        //}

        //audioSource.volume = Mathf.MoveTowards(audioSource.volume, targetVolume, volumeSpeed * Time.deltaTime);
        //audioSource.volume = targetVolume;

        float speed = Vector3.Distance(prevPos, transform.position) / Time.deltaTime;
        prevPos = transform.position;

        speed = Mathf.Clamp(speed, soundMinSpeed, soundMaxSpeed);
        float t = Mathf.InverseLerp(soundMinSpeed, soundMaxSpeed, speed);
        if (!holding) t *= soundNotHoldVolumeFactor;
        soundVolumeTarget = t * soundVolume;

        if (soundVolumeTarget >= audioSource.volume)
        {
            audioSource.volume = soundVolumeTarget;
        }
        else
        {
            audioSource.volume = Mathf.MoveTowards(audioSource.volume, soundVolumeTarget, soundVolumeModifSpeed * Time.deltaTime);
        }
    }

    private void FixedUpdate()
    {
        mouseInput = Vector2.ClampMagnitude(mouseInput, maxMouseMove);

        isGrounded = transform.position.y >= startPoint.position.y - startRadius;

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

    private void OnCollisionStay2D(Collision2D collision)
    {
        if (Vector2.Angle(collision.contacts[0].normal, Vector2.down) <= groundSlopeLimit)
        {
            groundColliders.Add(collision.collider);
        }
    }

    private void OnCollisionExit2D(Collision2D collision)
    {
        groundColliders.Remove(collision.collider);
    }

    private void AbortFishing(InputAction.CallbackContext context)
    {
        EndFishing(State.Aborted);
    }
}
