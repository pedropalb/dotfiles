-- anthracite: an Oh My Pi "anthracite" theme adapted for code.
--
-- Source palette: ~/.omp/agent/config.yml (theme.dark: anthracite) resolved from
-- node_modules/@oh-my-pi/pi-coding-agent/src/modes/theme/defaults/anthracite.json
--
-- The dark surfaces and warm/cool identity come from the original theme. Syntax
-- accents use higher chroma and a wider luminance range so semantic landmarks
-- remain distinct without coloring ordinary variables.
local C = {
  coal = "#0d0f13", -- page background (Normal)
  coalLighter = "#1a1e25", -- card, float, generated-text background
  selectedBg = "#2a303b", -- selection, cursorline, popup selection
  steel = "#465064", -- borders, separators, nontext
  steelLight = "#5a657c", -- accent borders, special keys
  ember = "#f0784f", -- accent: headings, bullets, tags, constructors
  emberDim = "#c05c3f",
  ash = "#d4d8e4", -- default text
  ashGray = "#a5adbf", -- muted text, quotes
  soot = "#737b8c", -- generated metadata, inlay hints
  sootDark = "#515a69", -- dimmest: statusline NC, ignore
  success = "#82c76c", -- green
  error = "#ef6262", -- red
  warning = "#f0a348", -- yellow
  link = "#5db0eb", -- links, info, statusline path
  comment = "#5d7693", -- comments and docstrings
  keyword = "#6da9e8", -- keywords, statements
  module = "#a58bd8", -- modules and namespaces
  func = "#f0a45f", -- functions, preproc
  var = "#afbed6", -- parameters, members, fields
  str = "#d98b5e", -- strings
  num = "#7fc374", -- numbers, booleans, constants
  typ = "#4fc7af", -- types
  op = "#c2c8d3", -- operators
  punct = "#7f8798", -- punctuation / delimiters
  mdCode = "#f2b57c", -- inline code
  mdCodeBlock = "#cad8eb", -- code block text
  statusBg = "#090b0e", -- statusline, tabline
  statusModel = "#d6a66e", -- todo, special, labels
  toolPendingBg = "#171a21",
  toolSuccessBg = "#141a16",
  toolErrorBg = "#221617",
  userMessageBg = "#1a1511", -- warm tinted surface (warning virtual-text bg)
  statusContext = "#8f9ab3", -- statusline context color
}

vim.o.background = "dark"

local function hl(name, val)
  vim.api.nvim_set_hl(0, name, val)
end

-- Base / UI ---------------------------------------------------------------

hl("Normal", { fg = C.ash, bg = C.coal })
hl("NormalFloat", { fg = C.ash, bg = C.coalLighter })
hl("NormalNC", { fg = C.ashGray, bg = C.coal })
hl("EndOfBuffer", { fg = C.sootDark })
hl("ColorColumn", { bg = C.selectedBg })
hl("CursorColumn", { bg = C.selectedBg })
hl("CursorLine", { bg = C.selectedBg })
hl("CursorLineNr", { fg = C.ash, bold = true })
hl("Cursor", { fg = C.coal, bg = C.ash })
hl("iCursor", { fg = C.coal, bg = C.ember })
hl("lCursor", { fg = C.coal, bg = C.ash })
hl("TermCursor", { fg = C.coal, bg = C.ash })
hl("LineNr", { fg = C.soot })
hl("LineNrAbove", { fg = C.sootDark })
hl("LineNrBelow", { fg = C.sootDark })
hl("SignColumn", { fg = C.soot, bg = C.coal })
hl("FoldColumn", { fg = C.soot })
hl("Folded", { fg = C.ashGray, bg = C.toolPendingBg })
hl("Conceal", { fg = C.soot })
hl("NonText", { fg = C.steel })
hl("Whitespace", { fg = C.steel })
hl("SpecialKey", { fg = C.steelLight })
hl("MatchParen", { fg = C.ember, bg = C.steel })
hl("Visual", { bg = C.selectedBg })
hl("VisualNOS", { bg = C.selectedBg })
hl("QuickFixLine", { bg = C.selectedBg })
hl("WildMenu", { fg = C.ash, bg = C.selectedBg })

hl("StatusLine", { fg = C.ashGray, bg = C.statusBg })
hl("StatusLineNC", { fg = C.sootDark, bg = C.statusBg })
hl("WinBar", { fg = C.ashGray, bg = C.statusBg })
hl("WinBarNC", { fg = C.sootDark, bg = C.statusBg })
hl("WinSeparator", { fg = C.steel })
hl("VertSplit", { fg = C.steel })
hl("TabLine", { bg = C.statusBg, fg = C.soot })
hl("TabLineSel", { bg = C.coalLighter, fg = C.ember })
hl("TabLineFill", { bg = C.statusBg })

hl("Pmenu", { fg = C.ash, bg = C.coalLighter })
hl("PmenuSel", { fg = C.ash, bg = C.selectedBg })
hl("PmenuSbar", { bg = C.coalLighter })
hl("PmenuThumb", { bg = C.steel })
hl("PmenuKind", { fg = C.link })
hl("PmenuKindSel", { fg = C.link, bg = C.selectedBg })
hl("PmenuExtra", { fg = C.ashGray })
hl("PmenuExtraSel", { fg = C.ashGray, bg = C.selectedBg })
hl("FloatBorder", { fg = C.steelLight })
hl("FloatTitle", { fg = C.ember })
hl("FloatFooter", { fg = C.ashGray })

hl("Title", { fg = C.ember, bold = true })
hl("Search", { fg = C.ash, bg = C.steel })
hl("IncSearch", { fg = C.coal, bg = C.ember })
hl("CurSearch", { fg = C.coal, bg = C.ember, bold = true })
hl("Substitute", { fg = C.coal, bg = C.ember })
hl("Underlined", { fg = C.link, underline = true })
hl("Ignore", { fg = C.sootDark })
hl("Directory", { fg = C.link })
hl("ErrorMsg", { fg = C.error })
hl("WarningMsg", { fg = C.warning })
hl("MoreMsg", { fg = C.success })
hl("Question", { fg = C.success })
hl("ModeMsg", { fg = C.link })
hl("SpellBad", { undercurl = true, sp = C.error })
hl("SpellCap", { undercurl = true, sp = C.warning })
hl("SpellRare", { undercurl = true, sp = C.typ })
hl("SpellLocal", { undercurl = true, sp = C.link })
hl("StatusLineTerm", { link = "StatusLine" })
hl("StatusLineTermNC", { link = "StatusLineNC" })

-- Diagnostics / LSP -------------------------------------------------------

hl("DiagnosticError", { fg = C.error })
hl("DiagnosticWarn", { fg = C.warning })
hl("DiagnosticInfo", { fg = C.link })
hl("DiagnosticHint", { fg = C.typ })
hl("DiagnosticOk", { fg = C.success })
hl("DiagnosticSignError", { fg = C.error })
hl("DiagnosticSignWarn", { fg = C.warning })
hl("DiagnosticSignInfo", { fg = C.link })
hl("DiagnosticSignHint", { fg = C.typ })
hl("DiagnosticSignOk", { fg = C.success })
hl("DiagnosticUnderlineError", { undercurl = true, sp = C.error })
hl("DiagnosticUnderlineWarn", { undercurl = true, sp = C.warning })
hl("DiagnosticUnderlineInfo", { undercurl = true, sp = C.link })
hl("DiagnosticUnderlineHint", { undercurl = true, sp = C.typ })
hl("DiagnosticFloatingError", { fg = C.error })
hl("DiagnosticFloatingWarn", { fg = C.warning })
hl("DiagnosticFloatingInfo", { fg = C.link })
hl("DiagnosticFloatingHint", { fg = C.typ })
hl("DiagnosticFloatingOk", { fg = C.success })
hl("DiagnosticVirtualTextError", { fg = C.error, bg = C.toolErrorBg })
hl("DiagnosticVirtualTextWarn", { fg = C.warning, bg = C.userMessageBg })
hl("DiagnosticVirtualTextInfo", { fg = C.link, bg = C.toolPendingBg })
hl("DiagnosticVirtualTextHint", { fg = C.typ, bg = C.toolSuccessBg })
hl("DiagnosticVirtualTextOk", { fg = C.success, bg = C.toolSuccessBg })

hl("LspReferenceText", { bg = C.selectedBg })
hl("LspReferenceRead", { bg = C.selectedBg })
hl("LspReferenceWrite", { bg = C.selectedBg })
hl("LspSignatureActiveParameter", { fg = C.ember })
hl("LspInlayHint", { fg = C.soot, bg = C.coalLighter })
hl("LspCodeLens", { fg = C.sootDark })
hl("LspCodeLensSeparator", { fg = C.sootDark })
hl("LspInfoBorder", { fg = C.steelLight })

-- Legacy syntax -----------------------------------------------------------

hl("Comment", { fg = C.comment })
hl("SpecialComment", { fg = C.comment })
hl("Constant", { fg = C.num })
hl("String", { fg = C.str })
hl("Character", { fg = C.str })
hl("Number", { fg = C.num })
hl("Boolean", { fg = C.num })
hl("Float", { fg = C.num })
hl("Identifier", { fg = C.ash })
hl("Function", { fg = C.func })
hl("Statement", { fg = C.keyword })
hl("Conditional", { fg = C.keyword })
hl("Repeat", { fg = C.keyword })
hl("Label", { fg = C.ember })
hl("Operator", { fg = C.op })
hl("Keyword", { fg = C.keyword })
hl("Exception", { fg = C.keyword })
hl("PreProc", { fg = C.func })
hl("Include", { fg = C.keyword })
hl("Define", { fg = C.func })
hl("Macro", { fg = C.func })
hl("PreCondit", { fg = C.func })
hl("Type", { fg = C.typ })
hl("StorageClass", { fg = C.keyword })
hl("Structure", { fg = C.typ })
hl("Typedef", { fg = C.typ })
hl("Special", { fg = C.mdCode })
hl("SpecialChar", { fg = C.mdCode })
hl("Tag", { fg = C.ember })
hl("Delimiter", { fg = C.punct })
hl("Debug", { fg = C.warning })
hl("Error", { fg = C.error })
hl("Todo", { fg = C.statusModel })

-- Diff --------------------------------------------------------------------

hl("DiffAdd", { fg = C.success, bg = C.toolSuccessBg })
hl("DiffChange", { fg = C.warning, bg = C.toolPendingBg })
hl("DiffDelete", { fg = C.error, bg = C.toolErrorBg })
hl("DiffText", { fg = C.ash, bg = C.steel })
-- nvim 0.11+ diff groups
hl("diffAdded", { fg = C.success })
hl("diffRemoved", { fg = C.error })
hl("diffChanged", { fg = C.warning })
hl("Added", { fg = C.success })
hl("Changed", { fg = C.warning })
hl("Removed", { fg = C.error })
hl("diffOldFile", { fg = C.soot })
hl("diffNewFile", { fg = C.success })

-- Git signs (gitsigns.nvim and 0.11 gitSigns*) ----------------------------

hl("GitSignsAdd", { fg = C.success })
hl("GitSignsChange", { fg = C.warning })
hl("GitSignsDelete", { fg = C.error })
hl("GitSignsAddLn", { fg = C.success })
hl("GitSignsChangeLn", { fg = C.warning })
hl("GitSignsDeleteLn", { fg = C.error })
hl("GitSignsAddNr", { fg = C.success })
hl("GitSignsChangeNr", { fg = C.warning })
hl("GitSignsDeleteNr", { fg = C.error })
hl("gitSignsAdd", { fg = C.success })
hl("gitSignsChange", { fg = C.warning })
hl("gitSignsDelete", { fg = C.error })

-- Treesitter --------------------------------------------------------------

hl("@comment", { fg = C.comment })
hl("@comment.error", { fg = C.error })
hl("@comment.warning", { fg = C.warning })
hl("@comment.note", { fg = C.link })
hl("@comment.todo", { fg = C.statusModel })
hl("@error", { fg = C.error })
hl("@punctuation.delimiter", { fg = C.punct })
hl("@punctuation.bracket", { fg = C.punct })
hl("@punctuation.special", { fg = C.ember })
hl("@string", { fg = C.str })
hl("@string.documentation", { fg = C.comment })
-- ty (and other LSP servers) emit a `documentation` modifier on docstring
-- tokens; the @lsp.typemod extmark (priority +2 over @lsp.type.string) must
-- be defined or docstrings fall back to the string color. The `.python`
-- suffix in extmark names strips down to this generic group.
hl("@lsp.typemod.string.documentation", { fg = C.comment })
hl("@string.escape", { fg = C.mdCode })
hl("@string.regex", { fg = C.mdCode })
hl("@string.special", { fg = C.statusModel })
hl("@character", { fg = C.str })
hl("@character.special", { fg = C.mdCode })
hl("@number", { fg = C.num })
hl("@boolean", { fg = C.num })
hl("@float", { fg = C.num })
hl("@function", { fg = C.func })
hl("@function.builtin", { fg = C.func })
hl("@function.call", { fg = C.func })
hl("@function.macro", { fg = C.func })
hl("@function.method", { fg = C.func })
hl("@function.method.call", { fg = C.func })
hl("@method", { fg = C.func })
hl("@method.call", { fg = C.func })
hl("@constructor", { fg = C.ember })
hl("@parameter", { fg = C.var })
hl("@variable", { fg = C.ash })
hl("@variable.builtin", { fg = C.emberDim })
hl("@variable.member", { fg = C.var })
hl("@variable.parameter", { fg = C.var })
hl("@property", { fg = C.var })
hl("@field", { fg = C.var })
hl("@type", { fg = C.typ })
hl("@type.builtin", { fg = C.typ })
hl("@type.definition", { fg = C.typ })
hl("@type.qualifier", { fg = C.typ })
hl("@namespace", { fg = C.module })
hl("@module", { fg = C.module })
hl("@keyword", { fg = C.keyword })
hl("@keyword.function", { fg = C.keyword })
hl("@keyword.return", { fg = C.keyword })
hl("@keyword.operator", { fg = C.keyword })
hl("@keyword.conditional", { fg = C.keyword })
hl("@keyword.repeat", { fg = C.keyword })
hl("@keyword.debug", { fg = C.warning })
hl("@keyword.exception", { fg = C.keyword })
hl("@keyword.import", { fg = C.keyword })
hl("@conditional", { fg = C.keyword })
hl("@repeat", { fg = C.keyword })
hl("@label", { fg = C.ember })
hl("@operator", { fg = C.op })
hl("@exception", { fg = C.keyword })
hl("@include", { fg = C.keyword })
hl("@constant", { fg = C.num })
hl("@constant.builtin", { fg = C.num })
hl("@constant.macro", { fg = C.func })
hl("@define", { fg = C.func })
hl("@macro", { fg = C.func })
hl("@preproc", { fg = C.func })
hl("@attribute", { fg = C.ember })
hl("@annotation", { fg = C.ember })
hl("@tag", { fg = C.ember })
hl("@tag.attribute", { fg = C.func })
hl("@tag.delimiter", { fg = C.punct })

-- Markup / markdown -------------------------------------------------------

hl("@text", { fg = C.ash })
hl("@text.strong", { fg = C.ash, bold = true })
hl("@text.emphasis", { fg = C.ash, italic = true })
hl("@text.underline", { fg = C.ash, underline = true })
hl("@text.strike", { fg = C.ash, strikethrough = true })
hl("@text.title", { fg = C.ember, bold = true })
hl("@text.literal", { fg = C.mdCode })
hl("@text.quote", { fg = C.ashGray })
hl("@text.reference", { fg = C.link })
hl("@text.uri", { fg = C.link, underline = true })
hl("@text.math", { fg = C.num })
hl("@text.environment", { fg = C.func })
hl("@text.environment.name", { fg = C.typ })
hl("@text.todo", { fg = C.statusModel })
hl("@text.note", { fg = C.link })
hl("@text.warning", { fg = C.warning })
hl("@text.danger", { fg = C.error })
hl("@text.diff.add", { fg = C.success })
hl("@text.diff.delete", { fg = C.error })
hl("@markup.heading", { fg = C.ember, bold = true })
hl("@markup.italic", { fg = C.ash, italic = true })
hl("@markup.strong", { fg = C.ash, bold = true })
hl("@markup.strikethrough", { fg = C.ash, strikethrough = true })
hl("@markup.underline", { fg = C.ash, underline = true })
hl("@markup.link", { fg = C.link })
hl("@markup.link.url", { fg = C.soot, underline = true })
hl("@markup.raw", { fg = C.mdCode })
hl("@markup.raw.block", { fg = C.mdCodeBlock })
hl("@markup.quote", { fg = C.ashGray })
hl("@markup.list", { fg = C.ember })
hl("@markup.rule", { fg = C.steel })
hl("@markup.math", { fg = C.num })
hl("@markup.environment", { fg = C.func })

-- Terminal ----------------------------------------------------------------

vim.g.terminal_color_0 = C.coal
vim.g.terminal_color_1 = C.error
vim.g.terminal_color_2 = C.success
vim.g.terminal_color_3 = C.warning
vim.g.terminal_color_4 = C.link
vim.g.terminal_color_5 = C.statusModel
vim.g.terminal_color_6 = C.typ
vim.g.terminal_color_7 = C.ash
vim.g.terminal_color_8 = C.sootDark
vim.g.terminal_color_9 = C.ember
vim.g.terminal_color_10 = C.num
vim.g.terminal_color_11 = C.mdCode
vim.g.terminal_color_12 = C.keyword
vim.g.terminal_color_13 = C.emberDim
vim.g.terminal_color_14 = C.ashGray
vim.g.terminal_color_15 = C.mdCodeBlock

vim.g.colors_name = "anthracite"
