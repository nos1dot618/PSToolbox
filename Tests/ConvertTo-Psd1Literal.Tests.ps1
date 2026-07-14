BeforeAll {
    . "$PSScriptRoot/../Public/ConvertTo-Psd1Literal.ps1"
}

Describe "ConvertTo-Psd1Literal" {

    Context "Primitive values" {

        It "Rejects null" {
            { ConvertTo-Psd1Literal $null } | Should -Throw
        }

        It "Converts true" {
            ConvertTo-Psd1Literal $true | Should -Be '$true'
        }

        It "Converts false" {
            ConvertTo-Psd1Literal $false | Should -Be '$false'
        }

        It "Quotes strings" {
            ConvertTo-Psd1Literal "hello" | Should -Be '"hello"'
        }

        It "Converts numbers" {
            ConvertTo-Psd1Literal 42 | Should -Be '42'
        }
    }

    Context "Arrays" {

        It "Converts string arrays" {
            ConvertTo-Psd1Literal @("a", "b", "c") |
            Should -Be '@("a", "b", "c")'
        }

        It "Converts integer arrays" {
            ConvertTo-Psd1Literal @(1, 2, 3) |
            Should -Be '@(1, 2, 3)'
        }

        It "Converts nested arrays" {
            ConvertTo-Psd1Literal @(@(1, 2), @(3, 4)) |
            Should -Be '@(@(1, 2), @(3, 4))'
        }
    }

    Context "Hashtable" {

        It "Converts a simple hashtable" {
            $result = ConvertTo-Psd1Literal @{
                Name    = "Demo"
                Enabled = $true
            }

            $result | Should -Match 'Name\s*=\s*"Demo"'
            $result | Should -Match 'Enabled\s*=\s*\$true'
            $result | Should -Match '^@\{'
            $result | Should -Match '\}$'
        }

        It "Converts nested hashtables" {
            $result = ConvertTo-Psd1Literal @{
                Outer = @{
                    Value = 1
                }
            }

            $result | Should -Match 'Outer\s*='
            $result | Should -Match 'Value\s*=\s*1'
        }
    }

    Context "PSCustomObject" {

        It "Converts PSCustomObject" {
            $obj = [pscustomobject]@{
                Name = "John"
                Age  = 25
            }

            $result = ConvertTo-Psd1Literal $obj

            $result | Should -Match '^@\{'
            $result | Should -Match 'Name\s*=\s*"John"'
            $result | Should -Match 'Age\s*=\s*25'
        }

        It "Converts nested PSCustomObjects" {
            $obj = [pscustomobject]@{
                Child = [pscustomobject]@{
                    Name = "Nested"
                }
            }

            $result = ConvertTo-Psd1Literal $obj

            $result | Should -Match 'Child\s*='
            $result | Should -Match 'Name\s*=\s*"Nested"'
        }
    }

    Context "Mixed objects" {

        It "Converts complex nested structures" {

            $obj = @{
                Name   = "Demo"
                Tags   = @("PowerShell", "PSD1")
                Config = @{
                    Enabled = $true
                    Retry   = 3
                }
            }

            $result = ConvertTo-Psd1Literal $obj

            $result | Should -Match 'Name\s*=\s*"Demo"'
            $result | Should -Match 'Tags\s*='
            $result | Should -Match 'Enabled\s*=\s*\$true'
            $result | Should -Match 'Retry\s*=\s*3'
        }
    }
}
