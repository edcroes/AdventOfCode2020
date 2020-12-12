<#
.SYNOPSIS
Creates a bool matrix from a string array.

.PARAMETER Lines
The string array that should be converted.

.PARAMETER TrueValue
The character that indicates a true value.

.OUTPUTS
A two-dimensional bool array.
#>
function ConvertTo-BoolMatrix
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [string[]] $Lines,

        [Parameter(Mandatory)]
        [char] $TrueValue
    )

    $map = [bool[][]]::new($Lines.Length)

    for ($lineNumber = 0; $lineNumber -lt $Lines.Length; $lineNumber++)
    {
        $mapLine = $Lines[$lineNumber].ToCharArray() | ForEach-Object { $_ -eq $TrueValue }
        $map[$lineNumber] = $mapLine
    }

    return $map
}

<#
.SYNOPSIS
Creates a char matrix from a string array.

.PARAMETER Lines
The string array that should be converted.

.OUTPUTS
A two-dimensional char array.
#>
function ConvertTo-CharMatrix
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [string[]] $Lines
    )

    $map = [char[][]]::new($Lines.Length)

    for ($lineNumber = 0; $lineNumber -lt $Lines.Length; $lineNumber++)
    {
        $map[$lineNumber] = $Lines[$lineNumber].ToCharArray()
    }

    return $map
}