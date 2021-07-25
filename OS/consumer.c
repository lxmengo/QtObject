/*consumer.c*/

#include <stdio.h>
#include <sys/mman.h>
#include <semaphore.h>
#include <fcntl.h>
#include <unistd.h>
#define DATA_NUMBER 10 //共享内存大小

int main()
{                          
	sem_t *semaph_lock, *semaph_n, *semaph_e;//互斥信号量，产品数量的信号量，空闲空间数量的信号量
	char *data;
    int shmem_fd;//文件描述符
    int j = 0;//共享内存位置
    
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
        sem_wait(semaph_n); //若有产品数量，则可继续运行
        sem_wait(semaph_lock);//加锁
        printf("Output: %c\n", data[j]);//消费，打印
        sem_post(semaph_lock);//解锁
        sem_post(semaph_e); //空闲空间加1
        
        if(j < DATA_NUMBER - 1){
            j++;
        } else {
            j = 0;
        }//如果共享内存位置超过最大数量，则把该位置重置为0，否则位置加1
    }
    
	return 0;
}
