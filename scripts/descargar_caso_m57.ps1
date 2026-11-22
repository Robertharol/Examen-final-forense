# Descarga las evidencias del Caso 1 (M57-Patents) en el Escritorio\caso m57 patent
# Uso: clic derecho en el menu Inicio > "Windows PowerShell" y pegar:
#   powershell -ExecutionPolicy Bypass -File .\descargar_caso_m57.ps1
# Si se corta, vuelve a ejecutarlo: continua donde se quedo.

$base = "https://digitalcorpora.s3.amazonaws.com/corpora/scenarios/2009-m57-patents"
$raiz = Join-Path ([Environment]::GetFolderPath('Desktop')) "caso m57 patent"

$archivos = @(
  # carpeta destino | ruta en el servidor | nombre local
  @("01_documentos", "docs/M57-Patents-Illegal.pdf",              "M57-Patents-Illegal.pdf"),
  @("01_documentos", "docs/detectivereport1.pdf",                 "detectivereport1.pdf"),
  @("01_documentos", "docs/detectivereport2.pdf",                 "detectivereport2.pdf"),
  @("01_documentos", "docs/detectivereport3.pdf",                 "detectivereport3.pdf"),
  @("01_documentos", "docs/detectivereport4.pdf",                 "detectivereport4.pdf"),
  @("01_documentos", "docs/m57-affidavit-warrant-final.pdf",      "m57-affidavit-warrant-final.pdf"),
  @("02_usb",        "drives-redacted/jo-favorites-usb-2009-12-11.E01", "jo-favorites-usb-2009-12-11.E01"),
  @("02_usb",        "drives-redacted/jo-work-usb-2009-12-11.E01",      "jo-work-usb-2009-12-11.E01"),
  @("02_usb",        "drives-redacted/terry-work-usb-2009-12-11.E01",   "terry-work-usb-2009-12-11.E01"),
  @("03_discos",     "drives-redacted/jo-2009-11-20-oldComputer.E01",   "jo-2009-11-20-oldComputer.E01"),
  @("03_discos",     "drives-redacted/pat-2009-12-11.E01",              "pat-2009-12-11.E01"),
  @("03_discos",     "drives-redacted/terry-2009-12-11-001.E01",        "terry-2009-12-11-001.E01"),
  @("04_red",        "net/net-2009-11-20-10%3A30.pcap.gz",              "net-2009-11-20-1030.pcap.gz"),
  @("04_red",        "net/net-2009-11-23-16%3A54.pcap.gz",              "net-2009-11-23-1654.pcap.gz")
)

New-Item -ItemType Directory -Force -Path $raiz | Out-Null
foreach ($d in "01_documentos","02_usb","03_discos","04_red","05_capturas","06_caso_autopsy") {
  New-Item -ItemType Directory -Force -Path (Join-Path $raiz $d) | Out-Null
}

foreach ($a in $archivos) {
  $destino = Join-Path (Join-Path $raiz $a[0]) $a[2]
  Write-Host "`n>>> Descargando $($a[2]) ..." -ForegroundColor Cyan
  # curl.exe viene con Windows 10/11; -C - reanuda descargas cortadas
  curl.exe -L --retry 5 -C - -o "$destino" "$base/$($a[1])"
}

Write-Host "`nCalculando hashes MD5 (cadena de custodia)..." -ForegroundColor Cyan
Get-ChildItem -Recurse -File $raiz -Include *.E01,*.gz |
  Get-FileHash -Algorithm MD5 |
  Select-Object Hash, @{n='Archivo';e={Split-Path $_.Path -Leaf}} |
  Format-Table -AutoSize | Out-String -Width 200 |
  Tee-Object -FilePath (Join-Path $raiz "hashes_md5_descarga.txt")

Write-Host "`nLISTO. Carpeta: $raiz" -ForegroundColor Green
