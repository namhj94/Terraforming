# Terraform Cloud
## Login to Terraform Cloud
### CLI Login
terraform login을 통해 로그인 할 경우 미리 생성한 User의 Token값을 입력해야 함<br>
입력된 Token값은 로컬 환경에 저장되며, 앞으로 사용되는 테라폼 커맨드를 위해 사용됨<br>
Path:  ~/.terraform.d/credentials.tfrc.json <br>
결국, 테라폼 로그인 후 테라폼 커맨드를 사용할 때마다 이 곳에 저장된 토큰을 사용해서 테라폼 클라우드를 컨트롤 할 수 있게됨

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
