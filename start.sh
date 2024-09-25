#!/bin/bash

# 接收第一個參數
ENV_TYPE=$1

# Help
if [ "$ENV_TYPE" = "--help" ]; then
    echo "Usage: ./start.sh [ez100|indo|ph-jp|reports|vn|hk-indo] [rebuild]"
    echo "Usage: ./start.sh down [ez100|indo|ph-jp|reports|vn|hk-indo]"
    exit 1
fi

# 關閉容器
if [ "$ENV_TYPE" = "down" ]; then

    PROJECT=$2
        if [ "$PROJECT" = "ez100" ]; then
        command="docker compose --env-file ./.env.ez100 down"
    elif [ "$PROJECT" = "indo" ]; then
        command="docker compose --env-file ./.env.indo down"
    elif [ "$PROJECT" = "ph-jp" ]; then
        command="docker compose --env-file ./.env.ph.japan down"    
    elif [ "$PROJECT" = "reports" ]; then
        command="docker compose --env-file ./.env.reports down"
    elif [ "$PROJECT" = "vn" ]; then
        command="docker compose --env-file ./.env.vn down"
    elif [ "$PROJECT" = "hk-indo" ]; then
        command="docker compose --env-file ./.env.hk-indo down"
    else
        echo "錯誤：未知的專案類型。"
        exit 1
    fi
    eval "${command}"
    exit 1
fi

# 接收第二個參數
REBUILD=$2
# 根據參數執行相應的命令
if [ "$ENV_TYPE" = "ez100" ]; then
    echo "正在為 ez100 環境啟動容器..."
    command="docker compose --env-file ./.env.ez100 up -d redis mysql phpmyadmin nginx laravel-echo-server laravel-horizon"
elif [ "$ENV_TYPE" = "indo" ]; then
    echo "正在為 indo-money 環境啟動容器..."
    command="docker compose --env-file ./.env.indo up -d redis mysql phpmyadmin nginx mailpit"
elif [ "$ENV_TYPE" = "ph-jp" ]; then
    echo "正在為 ph-money-japan 環境啟動容器..."
    command="docker compose --env-file ./.env.ph.japan up -d redis mysql phpmyadmin nginx mailpit"
elif [ "$ENV_TYPE" = "reports" ]; then
    echo "正在為 reports 環境啟動容器..."
    command="docker compose --env-file ./.env.reports up -d redis mysql phpmyadmin nginx mailpit"
elif [ "$ENV_TYPE" = "vn" ]; then
    echo "正在為 vn 環境啟動容器..."
    command="docker compose --env-file ./.env.vn up -d redis mysql phpmyadmin nginx  mailpit"
elif [ "$ENV_TYPE" = "upup" ]; then
    echo "正在為 upup 環境啟動容器..."
    command="docker compose --env-file ./.env.ez100 up -d redis mysql phpmyadmin nginx php-worker"
elif [ "$ENV_TYPE" = "hk-indo" ]; then
    echo "正在為 hk-indo 環境啟動容器..."
    command="docker compose --env-file ./.env.hk-indo up -d redis mysql phpmyadmin nginx mailpit"
else
    echo "錯誤：未知的環境類型。"
    exit 1
fi

if [ "$REBUILD" = "rebuild" ]; then
    command="${command/up -d/up -d --build}"
fi

echo "執行 $command"
eval "${command}"

echo "所有容器已啟動完成"
