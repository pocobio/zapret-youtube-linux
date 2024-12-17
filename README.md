# Способ обхода DPI на большинстве дистрибутивах Linux
#### Если у вас не работает, то можете поиграться с аргументами для nfqws
# Подготовка

## Клонируем репозиторий zapret и компилируем бинарник nfqws
```sh
git clone https://github.com/bol-van/zapret; cd zapret; make -j$(nproc)
```

#### Если все скомпилилось успешно, то копируем бинарник в `/usr/bin/`
```sh
sudo cp binaries/my/nfqws /usr/bin/; command -v nfqws
```
#### Если терминал выводит `/usr/bin/nfqws`, то у вас все успешно скопировалось

## Устанавливаем iptables
#### Для этого используйте ваш пакетный менеджер. Возьмем, к примеру, pacman
```sh
sudo pacman -S iptables
```
## Клонируем мой репозиторий и закидываем ip-листы и бинари
```sh
git clone https://github.com/avitoras/nfqwscfg; sudo mkdir /etc/zapret; sudo cp nfqwscfg/files/* /etc/zapret
```
#### После, если все прошло успешно, можете перекинуть скрипт `zapret.sh` туда, куда вам будет удобно
# Запуск
```sh
./zapret.sh
```
#### Либо же вот так, чтобы скрипт запустился в фоновом режиме
##### (лучше так не делайте, а то sudo может поломаться чутка)
```sh
nohup ./zapret.sh &
```





