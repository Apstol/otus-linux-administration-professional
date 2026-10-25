# Занятие 5. Работа с NFS 

## Текст задания
- запустить 2 виртуальных машины (сервер NFS и клиента);
- на сервере NFS должна быть подготовлена и экспортирована директория;
- в экспортированной директории должна быть поддиректория с именем upload с правами на запись в неё;
- экспортированная директория должна автоматически монтироваться на клиенте при старте виртуальной машины (systemd, autofs или fstab — любым способом);
- монтирование и работа NFS на клиенте должна быть организована с использованием NFSv3.

## Задание со звездочкой*
- настроить аутентификацию через KERBEROS с использованием NFSv4

## Реализация

### Vagrantfile
```
Vagrant.configure("2") do |config|
  config.vm.define "ubuntu-vm-server" do |server|
    server.ssh.username = 'root'
    server.ssh.password = 'root'
    server.ssh.insert_key = 'true'

    server.vm.network "private_network", ip: "192.168.56.2"
    server.vm.box = "bento/ubuntu-24.04"
    server.vm.hostname = "ubuntu-vm-server"

    server.vm.provider "virtualbox" do |vb|
      vb.memory = "2048"
      vb.cpus = "2"
    end
  end

  config.vm.define "ubuntu-vm-client" do |client|
    client.ssh.username = 'root'
    client.ssh.password = 'root'
    client.ssh.insert_key = 'true'

    client.vm.network "private_network", ip: "192.168.56.3"
    client.vm.box = "bento/ubuntu-24.04"
    client.vm.hostname = "ubuntu-vm-client"

    client.vm.provider "virtualbox" do |vb|
      vb.memory = "2048"
      vb.cpus = "2"
    end
  end
end
```

### Схема
На картинке изображена схема реализации работы с NFS с аутентификацией через Kerberos:

<img width="828" height="720" alt="NFS+Kerberos Diagram drawio" src="https://github.com/user-attachments/assets/74e6df73-50b8-443a-a34f-dcf2f1741326" />

### Демо
На видео демонстрируется работа клиента с аутентификацией через Kerberos. Пользователь vagrant на клиенте входит в группу nfs (gid=1001) для возможности редактирования файлов на NFS.

https://github.com/user-attachments/assets/86c3257c-fe38-4b24-85cd-0cf0115a0d0e




