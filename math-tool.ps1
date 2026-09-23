[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [ValidateRange(0, [int]::MaxValue)]
    [int]$N
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Get-Fibonacci {
    [CmdletBinding()]
    param(
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
    return
}

Write-Output "Fibonacci($N) = $(Get-Fibonacci -N $N)"
