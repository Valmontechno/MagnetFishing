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
    [SerializeField] RippleGenerator fishingFloat;
    [SerializeField] Menu menu;

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

            fishingFloat.gameObject.SetActive(true);
            fishingFloat.factor = submergedItem.item.masse / MagnetController.refMasse;
            magnet2D.StartFishing(submergedItem.item.masse);
        }

        while (magnet2D.CurrentState == MagnetController.State.Fishing) { yield return null; }

        // End
        {
            enabled = false;
            camera.SetActive(false);
            fishingFloat.gameObject.SetActive(false);
            fishingFloat.factor = 1;

            if (obstacle != null)
                Destroy(obstacle);


            if (magnet2D.CurrentState == MagnetController.State.Success)
            {
                submergedItem.Remove();

                yield return new WaitForSeconds(1);

                ItemSlot itemSlot = new(gameManager.Inventory.Count);
                //menu.OpenItemRecord(submergedItem.item, true, itemSlot);
                //while (menu.ItemRecordOpen) { yield return null; }
                gameManager.Inventory[submergedItem.item] = itemSlot;
            }
        }
    }

    private void Update()
    {
        fishingFloat.transform.position = ToWorld3D(magnet2D.transform.position, fishingFloat.transform.localPosition.y);
    }

    public bool CanFish()
    {
        return collisionCount == 0 && GameManager.Instance.overlappedSubmergedItem != null;
    }
}
