[CmdletBinding()]
param(
    [ValidateRange(0, [int]::MaxValue)]
    [int]$N
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

if ($MyInvocation.InvocationName -eq '.') {
    # Avoid CLI output when tests dot-source this script for Get-Fibonacci.
    return
}

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if (-not $PSBoundParameters.ContainsKey('N')) {
    throw 'The -N parameter is required. Example: ./math-tool.ps1 -N 10'
}

Write-Output "Fibonacci($N) = $(Get-Fibonacci -N $N)"
