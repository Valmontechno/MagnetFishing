using System;
using System.IO;
using UnityEngine;

[CreateAssetMenu(fileName = "Item", menuName = "Scriptable Objects/Item")]
public class Item : ScriptableObject
{
    [ShowWarningIf(nameof(UseCount), 1, "Unused", Comparison = UnityComparisonMethod.Less)]
    [EditorButton(nameof(GenerateIcon), PositionType = ButtonPositionType.Above)]
#if UNITY_EDITOR
    [ScriptableObjectIcon]
#endif
    public Sprite icon;
    [ShowWarningIf(nameof(UseCount), 1, "Used several times", Comparison = UnityComparisonMethod.Greater)]
    public GameObject visual;
    public Quaternion rotation;
    public bool recenter = true;

    [Space]
    public string itemName;
    [NotNull(UnityMessageType.Warning)]
    public GameObject obstacle;
    public float masse = 1;
    public int gramMasse;

    int UseCount()
    {
        int count = 0;
        foreach (SubmergedItem submergedItem in Resources.FindObjectsOfTypeAll<SubmergedItem>())
        {
            if (submergedItem.item == this)
                count++;
        }
        return count;
    }

    public void GetOffsetAndScale(out Vector3 offset, out Vector3 scale)
    {
        MeshRenderer mr = visual.GetComponentInChildren<MeshRenderer>();
        offset = mr.bounds.center;
        scale = Vector3.one / mr.bounds.size.magnitude * 10;
    }

    void GenerateIcon()
    {
#if UNITY_EDITOR
        const int size = 128;
        string path = "/Fishing/Items/Icons/" + name + ".png";

        ShootingCamera shootingCamera = FindAnyObjectByType<ShootingCamera>(FindObjectsInactive.Include);
        Camera camera = shootingCamera.GetComponentInChildren<Camera>(true);

        RenderTexture defaultRT = camera.targetTexture;

        RenderTexture rt = new(size, size, 24, RenderTextureFormat.ARGB32)
        {
            antiAliasing = 8
        };

        camera.targetTexture = rt;

        RenderTexture previous = RenderTexture.active;
        RenderTexture.active = rt;

        shootingCamera.StartShooting(this);

        camera.Render();

        shootingCamera.EndShooting();

        Texture2D tex = new(size, size, TextureFormat.RGBA32, false);
        tex.ReadPixels(new Rect(0, 0, size, size), 0, 0);
        tex.Apply();

        byte[] png = tex.EncodeToPNG();
        File.WriteAllBytes(Application.dataPath + path, png);

        camera.targetTexture = defaultRT;
        RenderTexture.active = previous;

        DestroyImmediate(rt);
        DestroyImmediate(tex);

        UnityEditor.AssetDatabase.Refresh();


        UnityEditor.AssetDatabase.ImportAsset("Assets" + path);

        UnityEditor.TextureImporter importer = UnityEditor.AssetImporter.GetAtPath("Assets" + path) as UnityEditor.TextureImporter;
        importer.textureType = UnityEditor.TextureImporterType.Sprite;
        importer.spriteImportMode = UnityEditor.SpriteImportMode.Single;
        importer.alphaIsTransparency = true;
        importer.mipmapEnabled = false;

        importer.SaveAndReimport();

        icon = UnityEditor.AssetDatabase.LoadAssetAtPath<Sprite>("Assets" + path);

        UnityEditor.EditorUtility.SetDirty(this);
        UnityEditor.AssetDatabase.SaveAssets();

        Debug.Log($"Icon Saved : {"Assets" + path}");
#endif
    }
}
