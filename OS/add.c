#include <stdio.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <semaphore.h>
#include <fcntl.h>
#include <string.h>
#include <signal.h>
#include <unistd.h>
#include <sys/types.h>
#include <time.h>
#define BUFF_SIZE 4

void *ptr = NULL;

int main()
{
	int i, j;
	double num[4][25000]; //浮点数组
	double sum[4]; //每个子进程相加和
	double parent_sums; //父进程和
	double sums; //共享内存中读取的值和
	double readSum[4]; //保存每个读取值
	pid_t pid;
    sem_t *semaph_lock, *semaph_count, *semaph_remainder;
    sem_t *semaph_firstpro;			//用于判断第一个生产者
    int shmem_fd, ret, p_offset;
    double *double_ptr=NULL;
	int	*rdwr_ptr=NULL;

        
	semaph_lock = sem_open("lock", O_CREAT, 0666, 1);   //用于访问缓冲区互斥
	semaph_count = sem_open("count", O_CREAT, 0666, 0); //缓冲区中已有数据计数
    semaph_remainder = sem_open("remainder", O_CREAT, 0666, BUFF_SIZE);  //缓冲区剩余空间计数
    shmem_fd = shm_open("data_buffer", O_RDWR | O_CREAT, 0666); //创建共享内存用于数据缓冲区及其指针
    semaph_firstpro = sem_open("firstpro", O_CREAT, 0666, 1);		//用于判断第一个生产者，一个生产者初始化读写指针
	
    if(shmem_fd==-1){
		printf("create shared memory failed\n");
		exit(1);}
				
	ret = ftruncate(shmem_fd, sizeof(double)*4 + sizeof(int)*2); //调整共享内存大小，BUFF_SIZE个字符+1个读指针+1个写指针
	if(ret == -1){
		printf("ftruncate failed\n");
		exit(1);}
		
	ptr = mmap(NULL, sizeof(double)*4 + sizeof(int)*2, PROT_READ | PROT_WRITE, MAP_SHARED, shmem_fd, 0); //映射到进程的地址空间
    
    if(ptr == NULL){
		printf("mmap failed\n");
		exit(1);
    }
		
    double_ptr = (double*)ptr;
	rdwr_ptr = (int*)(double_ptr+BUFF_SIZE);
    
    sem_wait(semaph_lock);
		if(sem_trywait(semaph_firstpro) == 0){		//第一个生产者初始化读写指针
			rdwr_ptr[0] = 0;		//读指针初始化为0
			rdwr_ptr[1] = 0;}		//写指针初始化为0
	sem_post(semaph_lock);

	srand((unsigned)time(NULL));

	for(i=0; i<4; i++){
		for(j=0; j<25000; j++){
			num[i][j] = rand() % 10000 / 10000.0;
			parent_sums += num[i][j];
		}
	}

	for(i=0; i<4; i++){
		pid = fork();
		if(pid < 0){
			printf("fork error!");
			exit(1);
		}else if(pid == 0){
			for(j=0; j<25000; j++){
                sum[i] += num[i][j]; 
            }
            sem_wait(semaph_remainder); //检测缓冲区是否有剩余空间
            sem_wait(semaph_lock);//加锁
                p_offset = rdwr_ptr[1];
				double_ptr[p_offset] = sum[i];
				rdwr_ptr[1] = (p_offset+1)%BUFF_SIZE;
            sem_post(semaph_lock);//解锁
            sem_post(semaph_count);
			printf("(%d) Child_%d sum: %f\n", getpid(), i+1, sum[i]);
			exit(0); //正常运行退出子进程
		}else{
            sem_wait(semaph_count);//检测缓冲区是否有剩余空间
            sem_wait(semaph_lock);//加锁
                p_offset = rdwr_ptr[0];
                readSum[i] = double_ptr[p_offset];
                rdwr_ptr[0] = (p_offset+1)%BUFF_SIZE;
            sem_post(semaph_lock);//解锁
            sem_post(semaph_remainder);
        }
	}

	for(i=0; i<4; i++){
		sums += readSum[i];		//将从共享内存中读出的值累加到sums中
	}

	printf("(%d) Parent direct sum: %f, sum from children: %f\n", getpid(), parent_sums, sums);

	return 0;
}
