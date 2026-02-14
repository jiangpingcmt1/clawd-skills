# Clawdbot Skills Sync Repository

## 同步信息
- **最后同步时间**: Sun Feb 15 02:00:12 CST 2026
- **技能数量**: 58
- **同步频率**: 每周自动同步
- **同步方向**: 双向（GitHub ↔ 本地）

## 包含的技能
- 1password
- apple-notes
- apple-reminders
- backtesting-frameworks
- bear-notes
- bird
- blogwatcher
- blucli
- bluebubbles
- brainstorming
- camsnap
- clawdhub
- coding-agent
- ddgr
- discord
- eightctl
- food-order
- gemini
- gifgrep
- github
- gog
- goplaces
- himalaya
- imsg
- local-places
- mcporter
- model-usage
- nano-banana-pro
- nano-pdf
- notion
- obsidian
- openai-image-gen
- openai-whisper
- openai-whisper-api
- openhue
- oracle
- ordercli
- peekaboo
- quant-analyst
- research
- sag
- searxng-search
- session-logs
- sherpa-onnx-tts
- skill-creator
- slack
- songsee
- sonoscli
- spotify-player
- summarize
- tavily-search
- things-mac
- tmux
- trello
- video-frames
- voice-call
- wacli
- weather

## 同步逻辑
1. **先拉取**：检查GitHub是否有新变更
2. **后更新**：如果有变更，先更新本地skill
3. **再备份**：将本地skill备份到GitHub

## 恢复说明
要恢复技能到本地：
```bash
# 先备份当前skill
cp -r /Users/chengmoutao/.nvm/versions/node/v24.13.0/lib/node_modules/openclaw-cn/skills /tmp/skills_backup

# 从GitHub恢复
cp -r /path/to/this/repo/* /Users/chengmoutao/.nvm/versions/node/v24.13.0/lib/node_modules/openclaw-cn/skills/
```

## 自动同步
此仓库由自动脚本每周同步一次。
