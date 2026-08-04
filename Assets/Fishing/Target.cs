using UnityEngine;

public class Target : MonoBehaviour
{
    int collisionCount;

    private void OnTriggerEnter(Collider other)
    {
        collisionCount++;
    }

    private void OnTriggerExit(Collider other)
    {
        collisionCount--;
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
