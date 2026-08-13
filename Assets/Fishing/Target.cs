using UnityEngine;

public class Target : MonoBehaviour
{
    int collisionCount;

    private void Start()
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
        enabled = visible;
        transform.GetChild(0).gameObject.SetActive(visible);

        if (!visible)
        {
            GameManager.Instance.sea.SetTargetPosition(Vector2.zero);
        }
    }

    private void Update()
    {
        GameManager.Instance.sea.SetTargetPosition(Utils.XZ(transform.position));
    }
}
