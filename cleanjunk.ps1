# === CLEAN APPDATA CACHES (RUN AS ADMIN) ===
$u    = $env:USERNAME
$root = "C:\Users\$u\AppData"

# (Opsional) tutup aplikasi yang sering ngunci file
"chrome","msedge","Discord","Telegram","WhatsApp","Teams","Microsoft.Teams" |
  ForEach-Object { Get-Process $_ -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue }

# Target folder/file patterns yang akan dibersihkan
$targets = @(
  "$root\Local\Temp\*",
  "$root\Local\CrashDumps\*",
  "$root\Local\Microsoft\Windows\INetCache\*",
  "$root\Local\Microsoft\Windows\Temporary Internet Files\*",

  "$root\Local\Google\Chrome\User Data\Default\Cache\*",
  "$root\Local\Google\Chrome\User Data\Default\Code Cache\*",
  "$root\Local\Microsoft\Edge\User Data\Default\Cache\*",
  "$root\Local\Microsoft\Edge\User Data\Default\Code Cache\*",

  "$root\Roaming\Microsoft\Teams\Cache\*",
  "$root\Roaming\Microsoft\Teams\Code Cache\*",
  "$root\Roaming\Microsoft\Teams\Service Worker\CacheStorage\*",

  "$root\Roaming\Discord\Cache\*",
  "$root\Roaming\Discord\Code Cache\*",
  "$root\Roaming\Discord\Service Worker\CacheStorage\*",

  "$root\Roaming\Telegram Desktop\Cache\*",
  "$root\Roaming\Telegram Desktop\tdata\emoji\*",

  "$root\Local\Packages\*\AC\Temp\*",
  "$root\Local\Packages\*\TempState\*"
)

function Get-Bytes($paths){
  $total = 0
  foreach($p in $paths){
    $items = Get-ChildItem $p -Recurse -File -Force -ErrorAction SilentlyContinue
    foreach($f in $items){ $total += $f.Length }
  }
  return $total
}

$before = Get-Bytes $targets

# Hapus isi target
foreach($t in $targets){
  Remove-Item $t -Recurse -Force -ErrorAction SilentlyContinue
}

# Pastikan Temp ada kembali
New-Item -ItemType Directory -Force -Path "$root\Local\Temp" | Out-Null

$after  = Get-Bytes $targets
$freed  = [math]::Round(($before - $after)/1GB,2)
Write-Host "Selesai. Perkiraan ruang dibebaskan: $freed GB"