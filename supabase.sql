-- 测测你的上下文 · 统计表
-- 用法：Supabase 项目 → SQL Editor → New query → 粘贴全部 → Run

create table if not exists public.plays (
  id          bigint generated always as identity primary key,
  created_at  timestamptz not null default now(),
  nickname    text check (char_length(nickname) <= 20),
  tier        text,      -- 档位：−∞ / 4K / 32K / 128K / 256K / 1M / +∞
  persona     text,      -- 人格名：幻觉体、金鱼型……
  code        text,      -- 四位类型码，如 CDVA
  total       int,       -- 总分 0–100
  memory      int,       -- 记忆 %
  focus       int,       -- 专注 %
  summary     int,       -- 概括 %
  human       int,       -- 人味 %
  timeouts    int,       -- 超时次数
  answers     jsonb,     -- 每题选了第几个（0=A，-1=超时）
  device      text       -- 手机 / 电脑
);

-- 打开行级权限：网页只能“写入”一条新记录，不能读取或修改任何人的记录。
-- 你自己在 Supabase 后台的 Table Editor 里可以看到全部数据。
alter table public.plays enable row level security;

-- 新项目默认不给网页角色任何表权限：只开放“新增”
revoke all on public.plays from anon;
grant insert on public.plays to anon;

drop policy if exists "anyone can submit a play" on public.plays;
create policy "anyone can submit a play"
  on public.plays for insert
  to anon
  with check (true);

-- 常用统计（在 SQL Editor 里单独运行）：
-- 各档位人数：
--   select tier, persona, count(*) from plays group by 1,2 order by 3 desc;
-- 最近 50 条：
--   select created_at, nickname, tier, persona, code from plays order by id desc limit 50;
