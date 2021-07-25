#include <stdio.h>
#include <stdlib.h>
#include <sys/mman.h>   //共享内存
#include <semaphore.h>  //信号量
#include <fcntl.h>      //O_* 宏定义
#include <unistd.h>
#include <string.h>

#define BUFF_SIZE 10

int main()
{
	sem_t *semaph_lock, *semaph_count, *semaph_remainder, *semaph_profirst;
	int shmem_fd, ret, i, p_offset;
	void *ptr=NULL;
	char *str_ptr=NULL;
	int	*rdwr_ptr=NULL;
	
	semaph_lock = sem_open("lock", O_CREAT, 0666, 1);   //用于访问缓冲区互斥
	semaph_count = sem_open("count", O_CREAT, 0666, 0); //缓冲区中已有数据计数
	semaph_remainder = sem_open("remainder", O_CREAT, 0666, BUFF_SIZE);  //缓冲区剩余空间计数
		
	
	shmem_fd = shm_open("data_buffer", O_RDWR | O_CREAT, 0666); //打开共享内存
	if(shmem_fd==-1){
		printf("create shared memory failed\n");
		exit(1);}
				
	ret = ftruncate(shmem_fd, sizeof(char)*BUFF_SIZE+sizeof(int)*2); //调整共享内存大小，BUFF_SIZE个字符+1个读指针+1个写指针
	if(ret == -1){
		printf("ftruncate failed\n");
		exit(1);}
		
	ptr = mmap(NULL, sizeof(char)*BUFF_SIZE+sizeof(int)*2, PROT_READ | PROT_WRITE, MAP_SHARED, shmem_fd, 0); //映射到进程的地址空间
	if(ptr == NULL){
		printf("mmap failed\n");
		exit(1);}
	
	str_ptr = (char*)ptr;
	rdwr_ptr = (int*)(str_ptr+BUFF_SIZE);

	while(1)
	{
		sem_wait(semaph_count);
		sem_wait(semaph_lock);  //开始读缓冲区(临界区加锁）
			p_offset = rdwr_ptr[0];
			if(str_ptr[p_offset] != '\n')
				printf("CONSUMER:%c \n", str_ptr[p_offset]);
			else
				printf("\n");
			rdwr_ptr[0] = (p_offset+1)%BUFF_SIZE;
		sem_post(semaph_lock);  //临界区解锁
		sem_post(semaph_remainder);
	}
}
