# Tavily Search Skill for Clawdbot

一个用于 Clawdbot 的 Tavily AI 搜索技能，提供智能、实时的网络搜索功能。

## 🚀 功能特点

- **实时信息搜索**：获取最新的网络信息
- **AI 生成答案**：包含智能摘要和答案
- **结构化结果**：JSON 格式的搜索结果
- **多种搜索选项**：时间范围、结果数量、搜索深度等
- **易于集成**：简单的命令行接口

## 📋 先决条件

### 1. Tavily API 密钥
- 访问 [Tavily 官网](https://tavily.com) 注册账号
- 获取 API 密钥
- 设置环境变量：
  ```bash
  export TAVILY_API_KEY="your_api_key_here"
  ```

### 2. 必需工具
- `curl` - HTTP 客户端
- `jq` - JSON 处理器

## 🛠️ 安装

### 方法1：复制到 Clawdbot 技能目录
```bash
cp -r tavily-search /Users/chengmoutao/.nvm/versions/node/v24.13.0/lib/node_modules/openclaw-cn/skills/
```

### 方法2：使用 ClawdHub（如果可用）
```bash
clawdhub install tavily-search
```

## 🎯 使用方法

### 基本搜索
```bash
# 设置 API 密钥
export TAVILY_API_KEY="your_key"

# 执行搜索
./scripts/search.sh "搜索查询"
```

### 带选项的搜索
```bash
# 包含 AI 答案
./scripts/search.sh --answer "什么是量子计算"

# 限制结果数量
./scripts/search.sh --max-results 5 "人工智能"

# 指定时间范围
./scripts/search.sh --time-range week "最新新闻"

# 高级搜索
./scripts/search.sh --depth advanced --answer --max-results 3 "机器学习应用"
```

### 在 Clawdbot 中使用
```bash
# 通过 exec 工具调用
exec ./scripts/search.sh "今天比特币价格"
```

## 📁 文件结构

```
tavily-search/
├── SKILL.md              # 技能主文档
├── README.md            # 说明文件
└── scripts/
    ├── search.sh        # 主搜索脚本
    └── test-search.sh   # 测试脚本
```

## 🔧 脚本参数

| 参数 | 简写 | 说明 | 默认值 |
|------|------|------|--------|
| `--help` | `-h` | 显示帮助信息 | - |
| `--max-results` | `-n` | 最大结果数量 | 3 |
| `--depth` | `-d` | 搜索深度：basic/advanced | advanced |
| `--answer` | `-a` | 包含 AI 答案 | false |
| `--images` | `-i` | 包含图片 | false |
| `--raw` | `-r` | 包含原始内容 | false |
| `--time-range` | `-t` | 时间范围：day/week/month/year | - |

## 📊 输出格式

搜索脚本返回格式化的结果，包括：
- 搜索查询
- AI 生成的答案（如果启用）
- 搜索结果列表（标题、URL、摘要）
- 原始内容预览（如果启用）
- 相关图片（如果启用）
- 响应时间

## 🧪 测试

运行测试脚本验证安装：
```bash
cd tavily-search/scripts
./test-search.sh
```

## ⚠️ 注意事项

1. **API 限制**：Tavily API 有使用限制，请遵守服务条款
2. **网络要求**：需要稳定的网络连接
3. **错误处理**：脚本包含基本的错误处理
4. **安全性**：不要将 API 密钥提交到版本控制系统

## 🔄 更新日志

### v1.0.0 (2026-02-09)
- 初始版本发布
- 基本搜索功能
- 支持多种搜索选项
- 格式化输出

## 📚 资源

- [Tavily 官方网站](https://tavily.com)
- [Tavily API 文档](https://docs.tavily.com)
- [Clawdbot 文档](https://docs.clawd.bot)

## 🤝 贡献

欢迎提交问题和拉取请求！

## 📄 许可证

MIT License