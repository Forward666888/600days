# Compress all JPEG files for web
Add-Type -AssemblyName System.Drawing

$files = Get-ChildItem -Path '.' -Filter '*.jpg'
$total = $files.Count
$i = 0

foreach($file in $files) {
    $i++
    $name = $file.Name
    Write-Host "[$i/$total] $name"

    $img = [System.Drawing.Image]::FromFile($file.FullName)

    $w = $img.Width
    $h = $img.Height
    $maxDim = 1600

    if ($w -gt $maxDim -or $h -gt $maxDim) {
        if ($w -gt $h) {
            $newW = $maxDim
            $newH = [int]($h * $maxDim / $w)
        } else {
            $newH = $maxDim
            $newW = [int]($w * $maxDim / $h)
        }
    } else {
        $newW = $w
        $newH = $h
    }

    $bmp = New-Object System.Drawing.Bitmap($newW, $newH)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.InterpolationMode = 'HighQualityBicubic'
    $g.DrawImage($img, 0, 0, $newW, $newH)
    $g.Dispose()

    $encoder = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object { $_.FormatID -eq 'b96b3cae-0728-11d3-9d7b-0000f81ef32e' }
    $params = New-Object System.Drawing.Imaging.EncoderParameters(1)
    $params.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter([System.Drawing.Imaging.Encoder]::Quality, [int64]80)

    $tmp = [System.IO.Path]::GetTempFileName() + '.jpg'
    $bmp.Save($tmp, $encoder, $params)
    $bmp.Dispose()
    $img.Dispose()

    Move-Item -Path $tmp -Destination $file.FullName -Force

    $newSize = (Get-Item $file.FullName).Length
    Write-Host "  -> $([math]::Round($newSize/1MB, 2)) MB"
}
Write-Host 'Done! All images compressed.'
