using System.Collections;
using UnityEngine;
using UnityEngine.Audio;

public class BurgerQuest : MonoBehaviour
{
    [SerializeField] Achievement achievement;
    [SerializeField] AudioResource sound;
    public void Eat()
    {
        StartCoroutine(EatRoutine());
    }

    IEnumerator EatRoutine()
    {
        AudioManager.Instance.PlaySFXAt(sound, transform.position);

        for (int i = 0; i < transform.childCount; i++)
        {
            Destroy(transform.GetChild(i).gameObject);
        }

        yield return new WaitForSeconds(1);

        GameManager.Instance.UnlockAchievement(achievement);
        Destroy(gameObject);
    }
}
