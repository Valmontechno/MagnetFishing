using System.Collections;
using UnityEngine;
using UnityEngine.Audio;

public class MainMenu : MonoBehaviour
{
    GameManager gameManager;
    AudioManager audioManager;

    [SerializeField] AudioResource startSound;
    [SerializeField] AudioSource music;

    [Space]
    [SerializeField] GameObject introKinematic;
    [SerializeField] GameObject removeObjects;
    [SerializeField] GameObject playerCamera;
    [SerializeField] Animation fade;

    private void Start()
    {
        gameManager = GameManager.Instance;
        audioManager = AudioManager.Instance;

        gameManager.HideMouse();

        gameManager.player.gameObject.SetActive(false);
    }

    public void EnableMenu()
    {
        gameManager.ShowMouse();

        music.Play();
    }

    public void QuitGame()
    {
        audioManager.PlayUI(UISound.Close);
        gameManager.QuitGame();
    }

    public void StartGame()
    {
        StartCoroutine(StartGameRoutine());
    }

    IEnumerator StartGameRoutine()
    {
        audioManager.PlayUI(startSound);
        gameManager.HideMouse();

        fade.Play();
        yield return new WaitForSeconds(1);

        introKinematic.SetActive(false);
        removeObjects.SetActive(false);
        gameObject.SetActive(false);

        playerCamera.SetActive(true);
        gameManager.player.gameObject.SetActive(true);

    }
}
