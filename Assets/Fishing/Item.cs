using System.IO;
using UnityEngine;

[CreateAssetMenu(fileName = "Item", menuName = "Scriptable Objects/Item")]
public class Item : ScriptableObject
{
    [EditorButton(nameof(GenerateIcon), PositionType = ButtonPositionType.Above)]
    public Sprite icon;

    [Space]
    public GameObject visual;
    public GameObject obstacle;
    public float masse = 1;

    void GenerateIcon()
    {
#if UNITY_EDITOR
        const int size = 128;
        string path = "/Fishing/Item Visuals/Icons/" + name + ".png";

        Camera camera = GameObject.Find("Shooting Camera").GetComponent<Camera>();

        RenderTexture defaultRT = camera.targetTexture;

        RenderTexture rt = new(size, size, 24, RenderTextureFormat.ARGB32)
        {
            antiAliasing = 8
        };

        camera.targetTexture = rt;

        RenderTexture previous = RenderTexture.active;
        RenderTexture.active = rt;

        GameObject shootingItem = Instantiate(visual);
        shootingItem.layer = LayerMask.NameToLayer("ItemShooting");
        shootingItem.transform.SetPositionAndRotation(Vector3.zero, Quaternion.identity);

        camera.Render();

        DestroyImmediate(shootingItem);

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

        Debug.Log($"Icon Saved : {"Assets" + path}");
#endif
    }
}
