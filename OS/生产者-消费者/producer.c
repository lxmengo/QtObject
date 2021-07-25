#include <stdio.h>
#include <stdlib.h>
#include <sys/mman.h>   //共享内存
#include <semaphore.h>  //信号量
#include <fcntl.h>      //O_* 宏定义
#include <signal.h>
#include <unistd.h>

#define BUFF_SIZE 10
void sigint_handler(int arg);
void *ptr=NULL;

int main()
{
	sem_t *semaph_lock, *semaph_count, *semaph_remainder;
	sem_t *semaph_firstpro;			//用于判断第一个生产者
	int shmem_fd, ret, i, p_offset, sem_val;
	char str[256];
	char *str_ptr=NULL;
	int	*rdwr_ptr=NULL;
	
	semaph_lock = sem_open("lock", O_CREAT, 0666, 1);   //用于访问缓冲区互斥
	semaph_count = sem_open("count", O_CREAT, 0666, 0); //缓冲区中已有数据计数
	semaph_remainder = sem_open("remainder", O_CREAT, 0666, BUFF_SIZE);  //缓冲区剩余空间计数
	semaph_firstpro = sem_open("firstpro", O_CREAT, 0666, 1);		//用于判断第一个生产者，一个生产者初始化读写指针
	
	shmem_fd = shm_open("data_buffer", O_RDWR | O_CREAT, 0666); //创建共享内存用于数据缓冲区及其指针
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

	sem_wait(semaph_lock);
		if(sem_trywait(semaph_firstpro) == 0){		//第一个生产者初始化读写指针
			rdwr_ptr[0] = 0;		//读指针初始化为0
			rdwr_ptr[1] = 0;}		//写指针初始化为0
	sem_post(semaph_lock);
	
	signal(SIGINT, sigint_handler);
	while(1)
	{
		printf("(PRODUCER)input a string:\n");
		fgets(str, 255, stdin);
		i = 0;
		while(str[i] != '\0'){
			sem_wait(semaph_remainder);  //检测缓冲区是否有剩余空间
			sem_wait(semaph_lock);  //开始写缓冲区(临界区加锁）
				p_offset = rdwr_ptr[1];
				str_ptr[p_offset] = str[i];
				rdwr_ptr[1] = (p_offset+1)%BUFF_SIZE;
				i++;
			sem_post(semaph_lock);  //临界区解锁
			sem_post(semaph_count);}
	}
} 

void sigint_handler(int arg)
{
	munmap(ptr, sizeof(double)*4+sizeof(int)*2); //解除地址映射
	shm_unlink("data_buffer");  //删除共享内存
	/*删除信号量*/	
	sem_unlink("lock");
	sem_unlink("count");
	sem_unlink("remainder");
	
	printf("\r\n");
	
	exit(0);
}
