# Домашнее задание к занятию «Управляющие конструкции в коде Terraform»

### Цели задания

1. Отработать основные принципы и методы работы с управляющими конструкциями Terraform.
2. Освоить работу с шаблонизатором Terraform (Interpolation Syntax).

------

### Чек-лист готовности к домашнему заданию

1. Зарегистрирован аккаунт в Yandex Cloud. Использован промокод на грант.
2. Установлен инструмент Yandex CLI.
3. Доступен исходный код для выполнения задания в директории [**03/src**](https://github.com/netology-code/ter-homeworks/tree/main/03/src).
4. Любые ВМ, использованные при выполнении задания, должны быть прерываемыми, для экономии средств.

------

### Внимание!! Обязательно предоставляем на проверку получившийся код в виде ссылки на ваш github-репозиторий!
Убедитесь что ваша версия **Terraform** ~>1.8.4
Теперь пишем красивый код, хардкод значения не допустимы!
------

### Задание 1

1. Изучите проект.
2. Инициализируйте проект, выполните код. 


Приложите скриншот входящих правил «Группы безопасности» в ЛК Yandex Cloud . \
![1.1.png](https://github.com/Liberaty/ter_hw_3/blob/main/img/1.1.png?raw=true)
------

### Задание 2

1. Создайте файл count-vm.tf. Опишите в нём создание двух **одинаковых** ВМ  web-1 и web-2 (не web-0 и web-1) с минимальными параметрами, используя мета-аргумент **count loop**. Назначьте ВМ созданную в первом задании группу безопасности.(как это сделать узнайте в документации провайдера yandex/compute_instance )

***Ответ:*** Выполнено, вот [ссылка](https://github.com/Liberaty/ter_hw_3/blob/main/count-vm.tf) на файл.

А про группу безопасности security_group_ids:
![2.1.png](https://github.com/Liberaty/ter_hw_3/blob/main/img/2.1.png?raw=true)

2. Создайте файл for_each-vm.tf. Опишите в нём создание двух ВМ для баз данных с именами "main" и "replica" **разных** по cpu/ram/disk_volume , используя мета-аргумент **for_each loop**. Используйте для обеих ВМ одну общую переменную типа:
```
variable "each_vm" {
  type = list(object({  vm_name=string, cpu=number, ram=number, disk_volume=number }))
}
```  

***Ответ:*** Выполнено, вот [ссылка](https://github.com/Liberaty/ter_hw_3/blob/main/for_each-vm.tf) на файл.

3. При желании внесите в переменную все возможные параметры.

***Ответ:*** Готово, внутри этого [файла](https://github.com/Liberaty/ter_hw_3/blob/main/variables.tf) находятся переменные для пунктов 2.1 и 2.2, и не только.

4. ВМ из пункта 2.1 должны создаваться после создания ВМ из пункта 2.2

***Ответ:*** Выполнено, показано на скриншоте ниже.
![2.4.png](https://github.com/Liberaty/ter_hw_3/blob/main/img/2.4.png?raw=true)

5. Используйте функцию file в local-переменной для считывания ключа ~/.ssh/id_rsa.pub и его последующего использования в блоке metadata, взятому из ДЗ 2.

***Ответ:*** Выполнено, показано на скриншоте ниже.
![2.5.png](https://github.com/Liberaty/ter_hw_3/blob/main/img/2.5.png?raw=true)

6. Инициализируйте проект, выполните код.

![2.6.png](https://github.com/Liberaty/ter_hw_3/blob/main/img/2.6.png?raw=true)

------

### Задание 3

1. Создайте 3 одинаковых виртуальных диска размером 1 Гб с помощью ресурса yandex_compute_disk и мета-аргумента count в файле **disk_vm.tf** .

***Ответ:*** Выполнено, вот [ссылка](https://github.com/Liberaty/ter_hw_3/blob/main/disk_vm.tf) на файл.

2. Создайте в том же файле **одиночную**(использовать count или for_each запрещено из-за задания №4) ВМ c именем "storage". Используйте блок **dynamic secondary_disk{..}** и мета-аргумент for_each для подключения созданных вами дополнительных дисков.

![3.2.1.png](https://github.com/Liberaty/ter_hw_3/blob/main/img/3.2.1.png?raw=true)

![3.2.1.png](https://github.com/Liberaty/ter_hw_3/blob/main/img/3.2.2.png?raw=true)
------

### Задание 4

1. В файле ansible.tf создайте inventory-файл для ansible.
Используйте функцию tepmplatefile и файл-шаблон для создания ansible inventory-файла из лекции.
Готовый код возьмите из демонстрации к лекции [**demonstration2**](https://github.com/netology-code/ter-homeworks/tree/main/03/demo).
Передайте в него в качестве переменных группы виртуальных машин из задания 2.1, 2.2 и 3.2, т. е. 5 ВМ.

***Ответ:*** Выполнено, вот ссылки на [ansible.tf](https://github.com/Liberaty/ter_hw_3/blob/main/ansible.tf) и [inventory.tftpl](https://github.com/Liberaty/ter_hw_3/blob/main/inventory.tftpl)

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
Пример fqdn: ```web1.ru-central1.internal```(в случае указания переменной hostname(не путать с переменной name)); \
```fhm8k1oojmm5lie8i22a.auto.internal```(в случае отсутвия перменной hostname - автоматическая генерация имени,  зона изменяется на auto). нужную вам переменную найдите в документации провайдера или terraform console.
4. Выполните код. Приложите скриншот получившегося [файла](https://github.com/Liberaty/ter_hw_3/blob/main/ansible_inventory.ini). 
![4.4.png](https://github.com/Liberaty/ter_hw_3/blob/main/img/4.4.png?raw=true)

Для общего зачёта создайте в вашем GitHub-репозитории новую ветку terraform-03. Закоммитьте в эту ветку свой финальный код проекта, пришлите ссылку на коммит.   
**Удалите все созданные ресурсы**.

------

## Дополнительные задания (со звездочкой*)

### Задание 6* (необязательное)

1. Используя null_resource и local-exec, примените ansible-playbook к ВМ из ansible inventory-файла.
Готовый код возьмите из демонстрации к лекции [**demonstration2**](https://github.com/netology-code/ter-homeworks/tree/main/03/demo).
3. Модифицируйте файл-шаблон hosts.tftpl. Необходимо отредактировать переменную ```ansible_host="<внешний IP-address или внутренний IP-address если у ВМ отсутвует внешний адрес>```.

Для проверки работы уберите у ВМ внешние адреса(nat=false). Этот вариант используется при работе через bastion-сервер.
Для зачёта предоставьте код вместе с основной частью задания.

***Ответ:*** Выполнено, вот [playbook.yaml](https://github.com/Liberaty/ter_hw_3/blob/main/playbook.yml)
![6.1.png](https://github.com/Liberaty/ter_hw_3/blob/main/img/6.1.png?raw=true)