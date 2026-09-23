Describe 'Get-Fibonacci' {
    BeforeAll {
        . (Join-Path $PSScriptRoot 'math-tool.ps1')
    }

    It 'returns only the numeric Fibonacci value for <N>' -ForEach @(
        @{ N = 0; Expected = 0L }
        @{ N = 1; Expected = 1L }
        @{ N = 7; Expected = 13L }
        @{ N = 93; Expected = [bigint]'12200160415121876738' }
    ) {
        $result = @(Get-Fibonacci -N $N)

        $result.Count | Should -Be 1
        $result[0] | Should -BeOfType [bigint]
        $result[0] | Should -Be $Expected
    }
}

Describe 'Get-Factorial' {
    BeforeAll {
        . (Join-Path $PSScriptRoot 'math-tool.ps1')
    }

    It 'returns only the numeric factorial value for <N>' -ForEach @(
        @{ N = 0; Expected = 1L }
        @{ N = 1; Expected = 1L }
        @{ N = 5; Expected = 120L }
        @{ N = 20; Expected = [bigint]'2432902008176640000' }
    ) {
        $result = @(Get-Factorial -N $N)

        $result.Count | Should -Be 1
        $result[0] | Should -BeOfType [bigint]
        $result[0] | Should -Be $Expected
    }
}

Describe 'math-tool CLI' {
    It 'writes exactly one Fibonacci result line for <N>' -ForEach @(
        @{ N = 0; Expected = 0L }
        @{ N = 1; Expected = 1L }
        @{ N = 7; Expected = 13L }
        @{ N = 93; Expected = [bigint]'12200160415121876738' }
    ) {
        $implementationPath = Join-Path $PSScriptRoot 'math-tool.ps1'
        $output = @(& (Get-Command pwsh -ErrorAction Stop).Source -NoLogo -NoProfile -File $implementationPath -N $N 2>&1)

        $LASTEXITCODE | Should -Be 0
        $output.Count | Should -Be 1
        $output[0].ToString() | Should -Be "Fibonacci($N) = $Expected"
    }

    It 'requires N' {
        $implementationPath = Join-Path $PSScriptRoot 'math-tool.ps1'
        $output = @(& (Get-Command pwsh -ErrorAction Stop).Source -NoLogo -NoProfile -NonInteractive -File $implementationPath 2>&1)

        $LASTEXITCODE | Should -Not -Be 0
        ($output | Out-String) | Should -Match 'The -N parameter is required'
    }

    It 'writes exactly one <Operation> result line for <N>' -ForEach @(
        @{ Operation = 'fibonacci'; N = 0; Expected = 'Fibonacci(0) = 0' }
        @{ Operation = 'fibonacci'; N = 7; Expected = 'Fibonacci(7) = 13' }
        @{ Operation = 'factorial'; N = 0; Expected = 'Factorial(0) = 1' }
        @{ Operation = 'factorial'; N = 1; Expected = 'Factorial(1) = 1' }
        @{ Operation = 'factorial'; N = 5; Expected = 'Factorial(5) = 120' }
    ) {
        $implementationPath = Join-Path $PSScriptRoot 'math-tool.ps1'
        $output = @(& (Get-Command pwsh -ErrorAction Stop).Source -NoLogo -NoProfile -File $implementationPath -N $N -Operation $Operation 2>&1)

        $LASTEXITCODE | Should -Be 0
        $output.Count | Should -Be 1
        $output[0].ToString() | Should -Be $Expected
    }

    It 'dispatches the same N to different results per operation' {
        $implementationPath = Join-Path $PSScriptRoot 'math-tool.ps1'
        $pwshPath = (Get-Command pwsh -ErrorAction Stop).Source

        $fibonacci = @(& $pwshPath -NoLogo -NoProfile -File $implementationPath -N 6 -Operation fibonacci 2>&1)
        $factorial = @(& $pwshPath -NoLogo -NoProfile -File $implementationPath -N 6 -Operation factorial 2>&1)

        $fibonacci.Count | Should -Be 1
        $factorial.Count | Should -Be 1
        $fibonacci[0].ToString() | Should -Be 'Fibonacci(6) = 8'
        $factorial[0].ToString() | Should -Be 'Factorial(6) = 720'
    }

    It 'rejects an unknown operation' {
        $implementationPath = Join-Path $PSScriptRoot 'math-tool.ps1'
        $output = @(& (Get-Command pwsh -ErrorAction Stop).Source -NoLogo -NoProfile -NonInteractive -File $implementationPath -N 5 -Operation cube 2>&1)

        $LASTEXITCODE | Should -Not -Be 0
        ($output | Out-String) | Should -Match 'Operation'
    }
}
