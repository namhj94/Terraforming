### Refresh
refresh는 configuration file에 의해 생성된 실제 리소스의 변경사항을 state file에 업데이트 합니다.
### import
import는 테라폼의 관리대상이 아닌 리소스를 state file로 불러옴, 사전에 configuration에 해당 리소스를 정의 해줘야 합니다.
```
terraform import <ADDR> <ID>
```

