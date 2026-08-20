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

    //public int collisionCount = 0;
    readonly HashSet<Collider> collisions = new();

    SubmergedItem submergedItem;
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
        return transform.TransformPoint(ToLocal3D(pos, y));
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

            submergedItem = gameManager.overlappedSubmergedItem;

            fishingFloat.gameObject.SetActive(true);
            fishingFloat.transform.position = target.transform.position;
            lineRenderer.enabled = true;

            audioManager.PlaySFXAt(ploufSound, fishingFloat.transform.position);

            if (submergedItem != null)
            {
                fishingFloat.factor = submergedItem.item.masse / MagnetController.refMasse;
                magnet2D.StartFishing(submergedItem.item.masse);


                yield return new WaitForSeconds(1);

                if (submergedItem.item.obstacle != null)
                    obstacle = Instantiate(gameManager.overlappedSubmergedItem.item.obstacle);

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

                Item item = null;
                if (submergedItem != null)
                {
                    item = submergedItem.item;
                    submergedItem.Remove();
                }

                yield return new WaitForSeconds(1);

                if (item != null)
                {
                    gameManager.ShowMouse();
                    audioManager.PlayUI(getItemSound);

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
        fishingFloat.transform.position = ToWorld3D(magnet2D.transform.position, fishingFloat.transform.localPosition.y);
        powerBar.position = Camera.main.WorldToScreenPoint(fishingFloat.transform.position);

        lineRenderer.SetPosition(0, fishingFloat.transform.position);
        lineRenderer.SetPosition(1, ropeOrigin.position + Vector3.up * 1);
    }

    public bool CanFish()
    {
        return CanLaunch() && GameManager.Instance.overlappedSubmergedItem != null;
    }

    public bool CanLaunch()
    {
        //return collisionCount == 0;
        return collisions.Count == 0;
    }
}
