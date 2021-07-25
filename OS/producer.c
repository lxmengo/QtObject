/*producer.c*/

#include <stdio.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <semaphore.h>
#include <fcntl.h>
#include <unistd.h>
#include <string.h>
#include <signal.h>
#define DATA_NUMBER 10 //共享内存大小
#define MAXSIZE 100 //读入字符数组的最大大小

/*读入函数*/
void getInput(char *str);
/*清理函数*/
void clear_handler();

char *data;
    
int main()
{
    sem_t *semaph_lock, *semaph_n, *semaph_e; //互斥信号量，产品数量的信号量，空闲空间数量的信号量
    char str[MAXSIZE]; //最大读入字符数组
    int shmem_fd;  //文件描述符

    int i = 0, j = 0;//分别指代读入字符数组位置和共享内存位置
    signal(SIGINT, clear_handler); //捕捉control+c信号，并做出响应
    
    //创建或打开互斥信号量并赋值为1
    semaph_lock = sem_open("Lock", O_CREAT, 0666, 1);
    if(semaph_lock == SEM_FAILED) {
        perror("sem_open Error!");
    }
    
    //创建或打开产品数量的信号量并赋值为0
    semaph_n = sem_open("Number", O_CREAT, 0666, 0);
    if(semaph_n == SEM_FAILED) {
        perror("sem_open Error!");
    }
    
    //创建或打开空闲空间数量的信号量并赋值为DATA_NUMBER
    semaph_e = sem_open("Empty", O_CREAT, 0666, DATA_NUMBER);
    if(semaph_e == SEM_FAILED) {
        perror("sem_open Error!");
    }
    
    //创建或打开共享内存并返回文件描述符
	shmem_fd = shm_open("data_buffer", O_RDWR|O_CREAT, 0666);
    if(shmem_fd == -1) {
        perror("shm_open Error!");
    }
    
    //調整共享内存大小
    if(ftruncate(shmem_fd, sizeof(char)*DATA_NUMBER) < 0) {
        perror("ftruncate Error!");
    }
    
    //映射到地址空间
    data = mmap(NULL, sizeof(char)*DATA_NUMBER, PROT_WRITE|PROT_READ, MAP_SHARED, shmem_fd, 0);
    if(data == NULL) {
        perror("shm_open Error!");
    }
 
   while(1){
        getInput(str); //获取输入
        for(i = 0; i < strlen(str); i++){
            sem_wait(semaph_e);//若有空闲空间，则可继续运行
            sem_wait(semaph_lock);//加锁
            data[j] = str[i];//生产，把一个字符读入到共享内存中
            sem_post(semaph_lock);//解除
            sem_post(semaph_n);//产品数量加1
            
            if(j < DATA_NUMBER - 1) {
                j++;
            } else {
                j = 0;
            }//如果共享内存位置超过最大数量，则把该位置重置为0，否则位置加1
        }//for循环把读入的一个字符数组读取完，并读入到共享内存中
    }
    

	return 0;
}

/*读入函数*/
void getInput(char *str)
{
    printf("Input: \n");
    scanf("%s", str);
}

/*清理函数*/
void clear_handler()
{
    //删除信号量
    if (sem_unlink("Lock") == -1)
    {
        perror ("sem_unlink Error!");
    }
    if (sem_unlink("Number") == -1)
    {
        perror ("sem_unlink Error!");
    }
    if (sem_unlink("Empty") == -1)
    {
        perror ("sem_unlink Error!");
    }
    
    //解除地址映射
     if (munmap(data, sizeof(char)*10 + sizeof(int)*2) == -1)
     {
         perror ("munmap Error!");
     }
    
    //删除共享内存
    if (shm_unlink("data_buffer") == -1)
    {
        perror("shm_unlink Error!");
    }
    printf ("The producer was over!\n");
    
    exit(0);
}
