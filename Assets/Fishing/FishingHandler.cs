using System;
using System.Collections;
using UnityEngine;

public class FishingHandler : MonoBehaviour
{
    GameManager gameManager;

    [Space]
    [SerializeField] float scale;

    [Space]
    [SerializeField] BoxCollider2D frame2D;
    [SerializeField] MagnetController magnet2D;

    [Space]
    [SerializeField] GameObject target;
    [SerializeField] new GameObject camera;
    [SerializeField] GameObject fishingFloat;

    //Action endFishingCallback;

    int collisionCount = 0;

    SubmergedItem submergedItem;
    GameObject obstacle;

    private void Awake()
    {
        gameManager = GameManager.Instance;
    }

    Vector3 ToLocal3D(Vector2 pos, float y=0)
    {
        return new Vector3(pos.x * scale, y, pos.y * scale);
    }

    Vector3 ToWorld3D(Vector2 pos, float y=0)
    {
        return transform.TransformPoint(ToLocal3D(pos, y));
    }

    private void OnDrawGizmos()
    {
        if (frame2D != null)
        {
            Gizmos.color = Color.yellow;
            Gizmos.matrix = transform.localToWorldMatrix;

            Gizmos.DrawWireCube(
                ToLocal3D(frame2D.offset),
                ToLocal3D(frame2D.size)
            );

            BoxCollider collider = GetComponent<BoxCollider>();
            collider.center = ToLocal3D(frame2D.offset);
            collider.size = ToLocal3D(frame2D.size, 1);
        }

        if (target != null && magnet2D != null)
        {
            target.transform.localPosition = ToLocal3D(magnet2D.startPoint.position);
        }
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

    public IEnumerator Fishing()
    {
        // Start
        {
            enabled = true;
            camera.SetActive(true);
            magnet2D.ResetPosition();

            yield return new WaitForSeconds(2);

            submergedItem = gameManager.overlappedSubmergedItem;

            if (submergedItem.item.obstacle != null)
                obstacle = Instantiate(gameManager.overlappedSubmergedItem.item.obstacle);

            fishingFloat.SetActive(true);
            magnet2D.StartFishing(submergedItem.item.masse);
        }

        while (magnet2D.CurrentState == MagnetController.State.Fishing) { yield return null; }

        // End
        {
            enabled = false;
            camera.SetActive(false);
            fishingFloat.SetActive(false);

            if (obstacle != null)
                Destroy(obstacle);


            if (magnet2D.CurrentState == MagnetController.State.Success)
            {
                submergedItem.Remove();

                gameManager.Inventory[submergedItem.item] = new(gameManager.Inventory.Count);
            }
        }
    }

    //public void StartFishing(Action endFishingCallback)
    //{
    //    this.endFishingCallback = endFishingCallback;

    //    //enabled = true;

    //    //camera.SetActive(true);
    //    //magnet2D.ResetPosition();

    //    //Invoke(nameof(Fishing), 2);
    //}

    //void Fishing()
    //{
    //    submergedItem = gameManager.overlappedSubmergedItem;

    //    if (submergedItem.item.obstacle != null)
    //        obstacle = Instantiate(gameManager.overlappedSubmergedItem.item.obstacle);

    //    fishingFloat.SetActive(true);
    //    magnet2D.StartFishing(this, submergedItem.item.masse);
    //}

    //public void EndFishing(bool succes)
    //{
    //    enabled = false;

    //    if (obstacle != null)
    //        Destroy(obstacle);

    //    camera.SetActive(false);
    //    fishingFloat.SetActive(false);

    //    if (succes)
    //    {
    //        submergedItem.Remove();

    //        gameManager.Inventory[submergedItem.item] = new(gameManager.Inventory.Count);
    //    }

    //    endFishingCallback.Invoke();
    //}

    private void Update()
    {
        fishingFloat.transform.position = ToWorld3D(magnet2D.transform.position, fishingFloat.transform.localPosition.y);
    }

    public bool CanFish()
    {
        return collisionCount == 0 && GameManager.Instance.overlappedSubmergedItem != null;
    }
}
