[CmdletBinding()]
param(
    [ValidateRange(0, [int]::MaxValue)]
    [int]$N,

    [ValidateSet('fibonacci', 'factorial')]
    [string]$Operation = 'fibonacci'
)

function Get-Fibonacci {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateRange(0, [int]::MaxValue)]
        [int]$N
    )

    [bigint]$previous = 0
    [bigint]$current = 1

    for ($index = 0; $index -lt $N; $index++) {
        [bigint]$next = $previous + $current
        $previous = $current
        $current = $next
    }

    return $previous
}

function Get-Factorial {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateRange(0, [int]::MaxValue)]
        [int]$N
    )

    [bigint]$product = 1

    for ($index = 2; $index -le $N; $index++) {
        $product = $product * $index
    }

    return $product
}

if ($MyInvocation.InvocationName -eq '.') {
    # Avoid CLI output when tests dot-source this script for the math functions.
    return
}

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if (-not $PSBoundParameters.ContainsKey('N')) {
    throw 'The -N parameter is required. Example: ./math-tool.ps1 -N 10'
}

Write-Output $(
    switch ($Operation) {
        'factorial' { "Factorial($N) = $(Get-Factorial -N $N)" }
        default { "Fibonacci($N) = $(Get-Fibonacci -N $N)" }
    }
)
