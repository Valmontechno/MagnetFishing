using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using UnityEngine.Audio;

public class FishingHandler : MonoBehaviour
{
    GameManager gameManager;
    AudioManager audioManager;
    LineRenderer lineRenderer;

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
    [SerializeField] HUD hud;
    [SerializeField] Transform powerBar;
    [SerializeField] Transform ropeOrigin;
    [SerializeField] string noItemMessage;

    [Space]
    [SerializeField] AudioResource ploufSound;
    [SerializeField] AudioResource bigPloufSound;
    [SerializeField] AudioResource magnetSound;
    [SerializeField] AudioResource getItemSound;

    [Space]
    [SerializeField] LayerMask submergedItemLayer;
    [SerializeField] SubmergedItem[] firstSubmergedItems;

    //public int collisionCount = 0;
    readonly HashSet<Collider> collisions = new();

    SubmergedItem submergedItem;
    Item item;
    Item originalItem;
    GameObject obstacle;

    private void Awake()
    {
        gameManager = GameManager.Instance;
        audioManager = AudioManager.Instance;
        lineRenderer = GetComponent<LineRenderer>();
    }

    Vector3 ToLocal3D(Vector2 pos, float y=0)
    {
        return new Vector3(pos.x * scale, y, pos.y * scale);
    }

    Vector3 ToWorld3D(Vector2 pos, float y=0)
    {
        Vector3 position = transform.TransformPoint(ToLocal3D(pos));
        position.y = y;
        return position;
    }

    private void OnDrawGizmosSelected()
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
            collider.size = ToLocal3D(frame2D.size, 3);
        }

        if (target != null && magnet2D != null)
        {
            target.transform.localPosition = ToLocal3D(magnet2D.startPoint.position);
        }
    }

    private void OnTriggerStay(Collider other)
    {
        if (!other.isTrigger)
        {
            //collisionCount++;
            collisions.Add(other);
        }
    }

    private void OnTriggerExit(Collider other)
    {
        if (!other.isTrigger)
        {
            //collisionCount--;
            collisions.Remove(other);
        }
    }

    public IEnumerator Fishing()
    {
        // Start
        {
            enabled = true;
            camera.SetActive(true);
            magnet2D.ResetPosition();
            hud.HideInteractionTooltip();
            hud.SetLaunchMagnetTooltipVisibility(false);
            gameManager.SetSubmergedItemVisibility(false);

            yield return new WaitForSeconds(2);

            submergedItem = null;
            item = null;
            originalItem = null;

            if (Physics.Raycast(target.transform.position + Vector3.up * 20, Vector3.down, out RaycastHit hit, 30, submergedItemLayer))
            {
                submergedItem = hit.collider.GetComponent<SubmergedItem>();
                originalItem = submergedItem.item;
                if (gameManager.Inventory.Count < firstSubmergedItems.Length)
                {
                    item = firstSubmergedItems[gameManager.Inventory.Count].item;
                }
                else
                {
                    item = submergedItem.item;
                }
            }
            

            fishingFloat.gameObject.SetActive(true);
            fishingFloat.transform.position = target.transform.position;
            lineRenderer.enabled = true;

            audioManager.PlaySFXAt(ploufSound, fishingFloat.transform.position);

            if (item != null)
            {
                fishingFloat.factor = item.masse / MagnetController.refMasse;
                magnet2D.StartFishing(item.masse);


                yield return new WaitForSeconds(1);

                if (item.obstacle != null)
                {
                    obstacle = Instantiate(item.obstacle);
                    System.Random random = new(gameManager.Seed + item.GetEntityId());
                    if (random.NextDouble() > 0.5)
                        obstacle.transform.localScale = new Vector3(-1, 1, 1);
                }

                audioManager.PlaySFXAt(magnetSound, fishingFloat.transform.position);
            }
            else
            {
                gameManager.sea.GenerateRipple(Utils.XZ(fishingFloat.transform.position), 0.25f);

                yield return new WaitForSeconds(0.7f);

                magnet2D.EndFishing(MagnetController.State.Failure);

                hud.ToastMessage(noItemMessage);
            }
        }

        while (magnet2D.CurrentState == MagnetController.State.Fishing) { yield return null; }

        // End
        {
            enabled = false;
            camera.SetActive(false);
            fishingFloat.gameObject.SetActive(false);
            lineRenderer.enabled = false;
            fishingFloat.factor = 1;
            gameManager.SetSubmergedItemVisibility(true);

            if (obstacle != null)
                Destroy(obstacle);

            gameManager.sea.GenerateRipple(Utils.XZ(fishingFloat.transform.position), 0.25f);


            if (magnet2D.CurrentState == MagnetController.State.Success)
            {
                audioManager.PlaySFXAt(bigPloufSound, fishingFloat.transform.position);

                if (gameManager.Inventory.Count < firstSubmergedItems.Length)
                {
                    firstSubmergedItems[gameManager.Inventory.Count].item = originalItem;
                }

                if (submergedItem != null)
                {
                    submergedItem.Remove();
                }

                yield return new WaitForSeconds(1);

                if (item != null)
                {
                    gameManager.ShowMouse();
                    audioManager.PlayUI(getItemSound);

                    gameManager.money += item.gramMasse;

                    ItemSlot itemSlot = new(gameManager.Inventory.Count);
                    menu.itemRecordModal.OpenModal(item, itemSlot);
                    while (menu.itemRecordModal.IsOpen) { yield return null; }
                    gameManager.Inventory[item] = itemSlot;

                    if (gameManager.bikeItems.Contains(item))
                    {
                        menu.bikeQuestModal.OpenModal(item);
                        while (menu.bikeQuestModal.IsOpen) { yield return null; }
                    }

                    gameManager.HideMouse();
                }
            }
            else /*if (magnet2D.CurrentState != MagnetController.State.Failure)*/
            {
                audioManager.PlaySFXAt(ploufSound, fishingFloat.transform.position);
            }
        }
    }

    private void Update()
    {
        fishingFloat.transform.position = ToWorld3D(magnet2D.transform.position, fishingFloat.transform.position.y);
        powerBar.position = Camera.main.WorldToScreenPoint(fishingFloat.transform.position);

        lineRenderer.SetPosition(0, fishingFloat.transform.position);
        lineRenderer.SetPosition(1, ropeOrigin.position + Vector3.up * 1);
    }

    public bool CanLaunch()
    {
        return collisions.Count == 0;
    }
}
