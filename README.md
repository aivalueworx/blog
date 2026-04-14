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

The **first** push will fail the deploy step until you add secrets — **CI build** still passes.

1. In Cloudflare → **Workers & Pages** → **Create** → **Pages** → connect nothing; the site is uploaded by GitHub Actions only. Or create an empty project named **`aivalueworx-blog`** (must match `projectName` in [`.github/workflows/deploy.yml`](.github/workflows/deploy.yml)).
2. On GitHub → **`aivalueworx/blog`** → **Settings** → **Secrets and variables** → **Actions**, add (same values as [strategy-docs](https://github.com/aivalueworx/strategy-docs) if you use the same Cloudflare account):
   - **`CLOUDFLARE_API_TOKEN`** — API token with **Account** → **Cloudflare Pages** → **Edit**
   - **`CLOUDFLARE_ACCOUNT_ID`** — 32-character account ID (Cloudflare dashboard sidebar)
3. Optional: **`SLACK_WEBHOOK_URL`**, **`PAGES_SITE_URL`** for Slack messages after deploy.

Re-run the failed workflow (**Actions** → failed run → **Re-run all jobs**) or push any commit to `main`.

Update [`src/_data/site.json`](src/_data/site.json) `siteUrl` and `mainSiteUrl` when you have production URLs.

## Custom domain (`aivalueworx.com/blog`)

The marketing site is on Railway; this blog is a separate static site on Cloudflare. Typical approaches:

- **Subdomain:** `blog.aivalueworx.com` → point DNS to Cloudflare Pages (simplest).
- **Path `/blog` on apex:** use Cloudflare **Workers** or **Transform Rules** to proxy `/blog/*` to the Pages project, or host both behind one Cloudflare zone with routing rules.

## RSS

Atom feed: **`/blog/feed.xml`** (e.g. `https://<your-pages-domain>/blog/feed.xml`).

---

*AIValueWorx · A Goal Atlas × weareCrank partnership*
