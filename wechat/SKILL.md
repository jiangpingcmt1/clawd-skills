---
name: wechat
description: 微信集成技能，通过微信API或第三方工具与微信交互。支持消息发送、接收、群聊管理等功能。
license: MIT
metadata:
  author: Clawdbot
  version: "1.0.0"
---

# 微信技能

通过微信API或第三方工具与微信进行交互。

## 功能

- 发送微信消息（个人和群聊）
- 接收微信消息（需要配置webhook）
- 管理微信联系人
- 群聊管理

## 安装依赖

### 方案1：使用Wechaty（推荐）

```bash
# 安装Wechaty
npm install wechaty wechaty-puppet-wechat

# 或者使用Docker
docker pull wechaty/wechaty
```

### 方案2：使用itchat（Python）

```bash
pip install itchat
```

### 方案3：使用微信官方API

需要申请企业微信或公众号API权限。

## 基本使用

### Wechaty示例

```javascript
// wechat-bot.js
const { WechatyBuilder } = require('wechaty')
const { PuppetWechat } = require('wechaty-puppet-wechat')

const bot = WechatyBuilder.build({
  puppet: new PuppetWechat(),
})

bot.on('scan', (qrcode, status) => {
  console.log(`Scan QR Code to login: ${status}\nhttps://wechaty.js.org/qrcode/${encodeURIComponent(qrcode)}`)
})

bot.on('login', (user) => {
  console.log(`User ${user} logged in`)
})

bot.on('message', async (message) => {
  console.log(`Message: ${message}`)
})

bot.start()
```

### itchat示例（Python）

```python
# wechat-bot.py
import itchat

@itchat.msg_register(itchat.content.TEXT)
def text_reply(msg):
    return f"收到消息: {msg['Text']}"

itchat.auto_login(hotReload=True)
itchat.run()
```

## 配置

### 环境变量

```bash
# Wechaty配置
export WECHATY_PUPPET=wechaty-puppet-wechat
export WECHATY_TOKEN=your_token_here

# 微信API配置（企业微信）
export WECHAT_CORP_ID=your_corp_id
export WECHAT_CORP_SECRET=your_corp_secret
export WECHAT_AGENT_ID=your_agent_id
```

### 配置文件

创建 `~/.wechat/config.json`:

```json
{
  "puppet": "wechaty-puppet-wechat",
  "token": "optional_token",
  "webhook": {
    "url": "https://your-server.com/webhook",
    "secret": "your_secret"
  }
}
```

## 常用命令

### 发送消息

```bash
# 使用Wechaty CLI
wechaty send --to "好友名称" --message "你好"

# 使用curl调用企业微信API
curl -X POST "https://qyapi.weixin.qq.com/cgi-bin/message/send?access_token=TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "touser": "USERID",
    "msgtype": "text",
    "agentid": AGENT_ID,
    "text": {
      "content": "消息内容"
    }
  }'
```

### 接收消息

配置webhook接收消息：

```bash
# 启动webhook服务器
node wechat-webhook.js
```

### 获取联系人列表

```bash
# Wechaty
wechaty contacts

# itchat
python -c "import itchat; itchat.auto_login(); print(itchat.get_friends())"
```

## 高级功能

### 群聊管理

```javascript
// 创建群聊
const room = await bot.Room.create(['好友1', '好友2', '好友3'], '群聊名称')

// 发送群消息
await room.say('群消息内容')

// 获取群成员
const members = await room.memberAll()
```

### 消息类型支持

- 文本消息
- 图片消息
- 文件消息
- 语音消息
- 视频消息
- 位置消息

### 自动回复

```javascript
bot.on('message', async (message) => {
  if (message.text().includes('帮助')) {
    await message.say('我是微信机器人，可以帮你处理各种任务！')
  }
  
  if (message.text().includes('时间')) {
    await message.say(`当前时间: ${new Date().toLocaleString()}`)
  }
})
```

## 安全注意事项

1. **不要存储敏感信息**：避免在代码中硬编码API密钥
2. **使用环境变量**：通过环境变量传递敏感配置
3. **限制权限**：只授予必要的最小权限
4. **定期更新**：保持依赖库更新到最新版本
5. **监控日志**：定期检查机器人运行日志

## 故障排除

### 常见问题

1. **登录失败**
   - 检查网络连接
   - 确认微信账号正常
   - 尝试重新扫码登录

2. **消息发送失败**
   - 检查接收方是否在联系人列表中
   - 确认消息内容符合微信规范
   - 检查API调用频率限制

3. **Webhook接收不到消息**
   - 确认webhook URL可公开访问
   - 检查防火墙设置
   - 验证签名和token

### 日志查看

```bash
# Wechaty日志
DEBUG=wechaty:* node bot.js

# itchat日志
itchat.auto_login(enableCmdQR=2, hotReload=True)
```

## 相关资源

- [Wechaty官方文档](https://wechaty.js.org/)
- [itchat GitHub](https://github.com/littlecodersh/ItChat)
- [企业微信API文档](https://work.weixin.qq.com/api/doc)
- [微信公众号开发文档](https://developers.weixin.qq.com/doc/)

## 许可证

MIT