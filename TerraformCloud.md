# Terraform Cloud
## Execution mode
### Remote
Terraform 실행환경 -> 테라폼 클라우드 <br>
Terraform 실행 시 클라우드의 테라폼 버전이 기준
- 구성 파일(.tf)과 Terraform Cloud의 Version이 다를경우
    - 구성 파일의 버전을 클라우드에 맞추거나
    - 클라드의 버전을 구성 파일에 맞추거나
- 로컬에 설치된(CLI) 테라폼 버전은 무시됨

### Local
Terraform 실행환경 -> 로컬 CLI <br>
로컬 환경(CLI, Shell)에 설치된 테라폼 버전이 기준
- 구성 파일(.tf)에 설정된 버전과 로컬에 설치된 테라폼의 버전이 일치해야함