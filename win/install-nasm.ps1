$version = $args[0]
$arch = $args[1]
$zip = "nasm-$version-$arch.zip"
$name = "nasm-$arch"
if (![System.IO.File]::Exists("$name.zip")) {
  "Downloading $name..."
  Invoke-WebRequest "https://nasm.us/pub/nasm/releasebuilds/$version/$arch/$zip" -OutFile "$name.zip"
}
if (![System.IO.File]::Exists("$name.zip")) {
  Write-Output "Download of $zip failed."
}
if (!(Test-Path -Path "$name" -PathType Container)) {
  "Installing $name..."
  Expand-Archive -Path "$name.zip" -DestinationPath "."
  Rename-Item -Path "nasm-$version" -NewName "$name"
}
