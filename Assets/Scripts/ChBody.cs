using UnityEngine;
using UnityEngine.Audio;

[RequireComponent(typeof(Rigidbody))]
public class ChBody : MonoBehaviour
{
    GameManager gameManager;
    Rigidbody rb;

    [SerializeField] bool respawn;
    [SerializeField] float masse = 1;

    [SerializeField] Achievement splashAchievement;
    [SerializeField] AudioResource splashSound;

    Vector3 spawnPosition;
    Quaternion spawnRotation;

    bool isFall = false;

    private void Start()
    {
        gameManager = GameManager.Instance;
        rb = GetComponent<Rigidbody>();

        spawnPosition = transform.position;
        spawnRotation = transform.rotation;
    }

    private void OnCollisionEnter(Collision collision)
    {
        if (collision.gameObject.CompareTag("Player"))
        {
            rb.AddForceAtPosition(gameManager.player.Velocity / masse, collision.contacts[0].point, ForceMode.Impulse);
        }
    }

    private void FixedUpdate()
    {
        if (transform.position.y < 0)
        {
            if (!isFall)
            {
                gameManager.sea.GenerateRipple(Utils.XZ(transform.position), 1);
                AudioManager.Instance.PlaySFXAt(splashSound, transform.position);

                isFall = true;
            }

            if (transform.position.y < -10)
            {
                if (respawn)
                {
                    transform.SetPositionAndRotation(spawnPosition, spawnRotation);

                    rb.linearVelocity = Vector3.zero;
                    rb.angularVelocity = Vector3.zero;

                    isFall = false;
                }
                else
                {
                    gameManager.UnlockAchievement(splashAchievement);

                    Destroy(gameObject);
                }
            }
        }
    }
}
