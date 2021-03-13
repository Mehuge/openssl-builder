$version = $args[0]
$zip = "strawberry-perl-$version-64bit-name.zip"
$name = "perl-portable"
if (![System.IO.File]::Exists("$name.zip")) {
  "Downloading $name..."
  Invoke-WebRequest "https://strawberryperl.com/download/$version/$zip" -OutFile "$name.zip"
}
if (![System.IO.File]::Exists("$name.zip")) {
  Write-Output "Download of $zip failed."
}
if (!(Test-Path -Path "$name" -PathType Container)) {
  "Installing $name..."
  Expand-Archive -Path "$name.zip"
}
