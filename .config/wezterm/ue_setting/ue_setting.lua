
local wezterm = require("wezterm")

-- 各プロジェクトの情報を取得.
local projects = require("ue_setting.projects")

-- プロジェクトを選択した時のパネル設定.
local function open_ue_project(window, pane, project)
	local root = project.root
	-- AI Pane.
	local tab, ai_pane, window = window:mux_window():spawn_tab{
		cwd = root,
		args = {
			"powershell.exe",
			"-NoExit",
			"-Command",
			"Set-Location '" .. root .. "';",
			"$env:ANTHROPIC_BASE_URL='" .. project.ai_base_url .. "';",
			"$env:ANTHROPIC_AUTH_TOKEN='" .. project.auth_token .. "';",
			"$env:CLAUDE_CODE_ATTRIBUTION_HEADER='0';",
			"claude --model " .. project.model_name .. ";",
		}
	}

	-- AI Log Pane.
	local ai_log_pane = ai_pane:split{
		direction = "Right",
		size = 0.5,
		cwd = root,
		args = {
			"powershell.exe",
			"-NoExit",
			"-Command",
			"Set-Location '" .. root .. "';",
			"lms log stream --source server;",
		}
	}

	-- Command Pane.
	local command_pane = ai_pane:split{
		direction = "Bottom",
		size = 0.3,
		cwd = root,
		args = {
			"powershell.exe",
			"-NoExit",
			"-Command",
			"Set-Location '" .. root .. "';",
		}
	}

	-- Git Pane.
	local git_pane = ai_log_pane:split{
		direction = "Bottom",
		size = 0.3,
		cwd = root,
		args = {
			"powershell.exe",
			"-NoExit",
			"-Command",
			"Set-Location '" .. root .. "';",
			"git status;",
		}
	}

	tab:set_title("UE - " .. project.name)
end

-- プロジェクト選択アクション.
local input_select_action = wezterm.action_callback(function(window, pane, id, label)
	if not id then return end
	for _, project in ipairs(projects) do
		if project.name == id then
			open_ue_project(window, pane, project)
			return
		end
	end
end)

-- コマンドパレット選択アクション.
local open_command_palette_action = wezterm.action_callback(function(window, pane)
	local choices = {}
	for _, project in ipairs(projects) do
		table.insert(choices, { label=project.name, id=project.name,})
	end
	
	window:perform_action(
		wezterm.action.InputSelector {
			title = "Select UE Project",
			choices = choices,
			fuzzy = true,
			action = input_select_action,
		},
		pane
	)
end)

-- コマンドパレット追加処理.
wezterm.on("augment-command-palette", function(window, pane)
	return {
		{
			brief = "Open UE Project !!",
			doc = "Select an Unreal Engine Project",
			action = open_command_palette_action,
		},
	}
end)
