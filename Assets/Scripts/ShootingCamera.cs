using System.Collections.Generic;
using System.IO;
using UnityEngine;

public class ShootingCamera : MonoBehaviour
{
    [EditorButton(nameof(TakeScreenshot))]
    [SerializeField] Quaternion defaultRotation;
    //[SerializeField] Material rustMaterial;

    GameObject itemGO;

    public void StartShooting(Item item)
    {
        if (item.visual == null)
        {
            itemGO = null;
        }
        else
        {
            gameObject.SetActive(true);
            transform.rotation = defaultRotation;

            itemGO = Instantiate(item.visual);
            item.GetOffsetAndScale(out Vector3 offset, out Vector3 scale);
            itemGO.transform.localScale = Vector3.Scale(itemGO.transform.localScale, scale);

            if (item.recenter)
            {
                itemGO.transform.rotation *= item.rotation;
                itemGO.transform.position = Vector3.zero - Vector3.Scale(offset, scale);
            }
            else
                itemGO.transform.position = Vector3.zero;


            foreach (Renderer renderer in itemGO.GetComponentsInChildren<Renderer>())
            {
                renderer.gameObject.layer = LayerMask.NameToLayer("ItemShooting");

                //Material[] materials = renderer.materials;

                //for (int i = 0; i < materials.Length; i++)
                //{
                //    materials[i] = rustMaterial;
                //}

                //renderer.materials = materials;
            }
        }
    }

    public void EndShooting()
    {
        if (itemGO != null)
        {
            gameObject.SetActive(false);
            DestroyImmediate(itemGO);
        }
    }

    public void TakeScreenshot()
    {
        Camera camera = GetComponentInChildren<Camera>(true);

        RenderTexture previousTarget = camera.targetTexture;
        RenderTexture previousActive = RenderTexture.active;

        RenderTexture capture = new RenderTexture(
            512,
            512,
            24,
            RenderTextureFormat.ARGB32,
            RenderTextureReadWrite.sRGB
        );

        capture.name = "ScreenshotCapture";
        capture.Create();

        try
        {
            // Remplace temporairement la RenderTexture de la caméra
            camera.targetTexture = capture;

            // Rend la caméra dans la RenderTexture
            camera.Render();

            // Lit cette RenderTexture
            RenderTexture.active = capture;

            Texture2D image = new Texture2D(
                512,
                512,
                TextureFormat.RGBA32,
                false
            );

            image.ReadPixels(
                new Rect(0, 0, 512, 512),
                0,
                0
            );

            image.Apply();

            // Encode en PNG
            byte[] png = image.EncodeToPNG();

            string path = Path.Combine(
                Application.dataPath,
                "Screenshot.png"
            );

            File.WriteAllBytes(path, png);

            DestroyImmediate(image);

            Debug.Log($"Screenshot saved : {path}");
        }
        finally
        {
            // Restaure l'état précédent
            camera.targetTexture = previousTarget;
            RenderTexture.active = previousActive;

            capture.Release();
            DestroyImmediate(capture);
        }
    }
}
