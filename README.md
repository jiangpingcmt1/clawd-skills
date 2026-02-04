# Custom Agent Skills Backup

This repository contains a backup of custom Agent Skills used in Moltbot.

## Skills Included

- `backtesting-frameworks` - Robust trading strategy backtesting
- `brainstorming` - Creative idea exploration and design
- `ddgr` - DuckDuckGo command-line search
- `quant-analyst` - Quantitative finance and algorithmic trading
- `research` - AI-synthesized research with citations
- `searxng-search` - Local SearXNG enhanced search

## Setup

These skills are normally located in `/home/admin/.agents/skills/` and linked to `/home/admin/.clawdbot/skills/`.

To restore:
```bash
cp -r /path/to/this/repo/* /home/admin/.agents/skills/
```

## License

Custom skills may have their own licenses. Check individual skill directories for details.