using UnityEngine;

[RequireComponent(typeof(Rigidbody))]
public class ChBody : MonoBehaviour
{
    GameManager gameManager;
    Rigidbody rb;

    [SerializeField] float masse = 1;

    [SerializeField] Achievement splashAchievement;

    private void Start()
    {
        gameManager = GameManager.Instance;
        rb = GetComponent<Rigidbody>();
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
        if (transform.position.y < -10)
        {
            gameManager.UnlockAchievement(splashAchievement);

            Destroy(gameObject);
        }
    }
}
