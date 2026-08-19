using System.Collections;
using UnityEngine;
using UnityEngine.Audio;

public enum UISound {
    Click, Open, Close, Tab, Error
}

public class AudioManager : MonoBehaviour
{
    [SerializeField] GameObject audioSourcePrefab;
    [SerializeField] AudioMixerGroup SFXGroup;
    [SerializeField] AudioMixerGroup UIGroup;

    [Space]
    [SerializeField] AudioResource[] uiSounds;

    static public AudioManager Instance { get; private set; }

    private void Awake()
    {
        if (Instance != null)
        {
            Destroy(Instance.gameObject);
        }
        Instance = this;
    }

    public void PlaySFXAt(AudioResource resource, Vector3 position)
    {
        StartCoroutine(PlaySoundRoutine(resource, position, 1, SFXGroup));
    }

    public void PlayUI(AudioResource resource)
    {
        StartCoroutine(PlaySoundRoutine(resource, Vector3.zero, 0, UIGroup));
    }

    public void PlayUI(UISound uiSound)
    {
        StartCoroutine(PlaySoundRoutine(uiSounds[(int)uiSound], Vector3.zero, 0, UIGroup));
    }

    IEnumerator PlaySoundRoutine(AudioResource resource, Vector3 position, float spatialBlend, AudioMixerGroup group)
    {
        AudioSource source = Instantiate(audioSourcePrefab, transform).GetComponent<AudioSource>();

        source.transform.position = position;
        source.spatialBlend = spatialBlend;
        source.resource = resource;
        source.outputAudioMixerGroup = group;
        source.Play();

        yield return new WaitUntil(() => source.isPlaying);
        yield return new WaitUntil(() => !source.isPlaying);

        Destroy(source.gameObject);
    }
}
