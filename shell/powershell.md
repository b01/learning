# PowerShell

## Set a environment variable that sticks after a power-cycle:

Here we can set a user account variable for ourselves quickly without going
through the UI.

```shell
[Environment]::SetEnvironmentVariable("AWS_PROFILE", "you-aws-profile-here", "User")
```

## Base64 Encode String

To quickly base64 encode a string you have.

1. Define the string to encode.
   `$StringToEncode = "This is a test string for Base64 encoding."`

2. Convert the string to bytes using Unicode encoding (common for PowerShell),
   or UTF-8.
   ```shell
   $Bytes = [System.Text.Encoding]::Unicode.GetBytes($StringtoEncode)
   # or
   $Bytes = [System.Text.Encoding]::UTF8.GetBytes($StringtoEncode)
   ```

3. Encode the bytes to a Base64 string
   `$EncodedString = [System.Convert]::ToBase64String($Bytes)`

4. Output the encoded string
   ```powershell
   Write-Host "Original String: $StringtoEncode"
   Write-Host "Base64 Encoded String: $EncodedString"
   ```

```powershell
function Base64-PrintEncodedString() {
    param (
        [string]$StringToEncode
    )
    $Bytes = [System.Text.Encoding]::Unicode.GetBytes($StringtoEncode)
    $Bytes = [System.Text.Encoding]::UTF8.GetBytes($StringtoEncode)
    $EncodedString = [System.Convert]::ToBase64String($Bytes)
    Write-Host "${EncodedString}`n"
}
```