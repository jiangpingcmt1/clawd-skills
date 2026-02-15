#!/bin/bash

# 微信技能安装脚本

set -e

echo "=== 安装微信技能 ==="
echo "时间: $(date)"

# 检查Node.js
if ! command -v node &> /dev/null; then
    echo "❌ Node.js未安装"
    echo "请先安装Node.js: https://nodejs.org/"
    exit 1
fi

echo "✅ Node.js版本: $(node --version)"

# 检查npm
if ! command -v npm &> /dev/null; then
    echo "❌ npm未安装"
    exit 1
fi

echo "✅ npm版本: $(npm --version)"

# 安装Wechaty依赖
echo "安装Wechaty依赖..."
npm install wechaty wechaty-puppet-wechat

if [ $? -eq 0 ]; then
    echo "✅ Wechaty依赖安装成功"
else
    echo "❌ Wechaty依赖安装失败"
    echo "尝试使用cnpm或yarn安装..."
    
    if command -v cnpm &> /dev/null; then
        cnpm install wechaty wechaty-puppet-wechat
    elif command -v yarn &> /dev/null; then
        yarn add wechaty wechaty-puppet-wechat
    else
        echo "请手动安装: npm install wechaty wechaty-puppet-wechat"
        exit 1
    fi
fi

# 创建配置文件
echo "创建配置文件..."
cat > wechat-config.json << EOF
{
  "bot": {
    "name": "clawdbot-wechat",
    "puppet": "wechaty-puppet-wechat"
  },
  "features": {
    "autoReply": true,
    "messageLog": true,
    "contactSync": true
  },
  "autoReply": {
    "keywords": {
      "帮助": "我是Clawdbot微信机器人，可以帮你处理各种任务！",
      "时间": "当前时间: {time}",
      "天气": "天气查询功能开发中...",
      "功能": "可用功能：\\n1. 信息查询\\n2. 提醒设置\\n3. 任务管理\\n4. 文件传输"
    }
  },
  "webhook": {
    "enabled": false,
    "url": "http://localhost:3000/webhook",
    "secret": "your_secret_here"
  }
}
EOF

echo "✅ 配置文件已创建: wechat-config.json"

# 设置执行权限
chmod +x wechat-bot-example.js

# 创建启动脚本
cat > start-wechat-bot.sh << 'EOF'
#!/bin/bash

# 微信机器人启动脚本

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "启动微信机器人..."
echo "按Ctrl+C停止"

# 检查依赖
if [ ! -d "node_modules" ]; then
    echo "未找到node_modules目录，正在安装依赖..."
    npm install
fi

# 启动机器人
node wechat-bot-example.js
EOF

chmod +x start-wechat-bot.sh

echo "✅ 启动脚本已创建: start-wechat-bot.sh"

# 创建发送消息脚本
cat > send-wechat-message.sh << 'EOF'
#!/bin/bash

# 发送微信消息脚本

if [ $# -lt 2 ]; then
    echo "用法: $0 \"好友名称\" \"消息内容\""
    echo "示例: $0 \"张三\" \"你好，这是测试消息\""
    exit 1
fi

CONTACT_NAME="$1"
MESSAGE="$2"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# 检查依赖
if [ ! -d "node_modules" ]; then
    echo "未找到node_modules目录，正在安装依赖..."
    npm install
fi

echo "发送消息给: $CONTACT_NAME"
echo "消息内容: $MESSAGE"

node wechat-bot-example.js --send "$CONTACT_NAME" "$MESSAGE"
EOF

chmod +x send-wechat-message.sh

echo "✅ 消息发送脚本已创建: send-wechat-message.sh"

# 创建Python版本（itchat）
cat > wechat-bot-python.py << 'EOF'
#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
微信机器人Python版本
使用itchat库
"""

import itchat
import time
from datetime import datetime

# 自动回复配置
AUTO_REPLY_CONFIG = {
    '帮助': '我是Clawdbot微信机器人，可以帮你处理各种任务！',
    '时间': lambda: f'当前时间: {datetime.now().strftime("%Y-%m-%d %H:%M:%S")}',
    '天气': '天气查询功能开发中...',
    '功能': '可用功能：\n1. 信息查询\n2. 提醒设置\n3. 任务管理\n4. 文件传输'
}

@itchat.msg_register(itchat.content.TEXT)
def text_reply(msg):
    """文本消息回复"""
    text = msg['Text']
    from_user = msg['User']['NickName'] if 'NickName' in msg['User'] else '未知用户'
    
    print(f'收到消息 [{from_user}]: {text}')
    
    # 检查是否匹配自动回复关键词
    for keyword, reply in AUTO_REPLY_CONFIG.items():
        if keyword in text:
            if callable(reply):
                return reply()
            else:
                return reply
    
    # 默认回复
    return '收到你的消息了！发送"帮助"查看可用功能。'

@itchat.msg_register(itchat.content.PICTURE)
def picture_reply(msg):
    """图片消息处理"""
    print('收到图片消息')
    return '收到图片！'

def send_message(to_user, message):
    """发送消息"""
    users = itchat.search_friends(name=to_user)
    if users:
        users[0].send(message)
        print(f'消息已发送给 {to_user}')
        return True
    else:
        print(f'未找到用户: {to_user}')
        return False

def main():
    """主函数"""
    print('🚀 启动微信机器人(Python版本)...')
    
    # 自动登录（热登录）
    itchat.auto_login(hotReload=True, enableCmdQR=2)
    
    print('✅ 登录成功！')
    print('开始监听消息...')
    
    # 保持运行
    itchat.run()

if __name__ == '__main__':
    import sys
    
    if len(sys.argv) > 2 and sys.argv[1] == '--send':
        # 发送消息模式
        to_user = sys.argv[2]
        message = sys.argv[3] if len(sys.argv) > 3 else '测试消息'
        
        itchat.auto_login(hotReload=True, enableCmdQR=2)
        send_message(to_user, message)
        itchat.logout()
    else:
        # 正常启动模式
        main()
EOF

echo "✅ Python版本已创建: wechat-bot-python.py"

echo ""
echo "=== 安装完成 ==="
echo ""
echo "使用说明:"
echo "1. 启动机器人: ./start-wechat-bot.sh"
echo "2. 发送消息: ./send-wechat-message.sh \"好友名称\" \"消息内容\""
echo "3. Python版本: python3 wechat-bot-python.py"
echo ""
echo "首次启动需要扫码登录微信"
echo "二维码会在终端显示，请使用微信扫码"