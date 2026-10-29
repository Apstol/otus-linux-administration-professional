# Задание 6. Сборка RPM-пакета и создание репозитория

## Текст задания
- создать свой RPM (можно взять свое приложение, либо собрать к примеру Apache с определенными опциями);
- cоздать свой репозиторий и разместить там ранее собранный RPM;
- реализовать это все либо в Vagrant, либо развернуть у себя через Nginx и дать ссылку на репозиторий.

## Используемое окружение
Arch Linux -> VirtualBox -> openSUSE Tumbleweed 2026-10-27 (GNOME Desktop)

## Что сделано
Собран rpm пакет игры на C++ для дистрибутива openSUSE Tumbleweed. Пакет добавлен в локальный репозиторий.

## ~/rpmbuild/SPECS/match3.spec
```
Name:           match3
Version:        1.0.0
Release:        0
Summary:        A match-3 puzzle game built with C++ and SFML
License:        GPL-3.0-or-later
Group:          Amusements/Games/Board/Puzzle
URL:            https://apstol.ru/
Source0:        %{name}-%{version}.tar.gz
Source1:        %{name}.desktop
BuildRequires:  cmake
BuildRequires:  gcc-c++ >= 10
BuildRequires:  sfml3-devel
BuildRequires:  desktop-file-utils
BuildRequires:  update-desktop-files

%description
A simple match-3 puzzle game written in C++ using the SFML library.

%prep
%autosetup

%build
%cmake
%cmake_build

%install
%cmake_install

# Desktop entry
install -Dm 0644 %{SOURCE1} %{buildroot}%{_datadir}/applications/%{name}.desktop
%suse_update_desktop_file -r %{name} Game PuzzleGame

%fdupes -s %{buildroot}

%files
# %license LICENSE
# %doc README.md
%{_bindir}/%{name}
%{_datadir}/%{name}
%{_datadir}/applications/%{name}.desktop

%changelog
* Thu Oct 29 2026 Dmitry Tarabukin <dmitriitarabukin@mail.ru> - 1.0.0
- Initial package for match3
```

## ~/rpmbuild/SOURCES/match3.desktop
```
[Desktop Entry]
Type=Application
Name=Match 3
GenericName=Match-3 Puzzle Game
Comment=A simple match-3 puzzle game built with SFML
Exec=match3
Icon=match3
Terminal=false
Categories=Game;PuzzleGame;
Keywords=match;game;puzzle;
```

## Команды для сборки пакета
```
cd ~
wget https://gitlab.com/Apstol/match3/-/archive/v1.0.0/match3-v1.0.0.tar.gz
tar xf ~/match3-v1.0.0.tar.gz
cp -a ~/match3-v1.0.0 ~/match3-1.0.0
rm -rf ~/match3-1.0.0/.git ~/match3-1.0.0/.gitignore # and other unrelated files
tar czf ~/match3-1.0.0.tar.gz ~/match3-1.0.0
cp ~/match3-1.0.0.tar.gz ~/rpmbuild/SOURCES/
rpmbuild -ba ~/rpmbuild/SPECS/match3.spec
rpm -qlp ~/rpmbuild/RPMS/x86_64/match3-0.0.1-0.x86_64.rpm
```

## Команды для создания rpm репозитория и добавления в него пакета
```
mkdir ~/local-rpm-repo
cp ~/rpmbuild/RPMS/x86_64/match3-1.0.0-0.x86_64.rpm ~/local-rpm-repo
sudo zypper addrepo --refresh ~/local-rpm-repo LocalRepo
sudo zypper packages -r LocalRepo
sudo zypper install match3
```

## Демо
https://github.com/user-attachments/assets/ce084ead-8b0c-4af1-b67c-4977674e5457




