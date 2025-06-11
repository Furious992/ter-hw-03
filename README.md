### Задание 1

1. Изучите проект.
2. Инициализируйте проект, выполните код. 


Приложите скриншот входящих правил «Группы безопасности» в ЛК Yandex Cloud .

------

### Решение 1

В подсети **develop** есть **Группы безопасности**. Там создана только одна группа — **example_dynamic**. В ней прописаны правила входящего (ingress) и исходящего (egress) трафика. Как выглядят ingress-правила, видно на скриншоте ниже.  
![img](https://github.com/Furious992/ter-hw-03/blob/main/6.png)  

Решение находится [тут](https://github.com/Furious992/ter-hw-03/blob/main/count-vm.tf)

------

### Задание 2

1. Создайте файл count-vm.tf. Опишите в нём создание двух **одинаковых** ВМ  web-1 и web-2 (не web-0 и web-1) с минимальными параметрами, используя мета-аргумент **count loop**. Назначьте ВМ созданную в первом задании группу безопасности.(как это сделать узнайте в документации провайдера yandex/compute_instance )
2. Создайте файл for_each-vm.tf. Опишите в нём создание двух ВМ для баз данных с именами "main" и "replica" **разных** по cpu/ram/disk_volume , используя мета-аргумент **for_each loop**. Используйте для обеих ВМ одну общую переменную типа:
```
variable "each_vm" {
  type = list(object({  vm_name=string, cpu=number, ram=number, disk_volume=number }))
}
```  
При желании внесите в переменную все возможные параметры.
4. ВМ из пункта 2.1 должны создаваться после создания ВМ из пункта 2.2.
5. Используйте функцию file в local-переменной для считывания ключа ~/.ssh/id_rsa.pub и его последующего использования в блоке metadata, взятому из ДЗ 2.
6. Инициализируйте проект, выполните код.

------

### Решение 2

![img](https://github.com/Furious992/ter-hw-03/blob/main/2.png)  

Решение находится [тут](https://github.com/Furious992/ter-hw-03/blob/main/for_each-vm.tf)

------

### Задание 3

1. Создайте 3 одинаковых виртуальных диска размером 1 Гб с помощью ресурса yandex_compute_disk и мета-аргумента count в файле **disk_vm.tf** .
2. Создайте в том же файле **одиночную**(использовать count или for_each запрещено из-за задания №4) ВМ c именем "storage"  . Используйте блок **dynamic secondary_disk{..}** и мета-аргумент for_each для подключения созданных вами дополнительных дисков.

------

# Решение 3

1. **terraform apply**:  
   ![img](https://github.com/Furious992/ter-hw-03/blob/main/3.png)  
2. VM:  
   ![img](https://github.com/Furious992/ter-hw-03/blob/main/4.png)  

Решение находится [тут](https://github.com/Furious992/ter-hw-03/blob/main/disk_vm.tf)

------

### Задание 4

1. В файле ansible.tf создайте inventory-файл для ansible.
Используйте функцию tepmplatefile и файл-шаблон для создания ansible inventory-файла из лекции.
Готовый код возьмите из демонстрации к лекции [**demonstration2**](https://github.com/netology-code/ter-homeworks/tree/main/03/demo).
Передайте в него в качестве переменных группы виртуальных машин из задания 2.1, 2.2 и 3.2, т. е. 5 ВМ.
2. Инвентарь должен содержать 3 группы и быть динамическим, т. е. обработать как группу из 2-х ВМ, так и 999 ВМ.
3. Добавьте в инвентарь переменную  [**fqdn**](https://cloud.yandex.ru/docs/compute/concepts/network#hostname).
``` 
[webservers]
web-1 ansible_host=<внешний ip-адрес> fqdn=<полное доменное имя виртуальной машины>
web-2 ansible_host=<внешний ip-адрес> fqdn=<полное доменное имя виртуальной машины>

[databases]
main ansible_host=<внешний ip-адрес> fqdn=<полное доменное имя виртуальной машины>
replica ansible_host<внешний ip-адрес> fqdn=<полное доменное имя виртуальной машины>

[storage]
storage ansible_host=<внешний ip-адрес> fqdn=<полное доменное имя виртуальной машины>
```
Пример fqdn: ```web1.ru-central1.internal```(в случае указания переменной hostname(не путать с переменной name)); ```fhm8k1oojmm5lie8i22a.auto.internal```(в случае отсутвия перменной hostname - автоматическая генерация имени,  зона изменяется на auto). нужную вам переменную найдите в документации провайдера или terraform console.
4. Выполните код. Приложите скриншот получившегося файла. 

Для общего зачёта создайте в вашем GitHub-репозитории новую ветку terraform-03. Закоммитьте в эту ветку свой финальный код проекта, пришлите ссылку на коммит.   
**Удалите все созданные ресурсы**.

------

# Решение 4

1. Для генерации inventory файла используем resource "local_file" с атрибутами filename и content

   > filename="${abspath(path.module)}/ansible/hosts.cfg"  
   > content= templatefile("${abspath(path.module)}/ansible/hosts.tftpl",{  
   >     webservers= [for i in yandex_compute_instance.web: i ]   
   >     databases=  [for k,v in yandex_compute_instance.database: v ]   
   >     storages= tolist( [yandex_compute_instance.storage])    
   >  })   
2. Атрибут content инициализируем значением функции templatefile  

![img](https://github.com/Furious992/ter-hw-03/blob/main/5.png) 


3. Решение находится [тут](https://github.com/Furious992/ter-hw-03/blob/main/ansible_inventory.ini)

   
**УДАЛИЛ ВСЕ СОЗДАННЫЕ РЕСУРСЫ**

------


