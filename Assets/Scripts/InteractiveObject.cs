using UnityEngine;
using UnityEngine.Events;

[RequireComponent(typeof(Collider))]
public class InteractiveObject : MonoBehaviour
{
    GameManager gameManager;

    public bool once;
    public string interactionName;

    [SerializeField] UnityEvent onInteract;

    private void Start()
    {
        gameManager = GameManager.Instance;
    }

    private void OnTriggerEnter(Collider other)
    {
        if (enabled && other.CompareTag("Player"))
        {
            gameManager.InteractiveObject = this;
        }
    }

    private void OnTriggerExit(Collider other)
    {
        if (gameManager.InteractiveObject == this && other.CompareTag("Player"))
        {
            gameManager.InteractiveObject = null;
        }
    }

    private void OnDisable()
    {
        if (gameManager.InteractiveObject == this)
        {
            gameManager.InteractiveObject = null;
        }
    }

    public void Interact()
    {
        onInteract?.Invoke();

        if (once)
        {
            enabled = false;
        }
    }
}
