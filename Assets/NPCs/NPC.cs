using UnityEngine;
using UnityEngine.AI;

public class NPC : MonoBehaviour
{
    NavMeshAgent agent;
    Animator animator;

    [ReorderableList, SerializeField] Transform[] destinations;
    int currentDestination = 0;

    private void Start()
    {
        agent = GetComponent<NavMeshAgent>();
        animator = GetComponentInChildren<Animator>();

        agent.SetDestination(destinations[currentDestination].position);
    }

    private void FixedUpdate()
    {
        if (Vector3.SqrMagnitude(transform.position - agent.destination) < 5)
        {
            currentDestination = (currentDestination + 1) % destinations.Length;

            agent.SetDestination(destinations[currentDestination].position);
        }

        animator.SetFloat("Speed", agent.isStopped ? 0 : 1);
    }
}
