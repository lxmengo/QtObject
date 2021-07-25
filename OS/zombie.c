#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <unistd.h>
#include <signal.h>

int main()
{
    signal(SIGCHLD, SIG_IGN);
	pid_t pid;
	pid = fork();
	if(pid < 0)
	{
		printf("error fork\n");
		exit(1);
	}
	if(pid > 0)		//parent process
	{
		printf("Parent is: %d\n", getpid());
		while(1){}
	}
	else
	{
		printf("Child is: %d\n", getpid());
		exit(0);
	}	
}
