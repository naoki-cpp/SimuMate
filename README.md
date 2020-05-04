# SimuMate
第一原理計算用．
## Docker
イメージがDocker Hubの`naokicpp/simu_mate:latest`にある．
Dockerがインストールされていれば以下でpullできる．
```shell
docker pull naokicpp/simu_mate:latest
```
自分のフォルダと同期させてdocker runすると便利．2つ目のボリュームマウントでは
ホストとディスプレイの共有を行っている（参考：[dockerコンテナの中でguiアプリケーションを起動させる](https://unskilled.site/docker%E3%82%B3%E3%83%B3%E3%83%86%E3%83%8A%E3%81%AE%E4%B8%AD%E3%81%A7gui%E3%82%A2%E3%83%97%E3%83%AA%E3%82%B1%E3%83%BC%E3%82%B7%E3%83%A7%E3%83%B3%E3%82%92%E8%B5%B7%E5%8B%95%E3%81%95%E3%81%9B%E3%82%8B/)）．
```
docker run -it --rm -e DISPLAY=$DISPLAY -v /Your/Workspace:/mnt/volume -v /tmp/.X11-unix/:/tmp/.X11-unix naokicpp/simu_mate:latest
```
この状態でホストの端末から，`docker ps`で起動しているコンテナのIDを調べ，
```
xhost +local:`docker inspect --format='{{.Config.Hostname}}' [コンテナのID]`
```
とするとGUIアプリケーションも使えるようになる．
## 入っているもの
- Quantum Espresso．buildした時点での最新版が入る．
- Atomic Simulation Environment．これもbuildした時点での最新版が入る．
