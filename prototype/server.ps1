# Guardian Angel local prototype server (no deps, stdlib .NET only).
# Serves prototype/index.html + tiny in-memory JSON API on http://localhost:8081/
# No auth, no database, nothing leaves the machine.

$port = 8081
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$index = Join-Path $root 'index.html'

$state = @{
  monitoring = $true
  medsTaken  = $false
  events     = New-Object System.Collections.ArrayList
}
function Now-Stamp { (Get-Date).ToString('HH:mm:ss') }

$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:$port/")
try { $listener.Start() } catch {
  Write-Host "Port $port unavailable: $($_.Exception.Message)"; exit 1
}
Write-Host "Guardian Angel prototype running at http://localhost:$port/ (Ctrl+C to stop)"

function Send-Json($ctx, $obj) {
  $json = $obj | ConvertTo-Json -Depth 5
  $bytes = [Text.Encoding]::UTF8.GetBytes($json)
  $ctx.Response.ContentType = 'application/json'
  $ctx.Response.ContentLength64 = $bytes.Length
  $ctx.Response.OutputStream.Write($bytes, 0, $bytes.Length)
  $ctx.Response.OutputStream.Close()
}
function Send-Html($ctx, $path) {
  $bytes = [IO.File]::ReadAllBytes($path)
  $ctx.Response.ContentType = 'text/html; charset=utf-8'
  $ctx.Response.ContentLength64 = $bytes.Length
  $ctx.Response.OutputStream.Write($bytes, 0, $bytes.Length)
  $ctx.Response.OutputStream.Close()
}
function Read-Body($ctx) {
  try {
    $r = New-Object IO.StreamReader($ctx.Request.InputStream)
    $t = $r.ReadToEnd(); $r.Close()
    if ($t) { return $t | ConvertFrom-Json } else { return $null }
  } catch { return $null }
}

while ($listener.IsListening) {
  try {
    $ctx = $listener.GetContext()
    $method = $ctx.Request.HttpMethod
    $path = $ctx.Request.Url.AbsolutePath
    if ($method -eq 'GET' -and ($path -eq '/' -or $path -eq '/index.html')) {
      Send-Html $ctx $index
    } elseif ($method -eq 'GET' -and $path -eq '/api/status') {
      Send-Json $ctx @{
        monitoring = $state.monitoring
        medsTaken  = $state.medsTaken
        lastActive = Now-Stamp
        events     = @($state.events | Select-Object -Last 50)
      }
    } elseif ($method -eq 'POST' -and $path -eq '/api/monitoring') {
      $b = Read-Body $ctx
      if ($b -ne $null -and $b.PSObject.Properties['on']) { $state.monitoring = [bool]$b.on }
      [void]$state.events.Add(@{ time = Now-Stamp; kind = 'monitoring'; label = 'Monitoring ' + ($(if ($state.monitoring) { 'ON' } else { 'OFF' })) })
      Send-Json $ctx @{ ok = $true; monitoring = $state.monitoring }
    } elseif ($method -eq 'POST' -and $path -eq '/api/event') {
      $b = Read-Body $ctx
      $kind = 'note'; $label = 'Event'
      if ($b -ne $null) {
        if ($b.PSObject.Properties['kind']) { $kind = [string]$b.kind }
        if ($b.PSObject.Properties['label']) { $label = [string]$b.label }
      }
      [void]$state.events.Add(@{ time = Now-Stamp; kind = $kind; label = $label })
      Send-Json $ctx @{ ok = $true }
    } elseif ($method -eq 'POST' -and $path -eq '/api/meds') {
      $state.medsTaken = $true
      [void]$state.events.Add(@{ time = Now-Stamp; kind = 'meds'; label = 'Medication marked taken' })
      Send-Json $ctx @{ ok = $true }
    } else {
      $ctx.Response.StatusCode = 404
      Send-Json $ctx @{ error = 'not found' }
    }
  } catch { try { $_.Exception.Message | Out-Null } catch {} }
}
