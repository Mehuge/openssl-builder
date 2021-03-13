$version = $args[0]
$source = "openssl-$version.tar.gz"
$name = "openssl"
if (![System.IO.File]::Exists("$name.tar.gz")) {
  "Downloading $name..."
  Invoke-WebRequest "https://www.openssl.org/source/$source" -OutFile "$name.tar.gz"
}
if (![System.IO.File]::Exists("$name.tar.gz")) {
  Write-Output "Download of $source failed."
}
