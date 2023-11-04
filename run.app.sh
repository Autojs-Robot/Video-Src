ID=$(git rev-parse --short HEAD)
BRANCH=$(git rev-parse --abbrev-ref HEAD)
PJ=$(basename -s .git `git config --get remote.origin.url`)
PORT=20233

echo "构建项目： $PJ  启动端口： $PORT"
IMAGE=$(echo "$PJ-server-$BRANCH-$ID" | tr "[:upper:]" "[:lower:]")
echo "构建镜像名： $IMAGE"
NAME=$PJ-$BRANCH
echo "启动容器名： $NAME"

start(){
  images=$(docker images -q $IMAGE)  #检查是否构建成功
  APP_NAME="$NAME-$PORT"
  if [ $images ];then
    container=$(docker ps -a -f name=$APP_NAME -q)
    if [ $container ];then
      echo "删除旧容器"
      docker rm -f $container
    fi     #ifend
    echo "启动容器 $APP_NAME"
    docker run -p $PORT:3000 --name=$APP_NAME \
      -v /data/rclone/video:/data \
      --restart always \
      -d $IMAGE
  fi     #ifend
}

images=$(docker images -q $IMAGE)
if [ $images ];then
  echo "镜像已存在"
else
  echo "开始构建镜像"
  docker build -t $IMAGE . #构建镜像
fi     #ifend

start
