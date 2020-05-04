# SimuMate
第一原理計算用．
## Docker
イメージがDocker Hubの`naokicpp/simu_mate:latest`にある．
Dockerがインストールされていれば以下でpullできる．
```shell
docker pull naokicpp/simu_mate:latest
```
自分のフォルダと同期させてdocker runすると便利．
```
docker run -it --rm --name sample -v /Your/Workspace:/mnt/volume naokicpp/simu_mate:latest
```
## 入っているもの
- Quantum Espresso．buildした時点での最新版が入る．
- Atomic Simulation Environment．これもbuildした時点での最新版が入る．
