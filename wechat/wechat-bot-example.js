#!/usr/bin/env node

/**
 * 微信机器人示例
 * 使用Wechaty框架
 */

const { WechatyBuilder } = require('wechaty');
const { PuppetWechat } = require('wechaty-puppet-wechat');

// 配置
const config = {
  puppet: new PuppetWechat(),
  name: 'clawdbot-wechat',
};

// 创建机器人
const bot = WechatyBuilder.build(config);

// 事件处理
bot.on('scan', (qrcode, status) => {
  console.log(`[${status}] 扫描二维码登录:`);
  console.log(`https://wechaty.js.org/qrcode/${encodeURIComponent(qrcode)}`);
  
  if (status === 2) {
    console.log('确认登录中...');
  }
});

bot.on('login', (user) => {
  console.log(`✅ 用户 ${user.name()} 已登录`);
  console.log(`用户ID: ${user.id}`);
});

bot.on('logout', (user, reason) => {
  console.log(`❌ 用户 ${user.name()} 已退出: ${reason}`);
});

bot.on('message', async (message) => {
  // 避免机器人回复自己
  if (message.self()) {
    return;
  }

  const text = message.text();
  const room = message.room();
  const talker = message.talker();
  
  console.log(`收到消息: ${text}`);
  console.log(`发送者: ${talker.name()}`);
  console.log(`群聊: ${room ? room.topic() : '私聊'}`);
  
  // 简单自动回复
  if (text.includes('帮助') || text.includes('help')) {
    await message.say('我是Clawdbot微信机器人，可以帮你：\n1. 查询信息\n2. 设置提醒\n3. 管理任务\n\n发送"功能"查看详细功能列表。');
  }
  
  if (text.includes('时间') || text.includes('time')) {
    const now = new Date();
    await message.say(`当前时间: ${now.toLocaleString('zh-CN')}`);
  }
  
  if (text.includes('天气') || text.includes('weather')) {
    await message.say('天气查询功能开发中...');
  }
});

bot.on('error', (error) => {
  console.error('机器人错误:', error);
});

// 启动机器人
async function main() {
  try {
    console.log('🚀 启动微信机器人...');
    await bot.start();
    console.log('✅ 微信机器人已启动');
    
    // 保持运行
    process.on('SIGINT', async () => {
      console.log('\n正在关闭机器人...');
      await bot.stop();
      console.log('机器人已关闭');
      process.exit(0);
    });
    
  } catch (error) {
    console.error('启动失败:', error);
    process.exit(1);
  }
}

// 命令行参数处理
if (process.argv.includes('--send')) {
  const to = process.argv[process.argv.indexOf('--send') + 1];
  const msg = process.argv[process.argv.indexOf('--send') + 2];
  
  if (!to || !msg) {
    console.error('用法: node wechat-bot-example.js --send "好友名称" "消息内容"');
    process.exit(1);
  }
  
  bot.start().then(async () => {
    const contact = await bot.Contact.find({ name: to });
    if (contact) {
      await contact.say(msg);
      console.log(`✅ 消息已发送给 ${to}`);
    } else {
      console.error(`❌ 未找到联系人: ${to}`);
    }
    await bot.stop();
  });
} else {
  main();
}