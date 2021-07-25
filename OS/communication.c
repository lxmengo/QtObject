#include <stdio.h>
#include <unistd.h>
#include <sys/types.h>
#include <stdlib.h>
#include <time.h>

int main()
{
	int i, j;
	double num[4][25000]; //浮点数组
	double sum[4]; //每个子进程相加和
	double parent_sums; //父进程和
	double sums; //管道中读取的值和
	double readSum[4]; //保存每个读取值
	pid_t pid;
	int fp[4][2];

	srand((unsigned)time(NULL));

	for(i=0; i<4; i++){
		for(j=0; j<25000; j++){
			num[i][j] = rand() % 10000 / 10000.0;
			parent_sums += num[i][j];
		}
	}

	for(i=0; i<4; i++){
		if(pipe(fp[i]) < 0){ //声明管道
			printf("pipe error!");
			exit(1);
		}

		pid = fork();
	
		if(pid < 0){
			printf("fork error!");
			exit(1);
		}else if(pid == 0){
			for(j=0; j<25000; j++)
				sum[i] += num[i][j]; 
			printf("(%d) Child_%d sum: %f\n", getpid(), i+1, sum[i]);
			write(fp[i][1], &sum[i],sizeof(double));	//子进程向管道中写入数据
			exit(0); //正常运行退出子进程
		}else{
			if(!read(fp[i][0], &readSum[i], sizeof(double))){ //父进程从管道中读取数据
				exit(1);
			}
		}
	}

	for(i=0; i<4; i++){
		sums += readSum[i];		//将从管道中读出的值累加到sums中
	}

	printf("(%d) Parent direct sum: %f, sum from children: %f\n", getpid(), parent_sums, sums);

	return 0;
}
