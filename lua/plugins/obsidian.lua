--
--
--
--
--
-- 3. 이 코드의 동작 방식 (Spec 구현 포인트)
-- 자동 파일명 치환: <leader>on을 눌러 aaa bbb라는 이름으로 노트를 생성하면 10_Notes/202608101945-aaa_bbb.md가 자동 생성됩니다.
--
-- 가독성 링크(Alias) 확보: 본문 내에서 [[ccc]]라고 입력하고 엔터를 누르면 새 파일이 생성되며 본문 링크는 깔끔하게 [[202608101945-ccc|ccc]]로 변환되어 표시됩니다.
--
-- 검색 우선 연결 Workflow: <leader>ol 단축키를 이용해 이미 존재하는 노트를 뒤쪽 의미 있는 이름(ccc)만으로 찾아 본문에 손쉽게 링크로 박을 수 있어 동명 메모 중복 생성을 예방합니다.
--






































-- return {
--   "epwalsh/obsidian.nvim",
--   version = "*", -- 최신 안정 버전 사용
--   lazy = true,
--   ft = "markdown",
--   dependencies = {
--     "nvim-lua/plenary.nvim",
--     "nvim-telescope/telescope.nvim", -- 검색 및 링크 선택 도구
--   },
--   opts = {
--     -- 1. Vault 위치 설정 (실제 Obsidian 보관소 경로로 변경하세요)
--     workspaces = {
--       {
--         name = "personal",
--         -- path = "~/obsidian-vault",
--         path = "C:/stc_obsidian222/stc222", -- 작업 공간의 루트 경로(path)
--       },
--     },
--
--     -- 2. 기본 디렉토리 설정 (Spec 반영)
--     notes_subdir = "10_Notes",
--     new_notes_location = "notes_subdir",
--
--     -- 3. Daily Note 설정 (Spec 반영)
--     daily_notes = {
--       folder = "00_Daily",
--       date_format = "%Y-%m-%d",
--       alias_format = "%B %d, %Y",
--       template = "daily.md",
--     },
--
--     -- 4. 파일명 생성 규칙 (YYYYMMDDHHMM-title.md & 공백 -> 언더바 치환)
--     note_id_func = function(title)
--       local prefix = os.date("%Y%m%d%H%M")
--       if title ~= nil then
--         -- 공백을 언더바로 변경하고 소문자/영문/한글/숫자/언더바/하이픈 이외 문자 제거
--         local clean_title = title:gsub(" ", "_"):gsub("[^%w_%-가-힣]", "")
--         return prefix .. "-" .. clean_title
--       else
--         -- 제목이 없을 경우 4자리 랜덤 문자열 추가
--         local suffix = ""
--         for _ = 1, 4 do
--           suffix = suffix .. string.char(math.random(65, 90))
--         end
--         return prefix .. "-" .. suffix
--       end
--     end,
--
--     -- 5. Wiki Link 및 Alias 설정 ([[202608101945-title|title]])
--     wiki_link_func = function(opts)
--       return string.format("[[%s|%s]]", opts.path, opts.label)
--     end,
--
--     -- 6. YAML Frontmatter 자동 생성 규칙
--     note_frontmatter_func = function(note)
--       -- title이 설정되지 않은 경우 파일명에서 파싱
--       local out = {
--         id = note.id,
--         title = note.title or note.id,
--         created = os.date("%Y-%m-%d %H:%M"),
--         updated = os.date("%Y-%m-%d %H:%M"),
--         tags = note.tags or { "note" },
--         aliases = { note.title or note.id },
--       }
--
--       -- 기존 메타데이터가 있으면 보존
--       if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
--         for k, v in pairs(note.metadata) do
--           out[k] = v
--         end
--       end
--
--       return out
--     end,
--
--     -- 7. 템플릿 설정 (Spec 반영)
--     templates = {
--       folder = "99_Templates",
--       date_format = "%Y-%m-%d",
--       time_format = "%H:%M",
--       substitutions = {
--         date = function()
--           return os.date("%Y-%m-%d")
--         end,
--         time = function()
--           return os.date("%H:%M")
--         end,
--       },
--     },
--
--     -- 8. UI 및 완성도 설정
--     completion = {
--       nvim_cmp = true,
--       min_chars = 2,
--     },
--
--     -- 체크박스 및 링크 강조 등 Neovim 내 렌더링
--     ui = {
--       enable = true,
--       checkboxes = {
--         [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
--         ["x"] = { char = "", hl_group = "ObsidianDone" },
--       },
--     },
--   },
--
--   -- 9. 핵심 단축키 매핑 (검색 우선 및 빠른 생성)
--   keys = {
--     { "<leader>on", "<cmd>ObsidianNew<cr>", desc = "Obsidian: 새 노트 생성" },
--     { "<leader>od", "<cmd>ObsidianToday<cr>", desc = "Obsidian: 오늘 데일리 노트" },
--     { "<leader>os", "<cmd>ObsidianSearch<cr>", desc = "Obsidian: 전체 메모 검색 (Telescope)" },
--     { "<leader>ol", "<cmd>ObsidianLink<cr>", desc = "Obsidian: 기존 메모 선택하여 링크 삽입" },
--     { "<leader>oo", "<cmd>ObsidianQuickSwitch<cr>", desc = "Obsidian: 빠른 노트 전환" },
--     { "<leader>ot", "<cmd>ObsidianTemplate<cr>", desc = "Obsidian: 템플릿 적용" },
--   },
-- }

-- ----------------------------------------
-- ----------------------------------------
-- ----------------------------------------
-- ----------------------------------------
--
-- completion.nvim_cmp를 false로 변경하고 blink.cmp와의 연동을 위해 의존성을 정리한 코드입니다.


-- return {
--   "epwalsh/obsidian.nvim",
--   version = "*", -- 최신 안정 버전 사용
--   lazy = true,
--   ft = "markdown",
--   dependencies = {
--     "nvim-lua/plenary.nvim",
--     "nvim-telescope/telescope.nvim", -- 검색 및 링크 선택 도구
--   },
--   opts = {
--     -- 1. Vault 위치 설정 (실제 Obsidian 보관소 경로로 변경하세요)
--     workspaces = {
--       {
--         name = "personal",
--         -- path = "~/obsidian-vault",
--         path = "C:/stc_obsidian222", -- 작업 공간의 루트 경로(path)
--       },
--     },
--
--     -- 2. 기본 디렉토리 설정 (Spec 반영)
--     notes_subdir = "10_Notes",
--     new_notes_location = "notes_subdir",
--
--     -- 3. Daily Note 설정 (Spec 반영)
--     daily_notes = {
--       folder = "00_Daily",
--       date_format = "%Y-%m-%d",
--       alias_format = "%B %d, %Y",
--       template = "daily.md",
--     },
--
--     -- 4. 파일명 생성 규칙 (YYYYMMDDHHMM-title.md & 공백 -> 언더바 치환)
--     note_id_func = function(title)
--       local prefix = os.date("%Y%m%d%H%M")
--       if title ~= nil then
--         -- 공백을 언더바로 변경하고 소문자/영문/한글/숫자/언더바/하이픈 이외 문자 제거
--         local clean_title = title:gsub(" ", "_"):gsub("[^%w_%-가-힣]", "")
--         return prefix .. "-" .. clean_title
--       else
--         -- 제목이 없을 경우 4자리 랜덤 문자열 추가
--         local suffix = ""
--         for _ = 1, 4 do
--           suffix = suffix .. string.char(math.random(65, 90))
--         end
--         return prefix .. "-" .. suffix
--       end
--     end,
--
--     -- 5. Wiki Link 및 Alias 설정 ([[202608101945-title|title]])
--     wiki_link_func = function(opts)
--       return string.format("[[%s|%s]]", opts.path, opts.label)
--     end,
--
--     -- 6. YAML Frontmatter 자동 생성 규칙
--     note_frontmatter_func = function(note)
--       -- title이 설정되지 않은 경우 파일명에서 파싱
--       local out = {
--         id = note.id,
--         title = note.title or note.id,
--         created = os.date("%Y-%m-%d %H:%M"),
--         updated = os.date("%Y-%m-%d %H:%M"),
--         tags = note.tags or { "note" },
--         aliases = { note.title or note.id },
--       }
--
--       -- 기존 메타데이터가 있으면 보존
--       if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
--         for k, v in pairs(note.metadata) do
--           out[k] = v
--         end
--       end
--
--       return out
--     end,
--
--     -- 7. 템플릿 설정 (Spec 반영)
--     templates = {
--       folder = "99_Templates",
--       date_format = "%Y-%m-%d",
--       time_format = "%H:%M",
--       substitutions = {
--         date = function()
--           return os.date("%Y-%m-%d")
--         end,
--         time = function()
--           return os.date("%H:%M")
--         end,
--       },
--     },
--
--     -- 8. UI 및 완성도 설정
--     -- ⚠️ 핵심 수정: nvim-cmp 자동 로드를 끕니다.
--     -- blink.cmp를 사용할 때는 obsidian.nvim 내부의 completion.nvim_cmp 옵션을 false로 끄고, 대신 blink.cmp 설정 쪽에서 obsidian을 completion source(보완 출처)로 등록해 주어야 합니다
--     completion = {
--       nvim_cmp = false,     -- blink.cmp 사용하므로 false
--       min_chars = 2,
--     },
--
--     -- 체크박스 및 링크 강조 등 Neovim 내 렌더링
--     ui = {
--       enable = true,
--       checkboxes = {
--         [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
--         ["x"] = { char = "", hl_group = "ObsidianDone" },
--       },
--     },
--   },
--
--   -- 9. 핵심 단축키 매핑 (검색 우선 및 빠른 생성)
--   keys = {
--     { "<leader>on", "<cmd>ObsidianNew<cr>", desc = "Obsidian: 새 노트 생성" },
--     { "<leader>od", "<cmd>ObsidianToday<cr>", desc = "Obsidian: 오늘 데일리 노트" },
--     { "<leader>os", "<cmd>ObsidianSearch<cr>", desc = "Obsidian: 전체 메모 검색 (Telescope)" },
--     { "<leader>ol", "<cmd>ObsidianLink<cr>", desc = "Obsidian: 기존 메모 선택하여 링크 삽입" },
--     { "<leader>oo", "<cmd>ObsidianQuickSwitch<cr>", desc = "Obsidian: 빠른 노트 전환" },
--     { "<leader>ot", "<cmd>ObsidianTemplate<cr>", desc = "Obsidian: 템플릿 적용" },
--   },
-- }

-- ----------------------------------------
-- ----------------------------------------
-- ----------------------------------------
-- (1) 본문(YYYYMMDDHHMM-aaa.md)에서 [[test]]을 입력한 후, [[test]]안에서 엔터를 누르면, test가 포함된 기존 파일들이 telescope 창에 나타나는데... 그 중에서 원하는 것을 선택하면, 그 선택한 파일이 링크로 결정되고 있어... 여기까지는 좋은데.... 본문에 표시되는 것이 그냥 [[test]]로만 보이기 때문에... 정확히 어떤 파일에 연결되어 있는지 구분이 쉽지 않아... 그래서.. 지금처럼 alias로만 연결하지 말고 [[YYYYMMDDHHMM-test|test]]가 되도록 고쳐줘. 


-- ----------------------------------------

-- return {
--   "epwalsh/obsidian.nvim",
--   version = "*",
--   lazy = true,
--   ft = "markdown",
--   dependencies = {
--     "nvim-lua/plenary.nvim",
--     "nvim-telescope/telescope.nvim",
--   },
--   opts = {
--     workspaces = {
--       {
--         name = "personal",
--         path = "C:/stc_obsidian222",
--       },
--     },
--
--     notes_subdir = "10_Notes",
--     new_notes_location = "notes_subdir",
--
--     daily_notes = {
--       folder = "00_Daily",
--       date_format = "%Y-%m-%d",
--       alias_format = "%B %d, %Y",
--       template = "daily.md",
--     },
--
--     note_id_func = function(title)
--       local prefix = os.date("%Y%m%d%H%M")
--       if title ~= nil then
--         local clean_title = title:gsub(" ", "_"):gsub("[^%w_%-가-힣]", "")
--         return prefix .. "-" .. clean_title
--       else
--         local suffix = ""
--         for _ = 1, 4 do
--           suffix = suffix .. string.char(math.random(65, 90))
--         end
--         return prefix .. "-" .. suffix
--       end
--     end,
--
--     -- ----------------------------------------
--
--     -- 5. Wiki Link 및 Alias 설정 ([[202608101945-title|title]]) - 보완 완료
--     -- wiki_link_func = function(opts)
--     --   local id = opts.id
--     --   if not id and opts.path then
--     --     id = tostring(opts.path):match("([^/\\]+)%.md$") or tostring(opts.path)
--     --   end
--     --
--     --   if opts.label and opts.label ~= "" and opts.label ~= id then
--     --     return string.format("[[%s|%s]]", id, opts.label)
--     --   else
--     --     return string.format("[[%s]]", id or opts.label)
--     --   end
--     -- end,
--
--     -- [[ 자동완성 기능으로 기존 메모파일을 선택했을 때, 결과가 [[날짜시간|title]] 로 나오게 하기
--     -- 5. Wiki Link 및 Alias 설정 ([[202608101945-title|title]]) - 보완 완료
--     wiki_link_func = function(opts)
--       local id = opts.id
--       if not id and opts.path then
--         id = tostring(opts.path):match("([^/\\]+)%.md$") or tostring(opts.path)
--       end
--
--       -- 1) label이 명시되어 있으면 그 label을 쓰고, 없으면 id에서 'YYYYMMDDHHMM-' 날짜 접두사를 제거해 가독성 이름(title)을 추출
--       local display_name = opts.label
--       if not display_name or display_name == "" or display_name == id then
--         display_name = id:gsub("^%d+%-", "")
--       end
--
--       -- 2) 무조건 [[ID|의미있는이름]] 형태로 완성되도록 출력
--       if display_name and display_name ~= "" then
--         return string.format("[[%s|%s]]", id, display_name)
--       else
--         return string.format("[[%s]]", id)
--       end
--     end,
--
--
--     -- ----------------------------------------
--
--
--     note_frontmatter_func = function(note)
--       local out = {
--         id = note.id,
--         title = note.title or note.id,
--         created = os.date("%Y-%m-%d %H:%M"),
--         updated = os.date("%Y-%m-%d %H:%M"),
--         tags = note.tags or { "note" },
--         aliases = { note.title or note.id },
--       }
--
--       if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
--         for k, v in pairs(note.metadata) do
--           out[k] = v
--         end
--       end
--
--       return out
--     end,
--
--     templates = {
--       folder = "99_Templates",
--       date_format = "%Y-%m-%d",
--       time_format = "%H:%M",
--       substitutions = {
--         date = function()
--           return os.date("%Y-%m-%d")
--         end,
--         time = function()
--           return os.date("%H:%M")
--         end,
--       },
--     },
--
--     completion = {
--       -- nvim_cmp = false,
--       nvim_cmp = true,
--       min_chars = 2,
--     },
--
--     ui = {
--       enable = true,
--       checkboxes = {
--         [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
--         ["x"] = { char = "", hl_group = "ObsidianDone" },
--       },
--     },
--   },
--
--   keys = {
--     { "<leader>on", "<cmd>ObsidianNew<cr>", desc = "Obsidian: 새 노트 생성" },
--     { "<leader>od", "<cmd>ObsidianToday<cr>", desc = "Obsidian: 오늘 데일리 노트" },
--
--
--     -- 'abc'가 포함된 문서를 찾아서 링크로 꽂아넣기 위한 핵심 명령어 매핑
--     -- <leader>os 를 누르면 보관소( path = "C:/stc_obsidian222"), 내의 모든 텍스트 내용을 검색합니다.
--     { "<leader>os", "<cmd>ObsidianSearch<cr>", desc = "Obsidian: 전체 메모 검색 (Telescope) 및 링크" },
--
--     { "<leader>ol", "<cmd>ObsidianLink<cr>", mode = { "n", "v" }, desc = "Obsidian: 선택 항목/단어 링크 삽입" },
--
--     { "<leader>oo", "<cmd>ObsidianQuickSwitch<cr>", desc = "Obsidian: 빠른 노트 전환" },
--     { "<leader>ot", "<cmd>ObsidianTemplate<cr>", desc = "Obsidian: 템플릿 적용" },
--
--     -- 📍 [추가] 링크 이동 및 새 노트 생성 단축키
--     { "gd", "<cmd>ObsidianFollowLink<cr>", desc = "Obsidian: 링크 파일로 이동 / 미존재 시 새 노트 생성" },
--   },
--
-- }

-- ----------------------------------------
-- ----------------------------------------
-- ----------------------------------------
  -- YYYYMMDDHHMM-의미있는이름.md --> YYYYMMDD-HHMM-의미있는이름.md
-- ----------------------------------------

-- return {
--   "epwalsh/obsidian.nvim",
--   version = "*",
--   lazy = true,
--   ft = "markdown",
--   dependencies = {
--     "nvim-lua/plenary.nvim",
--     "nvim-telescope/telescope.nvim",
--   },
--   opts = {
--     workspaces = {
--       {
--         name = "personal",
--         path = "C:/stc_obsidian222",
--       },
--     },
--
--     notes_subdir = "10_Notes",
--     new_notes_location = "notes_subdir",
--
--     daily_notes = {
--       folder = "00_Daily",
--       date_format = "%Y-%m-%d",
--       alias_format = "%B %d, %Y",
--       template = "daily.md",
--     },
--
--     -- 📍 [수정] 접두사 포맷을 YYYYMMDD-HHMM 형태로 변경
--     note_id_func = function(title)
--       local prefix = os.date("%Y%m%d-%H%M")
--       if title ~= nil then
--         local clean_title = title:gsub(" ", "_"):gsub("[^%w_%-가-힣]", "")
--         return prefix .. "-" .. clean_title
--       else
--         local suffix = ""
--         for _ = 1, 4 do
--           suffix = suffix .. string.char(math.random(65, 90))
--         end
--         return prefix .. "-" .. suffix
--       end
--     end,
--
--     -- 📍 [수정] YYYYMMDD-HHMM- 형태의 접두사를 지우고 제목만 추출하도록 패턴 수정
--     wiki_link_func = function(opts)
--       local id = opts.id
--       if not id and opts.path then
--         id = tostring(opts.path):match("([^/\\]+)%.md$") or tostring(opts.path)
--       end
--
--       -- label이 없거나 id와 같을 경우, 'YYYYMMDD-HHMM-' 패턴을 제거하고 가독성 제목만 추출
--       local display_name = opts.label
--       if not display_name or display_name == "" or display_name == id then
--         display_name = id:gsub("^%d%+?%-%d%+?%-", "")
--       end
--
--       -- 무조건 [[ID|의미있는이름]] 형태로 출력
--       if display_name and display_name ~= "" then
--         return string.format("[[%s|%s]]", id, display_name)
--       else
--         return string.format("[[%s]]", id)
--       end
--     end,
--
--     note_frontmatter_func = function(note)
--       local out = {
--         id = note.id,
--         title = note.title or note.id,
--         created = os.date("%Y-%m-%d %H:%M"),
--         updated = os.date("%Y-%m-%d %H:%M"),
--         tags = note.tags or { "note" },
--         aliases = { note.title or note.id },
--       }
--
--       if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
--         for k, v in pairs(note.metadata) do
--           out[k] = v
--         end
--       end
--
--       return out
--     end,
--
--     templates = {
--       folder = "99_Templates",
--       date_format = "%Y-%m-%d",
--       time_format = "%H:%M",
--       substitutions = {
--         date = function()
--           return os.date("%Y-%m-%d")
--         end,
--         time = function()
--           return os.date("%H:%M")
--         end,
--       },
--     },
--
--     completion = {
--       nvim_cmp = true,
--       min_chars = 2,
--     },
--
--     ui = {
--       enable = true,
--       checkboxes = {
--         [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
--         ["x"] = { char = "", hl_group = "ObsidianDone" },
--       },
--     },
--   },
--
--   keys = {
--     { "<leader>on", "<cmd>ObsidianNew<cr>", desc = "Obsidian: 새 노트 생성" },
--     { "<leader>od", "<cmd>ObsidianToday<cr>", desc = "Obsidian: 오늘 데일리 노트" },
--     { "<leader>os", "<cmd>ObsidianSearch<cr>", desc = "Obsidian: 전체 메모 검색 (Telescope) 및 링크" },
--     { "<leader>ol", "<cmd>ObsidianLink<cr>", mode = { "n", "v" }, desc = "Obsidian: 선택 항목/단어 링크 삽입" },
--     { "<leader>oo", "<cmd>ObsidianQuickSwitch<cr>", desc = "Obsidian: 빠른 노트 전환" },
--     { "<leader>ot", "<cmd>ObsidianTemplate<cr>", desc = "Obsidian: 템플릿 적용" },
--     { "gd", "<cmd>ObsidianFollowLink<cr>", desc = "Obsidian: 링크 파일로 이동 / 미존재 시 새 노트 생성" },
--   },
-- }

-- ----------------------------------------
-- ----------------------------------------
-- ----------------------------------------
--
-- [[자동완성 기능을 이용한 링크를 만들 때도 [[날짜시간정보-의미있는이름|의미있는이름]]로 나와야 하는데. [[날짜시간정보-의미있는이름|날짜시간정보-의미있는이름]]의 형태로 나오고 있어... 이것을 고쳐줘. 참고로 <leader>os를 이용한 링크 만들기 때는, 제대로 [[날짜시간정보-의미있는이름|의미있는이름]] 형태로 나오고 있어
--
-- ----------------------------------------
-- ----------------------------------------
-- ----------------------------------------

-- return {
--   "epwalsh/obsidian.nvim",
--   version = "*",
--   lazy = true,
--   ft = "markdown",
--   dependencies = {
--     "nvim-lua/plenary.nvim",
--     "nvim-telescope/telescope.nvim",
--   },
--   opts = {
--     workspaces = {
--       {
--         name = "personal",
--         path = "C:/stc_obsidian222",
--       },
--     },
--
--     notes_subdir = "10_Notes",
--     new_notes_location = "notes_subdir",
--
--     daily_notes = {
--       folder = "00_Daily",
--       date_format = "%Y-%m-%d",
--       alias_format = "%B %d, %Y",
--       template = "daily.md",
--     },
--
--     -- 접두사 포맷: YYYYMMDD-HHMM-
--     note_id_func = function(title)
--       local prefix = os.date("%Y%m%d-%H%M")
--       if title ~= nil then
--         local clean_title = title:gsub(" ", "_"):gsub("[^%w_%-가-힣]", "")
--         return prefix .. "-" .. clean_title
--       else
--         local suffix = ""
--         for _ = 1, 4 do
--           suffix = suffix .. string.char(math.random(65, 90))
--         end
--         return prefix .. "-" .. suffix
--       end
--     end,
--
--     -- 📍 [수정] YYYYMMDD-HHMM- 패턴을 정확히 제거하도록 gsub 패턴 변경 (^%d+%-%d+%-)
--     wiki_link_func = function(opts)
--       local id = opts.id
--       if not id and opts.path then
--         id = tostring(opts.path):match("([^/\\]+)%.md$") or tostring(opts.path)
--       end
--
--       -- label이 없거나 id 전체와 같을 경우, 앞의 '숫자8자리-숫자4자리-' 패턴을 제거하여 가독성 이름만 추출
--       local display_name = opts.label
--       if not display_name or display_name == "" or display_name == id then
--         display_name = id:gsub("^%d+%-%d+%-", "")
--       end
--
--       -- 무조건 [[ID|의미있는이름]] 형태로 출력
--       if display_name and display_name ~= "" then
--         return string.format("[[%s|%s]]", id, display_name)
--       else
--         return string.format("[[%s]]", id)
--       end
--     end,
--
--     note_frontmatter_func = function(note)
--       local out = {
--         id = note.id,
--         title = note.title or note.id,
--         created = os.date("%Y-%m-%d %H:%M"),
--         updated = os.date("%Y-%m-%d %H:%M"),
--         tags = note.tags or { "note" },
--         aliases = { note.title or note.id },
--       }
--
--       if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
--         for k, v in pairs(note.metadata) do
--           out[k] = v
--         end
--       end
--
--       return out
--     end,
--
--     templates = {
--       folder = "99_Templates",
--       date_format = "%Y-%m-%d",
--       time_format = "%H:%M",
--       substitutions = {
--         date = function()
--           return os.date("%Y-%m-%d")
--         end,
--         time = function()
--           return os.date("%H:%M")
--         end,
--       },
--     },
--
--     completion = {
--       nvim_cmp = true,
--       min_chars = 2,
--     },
--
--     ui = {
--       enable = true,
--       checkboxes = {
--         [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
--         ["x"] = { char = "", hl_group = "ObsidianDone" },
--       },
--     },
--   },
--
--   keys = {
--     { "<leader>on", "<cmd>ObsidianNew<cr>", desc = "Obsidian: 새 노트 생성" },
--     { "<leader>od", "<cmd>ObsidianToday<cr>", desc = "Obsidian: 오늘 데일리 노트" },
--     { "<leader>os", "<cmd>ObsidianSearch<cr>", desc = "Obsidian: 전체 메모 검색 (Telescope) 및 링크" },
--     { "<leader>ol", "<cmd>ObsidianLink<cr>", mode = { "n", "v" }, desc = "Obsidian: 선택 항목/단어 링크 삽입" },
--     { "<leader>oo", "<cmd>ObsidianQuickSwitch<cr>", desc = "Obsidian: 빠른 노트 전환" },
--     { "<leader>ot", "<cmd>ObsidianTemplate<cr>", desc = "Obsidian: 템플릿 적용" },
--     { "gd", "<cmd>ObsidianFollowLink<cr>", desc = "Obsidian: 링크 파일로 이동 / 미존재 시 새 노트 생성" },
--   },
-- }

-- ----------------------------------------
-- ----------------------------------------
-- ----------------------------------------
-- :ObsidianFollowLink (gf)의 결과가, 본문에서 [[날짜-시간-아직없는메모|아직없는메모]]의 형태로 나오게 하기
-- ----------------------------------------


-- return {
--   "epwalsh/obsidian.nvim",
--   version = "*",
--   lazy = true,
--   ft = "markdown",
--   dependencies = {
--     "nvim-lua/plenary.nvim",
--     "nvim-telescope/telescope.nvim",
--   },
--   opts = {
--     workspaces = {
--       {
--         name = "personal",
--         path = "C:/stc_obsidian222",
--       },
--     },
--
--     notes_subdir = "10_Notes",
--     new_notes_location = "notes_subdir",
--
--     daily_notes = {
--       folder = "00_Daily",
--       date_format = "%Y-%m-%d",
--       alias_format = "%B %d, %Y",
--       template = "daily.md",
--     },
--
--     -- 접두사 포맷: YYYYMMDD-HHMM-
--     note_id_func = function(title)
--       local prefix = os.date("%Y%m%d-%H%M")
--       if title ~= nil then
--         local clean_title = title:gsub(" ", "_"):gsub("[^%w_%-가-힣]", "")
--         return prefix .. "-" .. clean_title
--       else
--         local suffix = ""
--         for _ = 1, 4 do
--           suffix = suffix .. string.char(math.random(65, 90))
--         end
--         return prefix .. "-" .. suffix
--       end
--     end,
--
--     -- YYYYMMDD-HHMM- 패턴을 제거하고 가독성 이름 추출
--     wiki_link_func = function(opts)
--       local id = opts.id
--       if not id and opts.path then
--         id = tostring(opts.path):match("([^/\\]+)%.md$") or tostring(opts.path)
--       end
--
--       local display_name = opts.label
--       if not display_name or display_name == "" or display_name == id then
--         display_name = id:gsub("^%d+%-%d+%-", "")
--       end
--
--       if display_name and display_name ~= "" then
--         return string.format("[[%s|%s]]", id, display_name)
--       else
--         return string.format("[[%s]]", id)
--       end
--     end,
--
--     note_frontmatter_func = function(note)
--       local out = {
--         id = note.id,
--         title = note.title or note.id,
--         created = os.date("%Y-%m-%d %H:%M"),
--         updated = os.date("%Y-%m-%d %H:%M"),
--         tags = note.tags or { "note" },
--         aliases = { note.title or note.id },
--       }
--
--       if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
--         for k, v in pairs(note.metadata) do
--           out[k] = v
--         end
--       end
--
--       return out
--     end,
--
--     templates = {
--       folder = "99_Templates",
--       date_format = "%Y-%m-%d",
--       time_format = "%H:%M",
--       substitutions = {
--         date = function()
--           return os.date("%Y-%m-%d")
--         end,
--         time = function()
--           return os.date("%H:%M")
--         end,
--       },
--     },
--
--     completion = {
--       nvim_cmp = true,
--       min_chars = 2,
--     },
--
--     ui = {
--       enable = true,
--       checkboxes = {
--         [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
--         ["x"] = { char = "", hl_group = "ObsidianDone" },
--       },
--     },
--   },
--
--   keys = {
--     { "<leader>on", "<cmd>ObsidianNew<cr>", desc = "Obsidian: 새 노트 생성" },
--     { "<leader>od", "<cmd>ObsidianToday<cr>", desc = "Obsidian: 오늘 데일리 노트" },
--     { "<leader>os", "<cmd>ObsidianSearch<cr>", desc = "Obsidian: 전체 메모 검색 (Telescope) 및 링크" },
--     { "<leader>ol", "<cmd>ObsidianLink<cr>", mode = { "n", "v" }, desc = "Obsidian: 선택 항목/단어 링크 삽입" },
--     { "<leader>oo", "<cmd>ObsidianQuickSwitch<cr>", desc = "Obsidian: 빠른 노트 전환" },
--     { "<leader>ot", "<cmd>ObsidianTemplate<cr>", desc = "Obsidian: 템플릿 적용" },
--
--     -- 📍 [수정] smart_action을 통해 가상 링크를 올바른 포맷([[ID|제목]])으로 실시간 교체하며 파일 생성
--     {
--       "gd",
--       function()
--         return require("obsidian").util.smart_action()
--       end,
--       desc = "Obsidian: 스마트 링크 이동 및 가상링크 자동 변환 생성",
--     },
--   },
-- }


-- ----------------------------------------
-- ----------------------------------------
-- ----------------------------------------
-- 위의 gd가 오동작, 아무 반응이 없고, <Cr>을 눌러야 새로운 메모가 생성되는 오유
-- ----------------------------------------

-- return {
--   "epwalsh/obsidian.nvim",
--   version = "*",
--   lazy = true,
--   ft = "markdown",
--   dependencies = {
--     "nvim-lua/plenary.nvim",
--     "nvim-telescope/telescope.nvim",
--   },
--   opts = {
--     workspaces = {
--       {
--         name = "personal",
--         path = "C:/stc_obsidian222",
--       },
--     },
--
--     notes_subdir = "10_Notes",
--     new_notes_location = "notes_subdir",
--
--     daily_notes = {
--       folder = "00_Daily",
--       date_format = "%Y-%m-%d",
--       alias_format = "%B %d, %Y",
--       template = "daily.md",
--     },
--
--     -- 접두사 포맷: YYYYMMDD-HHMM-
--     note_id_func = function(title)
--       local prefix = os.date("%Y%m%d-%H%M")
--       if title ~= nil then
--         local clean_title = title:gsub(" ", "_"):gsub("[^%w_%-가-힣]", "")
--         return prefix .. "-" .. clean_title
--       else
--         local suffix = ""
--         for _ = 1, 4 do
--           suffix = suffix .. string.char(math.random(65, 90))
--         end
--         return prefix .. "-" .. suffix
--       end
--     end,
--
--     -- YYYYMMDD-HHMM- 패턴 제거 후 display_name 추출
--     wiki_link_func = function(opts)
--       local id = opts.id
--       if not id and opts.path then
--         id = tostring(opts.path):match("([^/\\]+)%.md$") or tostring(opts.path)
--       end
--
--       local display_name = opts.label
--       if not display_name or display_name == "" or display_name == id then
--         display_name = id:gsub("^%d+%-%d+%-", "")
--       end
--
--       if display_name and display_name ~= "" then
--         return string.format("[[%s|%s]]", id, display_name)
--       else
--         return string.format("[[%s]]", id)
--       end
--     end,
--
--     note_frontmatter_func = function(note)
--       local out = {
--         id = note.id,
--         title = note.title or note.id,
--         created = os.date("%Y-%m-%d %H:%M"),
--         updated = os.date("%Y-%m-%d %H:%M"),
--         tags = note.tags or { "note" },
--         aliases = { note.title or note.id },
--       }
--
--       if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
--         for k, v in pairs(note.metadata) do
--           out[k] = v
--         end
--       end
--
--       return out
--     end,
--
--     templates = {
--       folder = "99_Templates",
--       date_format = "%Y-%m-%d",
--       time_format = "%H:%M",
--       substitutions = {
--         date = function()
--           return os.date("%Y-%m-%d")
--         end,
--         time = function()
--           return os.date("%H:%M")
--         end,
--       },
--     },
--
--     completion = {
--       nvim_cmp = true,
--       min_chars = 2,
--     },
--
--     ui = {
--       enable = true,
--       checkboxes = {
--         [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
--         ["x"] = { char = "", hl_group = "ObsidianDone" },
--       },
--     },
--   },
--
--   keys = {
--     { "<leader>on", "<cmd>ObsidianNew<cr>", desc = "Obsidian: 새 노트 생성" },
--     { "<leader>od", "<cmd>ObsidianToday<cr>", desc = "Obsidian: 오늘 데일리 노트" },
--     { "<leader>os", "<cmd>ObsidianSearch<cr>", desc = "Obsidian: 전체 메모 검색 (Telescope) 및 링크" },
--     { "<leader>ol", "<cmd>ObsidianLink<cr>", mode = { "n", "v" }, desc = "Obsidian: 선택 항목/단어 링크 삽입" },
--     { "<leader>oo", "<cmd>ObsidianQuickSwitch<cr>", desc = "Obsidian: 빠른 노트 전환" },
--     { "<leader>ot", "<cmd>ObsidianTemplate<cr>", desc = "Obsidian: 템플릿 적용" },
--
--     -- 📍 [수정] gd 입력 시 반응하지 않던 현상을 해결한 smart_action 매핑
--     {
--       "gd",
--       function()
--         local obsidian = require("obsidian").get_client()
--         if obsidian:is_note_link_at_cursor() then
--           return obsidian:follow_link()
--         else
--           return require("obsidian").util.smart_action()
--         end
--       end,
--       desc = "Obsidian: 스마트 링크 이동 및 가상링크 자동 변환 생성",
--     },
--   },
-- }


-- ----------------------------------------
-- ----------------------------------------
-- ----------------------------------------
-- ----------------------------------------
-- ----------------------------------------

return {
  "epwalsh/obsidian.nvim",
  version = "*",
  lazy = true,
  ft = "markdown",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
  },
  opts = {
    workspaces = {
      {
        name = "personal",
        path = "C:/stc_obsidian222",
      },
    },

    notes_subdir = "10_Notes",
    new_notes_location = "notes_subdir",

    daily_notes = {
      folder = "00_Daily",
      date_format = "%Y-%m-%d",
      alias_format = "%B %d, %Y",
      template = "daily.md",
    },

    -- 접두사 포맷: YYYYMMDD-HHMM-
    note_id_func = function(title)
      local prefix = os.date("%Y%m%d-%H%M")
      if title ~= nil then
        local clean_title = title:gsub(" ", "_"):gsub("[^%w_%-가-힣]", "")
        return prefix .. "-" .. clean_title
      else
        local suffix = ""
        for _ = 1, 4 do
          suffix = suffix .. string.char(math.random(65, 90))
        end
        return prefix .. "-" .. suffix
      end
    end,

    -- YYYYMMDD-HHMM- 패턴 제거 후 display_name 추출
    wiki_link_func = function(opts)
      local id = opts.id
      if not id and opts.path then
        id = tostring(opts.path):match("([^/\\]+)%.md$") or tostring(opts.path)
      end

      local display_name = opts.label
      if not display_name or display_name == "" or display_name == id then
        display_name = id:gsub("^%d+%-%d+%-", "")
      end

      if display_name and display_name ~= "" then
        return string.format("[[%s|%s]]", id, display_name)
      else
        return string.format("[[%s]]", id)
      end
    end,

    note_frontmatter_func = function(note)
      local out = {
        id = note.id,
        title = note.title or note.id,
        created = os.date("%Y-%m-%d %H:%M"),
        updated = os.date("%Y-%m-%d %H:%M"),
        tags = note.tags or { "note" },
        aliases = { note.title or note.id },
      }

      if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
        for k, v in pairs(note.metadata) do
          out[k] = v
        end
      end

      return out
    end,

    templates = {
      folder = "99_Templates",
      date_format = "%Y-%m-%d",
      time_format = "%H:%M",
      substitutions = {
        date = function()
          return os.date("%Y-%m-%d")
        end,
        time = function()
          return os.date("%H:%M")
        end,
      },
    },

    completion = {
      nvim_cmp = true,
      min_chars = 2,
    },

    ui = {
      enable = true,
      checkboxes = {
        [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
        ["x"] = { char = "", hl_group = "ObsidianDone" },
      },
    },
  },

  keys = {
    { "<leader>on", "<cmd>ObsidianNew<cr>", desc = "Obsidian: 새 노트 생성" },
    { "<leader>od", "<cmd>ObsidianToday<cr>", desc = "Obsidian: 오늘 데일리 노트" },
    { "<leader>os", "<cmd>ObsidianSearch<cr>", desc = "Obsidian: 전체 메모 검색 (Telescope) 및 링크" },
    { "<leader>ol", "<cmd>ObsidianLink<cr>", mode = { "n", "v" }, desc = "Obsidian: 선택 항목/단어 링크 삽입" },
    { "<leader>oo", "<cmd>ObsidianQuickSwitch<cr>", desc = "Obsidian: 빠른 노트 전환" },
    { "<leader>ot", "<cmd>ObsidianTemplate<cr>", desc = "Obsidian: 템플릿 적용" },

    -- 📍 [수정] nil 에러를 방지하고 obsidian.util 함수를 정상 호출하도록 수정
    {
      "gd",
      function()
        local util = require("obsidian").util
        if util.cursor_on_markdown_link() then
          return require("obsidian").get_client():follow_link()
        else
          return util.smart_action()
        end
      end,
      desc = "Obsidian: 스마트 링크 이동 및 가상링크 자동 변환 생성",
    },
  },
}







