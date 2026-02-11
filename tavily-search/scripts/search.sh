#!/bin/bash

# Tavily 搜索脚本
# 用法: ./search.sh "搜索查询"

set -e

# 配置
TAVILY_API_KEY="${TAVILY_API_KEY}"
API_URL="https://api.tavily.com/search"
DEFAULT_MAX_RESULTS=3
DEFAULT_SEARCH_DEPTH="advanced"

# 检查依赖
check_dependencies() {
    if ! command -v curl &> /dev/null; then
        echo "错误: 需要 curl 命令" >&2
        exit 1
    fi
    
    if ! command -v jq &> /dev/null; then
        echo "错误: 需要 jq 命令" >&2
        exit 1
    fi
}

# 检查 API 密钥
check_api_key() {
    if [ -z "$TAVILY_API_KEY" ]; then
        echo "错误: 请设置 TAVILY_API_KEY 环境变量" >&2
        echo "例如: export TAVILY_API_KEY=\"your_api_key_here\"" >&2
        exit 1
    fi
}

# 显示帮助
show_help() {
    cat << EOF
Tavily 搜索脚本

用法: $0 [选项] "搜索查询"

选项:
  -h, --help          显示此帮助信息
  -n, --max-results N 最大结果数量 (默认: $DEFAULT_MAX_RESULTS)
  -d, --depth TYPE    搜索深度: basic 或 advanced (默认: $DEFAULT_SEARCH_DEPTH)
  -a, --answer        包含 AI 生成的答案
  -i, --images        包含图片
  -r, --raw           包含原始内容
  -t, --time-range R  时间范围: day, week, month, year

示例:
  $0 "今天比特币价格"
  $0 -n 5 -a -t week "人工智能最新进展"
  $0 --max-results 3 --depth advanced --answer "气候变化数据"

环境变量:
  TAVILY_API_KEY      Tavily API 密钥 (必需)
EOF
}

# 解析参数
parse_args() {
    QUERY=""
    MAX_RESULTS=$DEFAULT_MAX_RESULTS
    SEARCH_DEPTH=$DEFAULT_SEARCH_DEPTH
    INCLUDE_ANSWER=false
    INCLUDE_IMAGES=false
    INCLUDE_RAW=false
    TIME_RANGE=""
    
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_help
                exit 0
                ;;
            -n|--max-results)
                MAX_RESULTS="$2"
                shift 2
                ;;
            -d|--depth)
                SEARCH_DEPTH="$2"
                shift 2
                ;;
            -a|--answer)
                INCLUDE_ANSWER=true
                shift
                ;;
            -i|--images)
                INCLUDE_IMAGES=true
                shift
                ;;
            -r|--raw)
                INCLUDE_RAW=true
                shift
                ;;
            -t|--time-range)
                TIME_RANGE="$2"
                shift 2
                ;;
            *)
                if [ -z "$QUERY" ]; then
                    QUERY="$1"
                else
                    echo "错误: 未知参数: $1" >&2
                    show_help
                    exit 1
                fi
                shift
                ;;
        esac
    done
    
    if [ -z "$QUERY" ]; then
        echo "错误: 需要搜索查询" >&2
        show_help
        exit 1
    fi
}

# 执行搜索
perform_search() {
    local query="$1"
    
    # 构建请求数据
    local request_data="{
        \"api_key\": \"$TAVILY_API_KEY\",
        \"query\": \"$query\",
        \"search_depth\": \"$SEARCH_DEPTH\",
        \"max_results\": $MAX_RESULTS,
        \"include_answer\": $INCLUDE_ANSWER,
        \"include_images\": $INCLUDE_IMAGES,
        \"include_raw_content\": $INCLUDE_RAW"
    
    # 添加时间范围（如果指定）
    if [ -n "$TIME_RANGE" ]; then
        request_data="$request_data,
        \"time_range\": \"$TIME_RANGE\""
    fi
    
    request_data="$request_data
    }"
    
    # 执行 API 请求
    local response
    response=$(curl -s -X POST "$API_URL" \
        -H "Content-Type: application/json" \
        -d "$request_data")
    
    # 检查错误
    if echo "$response" | jq -e '.error' >/dev/null 2>&1; then
        local error_msg
        error_msg=$(echo "$response" | jq -r '.error')
        echo "API 错误: $error_msg" >&2
        return 1
    fi
    
    echo "$response"
}

# 格式化输出
format_output() {
    local response="$1"
    
    echo "=" | tr "=" "-"
    echo "搜索查询: $(echo "$response" | jq -r '.query')"
    echo "=" | tr "=" "-"
    
    # 显示答案（如果有）
    local answer
    answer=$(echo "$response" | jq -r '.answer // empty')
    if [ -n "$answer" ] && [ "$answer" != "null" ]; then
        echo ""
        echo "📝 AI 答案:"
        echo "$answer"
    fi
    
    # 显示结果
    echo ""
    echo "🔍 搜索结果:"
    echo ""
    
    local results_count
    results_count=$(echo "$response" | jq '.results | length')
    
    if [ "$results_count" -eq 0 ]; then
        echo "未找到相关结果"
        return
    fi
    
    for i in $(seq 0 $((results_count - 1))); do
        echo "$((i + 1)). $(echo "$response" | jq -r ".results[$i].title")"
        echo "   链接: $(echo "$response" | jq -r ".results[$i].url")"
        echo "   摘要: $(echo "$response" | jq -r ".results[$i].content")"
        
        # 显示原始内容（如果存在且简短）
        local raw_content
        raw_content=$(echo "$response" | jq -r ".results[$i].raw_content // empty")
        if [ -n "$raw_content" ] && [ "$raw_content" != "null" ]; then
            local preview
            preview=$(echo "$raw_content" | head -3 | sed 's/^/      /')
            if [ -n "$preview" ]; then
                echo "   原始内容预览:"
                echo "$preview"
                if [ $(echo "$raw_content" | wc -l) -gt 3 ]; then
                    echo "     ... (更多内容)"
                fi
            fi
        fi
        
        echo ""
    done
    
    # 显示图片（如果有）
    local images_count
    images_count=$(echo "$response" | jq '.images | length // 0')
    if [ "$images_count" -gt 0 ]; then
        echo ""
        echo "🖼️ 相关图片 ($images_count 张):"
        for i in $(seq 0 $((images_count - 1))); do
            if [ $i -lt 3 ]; then  # 只显示前3张
                echo "   $(echo "$response" | jq -r ".images[$i]")"
            fi
        done
        if [ "$images_count" -gt 3 ]; then
            echo "   ... (还有 $((images_count - 3)) 张图片)"
        fi
    fi
    
    # 显示响应时间
    local response_time
    response_time=$(echo "$response" | jq -r '.response_time // empty')
    if [ -n "$response_time" ] && [ "$response_time" != "null" ]; then
        echo ""
        echo "⏱️ 响应时间: ${response_time}秒"
    fi
}

# 主函数
main() {
    check_dependencies
    parse_args "$@"
    check_api_key
    
    echo "正在搜索: \"$QUERY\"..."
    echo "搜索深度: $SEARCH_DEPTH, 最大结果: $MAX_RESULTS"
    if [ "$INCLUDE_ANSWER" = true ]; then
        echo "包含 AI 答案: 是"
    fi
    if [ -n "$TIME_RANGE" ]; then
        echo "时间范围: $TIME_RANGE"
    fi
    echo ""
    
    local response
    if response=$(perform_search "$QUERY"); then
        format_output "$response"
    else
        exit 1
    fi
}

# 运行主函数
main "$@"