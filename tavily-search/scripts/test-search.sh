#!/bin/bash

# Tavily 搜索测试脚本

echo "🧪 Tavily 搜索技能测试"
echo "======================"

# 检查环境变量
if [ -z "$TAVILY_API_KEY" ]; then
    echo "❌ 错误: TAVILY_API_KEY 环境变量未设置"
    echo ""
    echo "请先设置 API 密钥:"
    echo "  export TAVILY_API_KEY=\"your_api_key_here\""
    echo ""
    echo "或者将密钥添加到 ~/.bashrc 或 ~/.zshrc:"
    echo "  echo 'export TAVILY_API_KEY=\"your_api_key_here\"' >> ~/.zshrc"
    echo "  source ~/.zshrc"
    exit 1
fi

echo "✅ API 密钥已设置: ${TAVILY_API_KEY:0:8}..."

# 测试搜索脚本
echo ""
echo "1. 测试简单搜索..."
./search.sh "人工智能最新发展"

echo ""
echo "2. 测试带答案的搜索..."
./search.sh --answer "什么是机器学习"

echo ""
echo "3. 测试限制结果的搜索..."
./search.sh --max-results 2 "气候变化"

echo ""
echo "4. 测试时间范围搜索..."
./search.sh --time-range week "科技新闻"

echo ""
echo "✅ 测试完成！"
echo ""
echo "使用示例:"
echo "  ./search.sh \"今天天气如何\""
echo "  ./search.sh --answer --max-results 5 \"比特币价格\""
echo "  ./search.sh --depth advanced --time-range month \"电动汽车市场\""

echo ""
echo "获取 Tavily API 密钥: https://tavily.com"