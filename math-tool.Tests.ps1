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
}
