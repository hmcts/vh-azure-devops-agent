Describe "azcopy" {
    It "azcopy" {
        "azcopy --version" | Should -ReturnZeroExitCode
    }

    It "azcopy10 link exists" {
        "azcopy10 --version" | Should -ReturnZeroExitCode
    }
}

Describe "Docker" {
    It "docker" {
        "docker --version" | Should -ReturnZeroExitCode
    }

    It "docker buildx" {
        "docker buildx" | Should -ReturnZeroExitCode
    }

    It "docker compose v2" {
        "docker compose" | Should -ReturnZeroExitCode
    }

    It "docker-credential-ecr-login" {
        "docker-credential-ecr-login -v" | Should -ReturnZeroExitCode
    }

    Context "docker images" {
        $testCases = (Get-ToolsetContent).docker.images | ForEach-Object { @{ ImageName = $_ } }

        It "<ImageName>" -TestCases $testCases {
           sudo docker images "$ImageName" --format "{{.Repository}}" | Should -Not -BeNullOrEmpty
        }
    }
}

Describe "Docker-compose v1" {
    It "docker-compose" {
        "docker-compose --version"| Should -ReturnZeroExitCode
    }
}

Describe "MSSQLCommandLineTools" {
    It "sqlcmd" {
        "sqlcmd -?" | Should -ReturnZeroExitCode
    }
}

Describe "Terraform" {
    It "terraform" {
        "terraform --version" | Should -ReturnZeroExitCode
    }
}

Describe "Git" {
    It "git" {
        "git --version" | Should -ReturnZeroExitCode
    }

    It "git-lfs" {
        "git-lfs --version" | Should -ReturnZeroExitCode
    }

    It "git-ftp" {
        "git-ftp --version" | Should -ReturnZeroExitCode
    }

    It "hub-cli" {
        "hub --version" | Should -ReturnZeroExitCode
    }
}

Describe "Kubernetes tools" {
    It "kind" {
        "kind --version" | Should -ReturnZeroExitCode
    }

    It "kubectl" {
        "kubectl version" | Should -MatchCommandOutput "Client Version: version.Info"
    }

    It "helm" {
        "helm version" | Should -ReturnZeroExitCode
    }

    It "minikube" {
        "minikube version" | Should -ReturnZeroExitCode
    }

    It "kustomize" {
        "kustomize version" | Should -ReturnZeroExitCode
    }
}

Describe "Packer" {
    It "packer" {
        "packer --version" | Should -ReturnZeroExitCode
    }
}

Describe "yq" {
    It "yq" {
        "yq -V" | Should -ReturnZeroExitCode
    }
}

Describe "Mono" {
    It "mono" {
        "mono --version" | Should -ReturnZeroExitCode
    }

    It "msbuild" {
        "msbuild -version" | Should -ReturnZeroExitCode
    }

    It "nuget" {
        "nuget" | Should -ReturnZeroExitCode
    }
}