# AIValueWorx Blog

> **Source in Obsidian (vault-shared). Build in Eleventy. Host on Cloudflare Pages.**

Public blog matching the [AIValueWorx landing page](https://landing-page-production-5e46.up.railway.app/) styling (Inter, IBM Plex Mono, `#5b8def` accent, glass panels). Content lives in **`vault-shared/published/blog/*.md`** — same workflow as [strategy-docs](https://github.com/aivalueworx/strategy-docs).

## Repositories

| Repo | Role |
|------|------|
| [`aivalueworx/vault-shared`](https://github.com/aivalueworx/vault-shared) | **Edit posts here** — `published/blog/*.md` |
| [`aivalueworx/blog`](https://github.com/aivalueworx/blog) | This repo — Eleventy template, CI, Cloudflare deploy |

## Local setup

```bash
git clone https://github.com/aivalueworx/vault-shared.git
git clone https://github.com/aivalueworx/blog.git
cd blog
npm install
./scripts/setup-local.sh ../vault-shared
npm run dev
# → http://localhost:8081
```

`setup-local.sh` symlinks `vault-shared/published/blog` → `src/posts/imported`. Layout defaults stay in `src/posts/posts.11tydata.js` (not inside the symlink).

## Writing posts

Create or edit `.md` files in **`vault-shared/published/blog/`** (open `vault-shared` as an Obsidian vault).

### Frontmatter

```yaml
---
title: "Post title"
description: "Short line for cards and RSS."
date: 2026-04-14
author: "Peter Abraham"
authorLinkedIn: "https://www.linkedin.com/in/your-profile/"
tags:
  - ai-strategy
---
```

| Field | Required | Notes |
|-------|----------|--------|
| `author` | No | Shown as **Author:** under the date on the post. |
| `authorLinkedIn` | No | Full `https://www.linkedin.com/in/...` URL. If set, the author name links to LinkedIn; if omitted, the name is plain text. |

Replace the sample `authorLinkedIn` values in `published/blog/*.md` with each author’s real LinkedIn profile URL.

Optional: set `permalink` yourself; otherwise URLs are `/blog/<filename-without-ext>/` (e.g. `welcome.md` → `/blog/welcome/`).

Body: normal Markdown — headings, lists, blockquotes, fenced code, tables.

### Publish

```bash
cd vault-shared
git add published/blog/
git commit -m "blog: new post"
git push
```

Pushing `published/blog/` triggers [`trigger-builds.yml`](https://github.com/aivalueworx/vault-shared/blob/main/.github/workflows/trigger-builds.yml), which dispatches a build to this repo. No need to push `blog` for content-only changes.

## Cloudflare Pages (required for deploy)

Deploy target is the **AI Value Worx** Cloudflare account (same account as the **`aivalueworx.com`** zone). Pages projects **do not move** between accounts — create/deploy **`aivalueworx-blog`** in the correct account and retire the old project elsewhere.

| Account | Account ID | Notes |
|---------|------------|--------|
| **peter@aivalueworx.com** (use this) | `397d163c1b67643b7818aff942767495` | Marketing zone + blog should live here |
| **peter@wearecrank.com** (legacy) | `5be4b6b581b13c18f518b44ac4768b3d` | Old `aivalueworx-blog` — delete after custom domain is on the new project |

**Live Pages URL (until custom domain):** https://aivalueworx-blog-8lz.pages.dev  
**Target custom domain:** https://blog.aivalueworx.com — add under **Workers & Pages** → **aivalueworx-blog** → **Custom domains** in account `397d163c…`, then set [`src/_data/site.json`](src/_data/site.json) `siteUrl` to `https://blog.aivalueworx.com`.

GitHub → **`aivalueworx/blog`** → **Settings** → **Secrets and variables** → **Actions**:

| Secret | Purpose |
|--------|---------|
| **`CLOUDFLARE_ACCOUNT_ID`** | `397d163c1b67643b7818aff942767495` |
| **`CLOUDFLARE_API_TOKEN`** | Account token with **Pages Write** (or **Cloudflare Pages → Edit** on classic user tokens) scoped to that account |
| **`VAULT_SHARED_CHECKOUT_TOKEN`** | PAT with read access to private **`aivalueworx/vault-shared`** (CI checkout of posts) |
| **`PAGES_SITE_URL`** | Optional — Slack notify URL after deploy |
| **`SLACK_WEBHOOK_URL`** | Optional |

CI uses [Direct Upload](https://developers.cloudflare.com/pages/how-to/use-direct-upload-with-continuous-integration/) via **`cloudflare/wrangler-action`**. The workflow creates the **`aivalueworx-blog`** project in the target account if missing, then runs `pages deploy`.

Manual redeploy: **Actions** → **Deploy to Cloudflare Pages** → **Run workflow** (branch **`main`**).

## Custom domain

**Subdomain (recommended):** `blog.aivalueworx.com` on the **`aivalueworx-blog`** project in account **`397d163c…`**. Because the zone is in the same account, Cloudflare can create DNS when you add the custom domain.

## RSS

Atom feed: **`/blog/feed.xml`** (e.g. `https://<your-pages-domain>/blog/feed.xml`).

---

*AIValueWorx · A Goal Atlas + weareCrank partnership*
