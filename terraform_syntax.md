### 변수 우선 순위
1. cmd flag(-var, -var-file): Command line flag (run as a command line switch)
2. Configuration file(terraform.tfvars) (set in your terraform.tfvars file)
3. Environment variable(shell 환경변수) (part of your shell environment)
4. Default Config(variables.tf) (default value in variables.tf)
5. User manual entry(Prompt) (if not specified, prompt the user for entry)

### 버전 지시자 '~>'
가장 오른쪽 버전 구성 요소만 증가 예를들어, ~> 1.0.4는 1.0.5 및 1.0.10 설치를 허용하지만 1.1.0은 허용하지 않습니다.