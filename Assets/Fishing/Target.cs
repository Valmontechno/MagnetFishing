using UnityEngine;

public class Target : MonoBehaviour
{
    int collisionCount;

    private void Awake()
    {
        SetVisible(false);
    }

    private void OnTriggerEnter(Collider other)
    {
        if (!other.isTrigger)
        {
            collisionCount++;
        }
    }

    private void OnTriggerExit(Collider other)
    {
        if (!other.isTrigger)
        {
            collisionCount--;
        }
    }

    public bool CanLaunch()
    {
        return collisionCount == 0;
    }

    public void SetVisible(bool visible)
    {
        transform.GetChild(0).gameObject.SetActive(visible);
    }
}
