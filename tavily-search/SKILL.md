---
name: tavily-search
description: 使用 Tavily AI 搜索 API 进行智能网络搜索。当需要获取实时信息、进行事实核查或增强 AI 的实时知识时使用。
metadata: {"clawdbot":{"requires":{"bins":["curl","jq"]},"install":[{"id":"tavily","kind":"api_key","service":"Tavily","url":"https://tavily.com","label":"获取 Tavily API 密钥"}]}}
---

# Tavily Search Skill

使用 Tavily AI 搜索 API 进行智能、实时的网络搜索。

## 先决条件

1. **Tavily API 密钥**：
   - 访问 https://tavily.com 注册并获取 API 密钥
   - 设置环境变量：`export TAVILY_API_KEY=your_api_key`

2. **必需工具**：
   - `curl` - HTTP 客户端
   - `jq` - JSON 处理器

## 基本用法

### 简单搜索
```bash
# 设置 API 密钥
export TAVILY_API_KEY="your_api_key_here"

# 执行搜索
curl -s -X POST "https://api.tavily.com/search" \
  -H "Content-Type: application/json" \
  -d '{
    "api_key": "'"$TAVILY_API_KEY"'",
    "query": "今天比特币价格",
    "search_depth": "basic",
    "include_answer": true,
    "include_images": false,
    "include_raw_content": false
  }' | jq .
```

### 带参数的搜索
```bash
curl -s -X POST "https://api.tavily.com/search" \
  -H "Content-Type: application/json" \
  -d '{
    "api_key": "'"$TAVILY_API_KEY"'",
    "query": "OpenAI 最新发布",
    "search_depth": "advanced",
    "max_results": 5,
    "include_answer": true,
    "include_images": true,
    "include_raw_content": true,
    "time_range": "month"
  }' | jq .
```

## API 参数说明

### 查询参数
- `query` (必需): 搜索查询字符串
- `api_key` (必需): Tavily API 密钥
- `search_depth`: "basic" 或 "advanced"（默认: "basic"）
- `max_results`: 返回结果数量（1-10，默认: 5）
- `include_answer`: 是否包含 AI 生成的答案（布尔值）
- `include_images`: 是否包含图片（布尔值）
- `include_raw_content`: 是否包含原始内容（布尔值）
- `time_range`: 时间范围："day", "week", "month", "year"

### 响应格式
```json
{
  "query": "搜索查询",
  "answer": "AI 生成的答案（如果 include_answer 为 true）",
  "results": [
    {
      "title": "结果标题",
      "url": "URL",
      "content": "内容摘要",
      "score": "相关性分数",
      "raw_content": "原始内容（如果 include_raw_content 为 true）"
    }
  ],
  "response_time": "响应时间",
  "images": ["图片 URL 数组（如果 include_images 为 true）"]
}
```

## 使用场景

### 1. 实时信息查询
```bash
# 获取实时价格
query="今天比特币价格多少"

# 获取最新新闻
query="人工智能领域最新突破"
```

### 2. 事实核查
```bash
# 验证信息准确性
query="验证：地球是平的吗？"

# 查找权威来源
query="COVID-19 疫苗有效性研究"
```

### 3. 研究和分析
```bash
# 市场研究
query="2024年电动汽车市场趋势"

# 竞争对手分析
query="特斯拉竞争对手分析"
```

### 4. 内容增强
```bash
# 为文章收集资料
query="气候变化最新数据"

# 获取统计数据
query="全球互联网用户数量 2024"
```

## 示例脚本

### 搜索并提取答案
```bash
#!/bin/bash

# 配置
TAVILY_API_KEY="${TAVILY_API_KEY}"
QUERY="$1"

if [ -z "$TAVILY_API_KEY" ]; then
  echo "错误: 请设置 TAVILY_API_KEY 环境变量"
  exit 1
fi

if [ -z "$QUERY" ]; then
  echo "用法: $0 \"搜索查询\""
  exit 1
fi

# 执行搜索
RESPONSE=$(curl -s -X POST "https://api.tavily.com/search" \
  -H "Content-Type: application/json" \
  -d '{
    "api_key": "'"$TAVILY_API_KEY"'",
    "query": "'"$QUERY"'",
    "search_depth": "advanced",
    "include_answer": true,
    "max_results": 3
  }')

# 提取答案
ANSWER=$(echo "$RESPONSE" | jq -r '.answer // "未找到答案"')
echo "答案: $ANSWER"

# 显示结果
echo ""
echo "搜索结果:"
echo "$RESPONSE" | jq -r '.results[] | "• \(.title)\n  \(.url)\n  \(.content)\n"'
```

### 批量搜索
```bash
#!/bin/bash

# 批量搜索多个查询
QUERIES=(
  "今天天气如何"
  "最新科技新闻"
  "股票市场表现"
)

for query in "${QUERIES[@]}"; do
  echo "搜索: $query"
  curl -s -X POST "https://api.tavily.com/search" \
    -H "Content-Type: application/json" \
    -d '{
      "api_key": "'"$TAVILY_API_KEY"'",
      "query": "'"$query"'",
      "search_depth": "basic",
      "include_answer": true
    }' | jq -r '.answer // "无答案"'
  echo "---"
done
```

## 最佳实践

### 1. 查询优化
- 使用具体、明确的关键词
- 避免模糊或过于宽泛的查询
- 包含时间范围限制（如需要最新信息）

### 2. 错误处理
```bash
# 检查 API 响应
response=$(curl -s -X POST ...)
if echo "$response" | jq -e '.error' >/dev/null 2>&1; then
  echo "API 错误: $(echo "$response" | jq -r '.error')"
  exit 1
fi
```

### 3. 速率限制
- Tavily API 有速率限制
- 避免频繁请求
- 考虑缓存结果

### 4. 结果验证
- 交叉验证重要信息
- 检查来源的权威性
- 注意信息时效性

## 集成到 Clawdbot

在 Clawdbot 中使用时：
1. 确保已设置 `TAVILY_API_KEY` 环境变量
2. 使用 `exec` 工具调用搜索脚本
3. 解析并格式化结果供用户查看

## 故障排除

### 常见问题
1. **API 密钥无效**：检查密钥是否正确，是否已激活
2. **速率限制**：等待一段时间后重试
3. **网络问题**：检查网络连接和防火墙设置
4. **JSON 解析错误**：确保安装了 `jq` 工具

### 调试命令
```bash
# 测试 API 连接
curl -v -X POST "https://api.tavily.com/search" \
  -H "Content-Type: application/json" \
  -d '{"api_key": "test", "query": "test"}'

# 检查环境变量
echo "API 密钥: ${TAVILY_API_KEY:0:10}..."
```

## 资源
- [Tavily 官方网站](https://tavily.com)
- [API 文档](https://docs.tavily.com)
- [定价信息](https://tavily.com/pricing)

---

**注意**: 使用 Tavily API 需要遵守其服务条款和用量限制。