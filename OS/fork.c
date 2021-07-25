#include <stdio.h>
#include <unistd.h>
#include <sys/types.h>

int main(){
	pid_t CID1, CID2;

	CID1 = fork();

	if(CID1 < 0) perror("fork error!"); //fork失败，输出错误信息
	else if(CID1 == 0){//前一个子进程
		printf("(%d) I am Child. My parent id is %d.\n", getpid(), getppid());
	} else {
		CID2 = fork();
        if(CID2 < 0) perror("fork error!");
        else if(CID2 == 0){ //后一个子进程
            printf("(%d) I am Child. My parent id is %d.\n", getpid(), getppid());
        } else {
            printf("(%d) I am parent. My children are %d, %d.\n", getpid(), CID1, CID2);
		}	
	}

	return 0;
}
