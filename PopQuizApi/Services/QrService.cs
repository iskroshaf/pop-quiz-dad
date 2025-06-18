using com.google.zxing.common;
using Newtonsoft.Json.Linq;
using SkiaSharp;
using System.Drawing;
using System.Drawing.Printing;
using ZXing;
using ZXing.Common;
using ZXing.QrCode;
using ZXing.SkiaSharp;
using ZXing.Windows.Compatibility;
namespace PopQuizApi.Services
{
    public class QrService
    {
        public Bitmap GenerateQRCode(string data)
        {
            var qrCodeWriter = new ZXing.BarcodeWriterPixelData
            {
                Format = ZXing.BarcodeFormat.QR_CODE,
                Options = new ZXing.QrCode.QrCodeEncodingOptions
                {
                    Height = 250,
                    Width = 250,
                    Margin = 2
                }
            };

            var pixelData = qrCodeWriter.Write(data);

            // Create the bitmap (do NOT dispose it)
            var bitmap = new System.Drawing.Bitmap(
                pixelData.Width, pixelData.Height,
                System.Drawing.Imaging.PixelFormat.Format32bppRgb);

            var rect = new Rectangle(0, 0, pixelData.Width, pixelData.Height);
            var bmpData = bitmap.LockBits(rect,
                System.Drawing.Imaging.ImageLockMode.WriteOnly,
                bitmap.PixelFormat);

            System.Runtime.InteropServices.Marshal.Copy(
                pixelData.Pixels, 0, bmpData.Scan0, pixelData.Pixels.Length);

            bitmap.UnlockBits(bmpData);

            // Return the bitmap—don't wrap it in 'using'
            return bitmap;

        }
    }
}
