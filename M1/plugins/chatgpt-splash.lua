local M = {}

-- Function to interact with Splash
function M.send_to_chatgpt(input_text)
    local splash_script = [[
        function main(splash, args)
            assert(splash:go(args.url))
            assert(splash:wait(0.5))
            local input_box = splash:select('input.chat-input') -- Selector for the input box
            input_box:send_text(args.input)
            local submit_button = splash:select('button.send-button') -- Selector for the send button
            submit_button:mouse_click()
            assert(splash:wait(3))
            return {html = splash:html()}
        end
    ]]

    local splash_url = "http://localhost:8050/execute"
    local chatgpt_url = "https://chat.openai.com/chat" -- This URL will need to be the actual URL of the ChatGPT interface you're automating
    local body = string.format(
        '{"url": "%s", "lua_source": %s, "input": "%s"}',
        chatgpt_url, vim.fn.json_encode(splash_script), input_text
    )

    local headers = {
        ["Content-Type"] = "application/json",
    }

    local function on_exit(code, signal)
        if code ~= 0 then
            print("Request failed with code", code)
        end
    end

    local function on_stdout(err, data)
        if err then
            print("Error:", err)
            return
        end
        if data then
            -- TODO: Parse the data (which is the HTML returned by Splash)
            print(vim.inspect(data))
        end
    end

    local function on_stderr(err, data)
        if err then
            print("Error:", err)
            return
        end
        if data then
            print("stderr:", vim.inspect(data))
        end
    end

    local stdout = vim.loop.new_pipe(false)
    local stderr = vim.loop.new_pipe(false)

    local handle
    local function on_process_exit()
        stdout:read_stop()
        stderr:read_stop()
        stdout:close()
        stderr:close()
        handle:close()
    end

    local args = {"curl", "-X", "POST", "-H", "Content-Type: application/json", "-d", body, splash_url}

    handle, pid = vim.loop.spawn("curl", {
        args = args,
        stdio = {nil, stdout, stderr},
    }, vim.schedule_wrap(on_exit))

    stdout:read_start(vim.schedule_wrap(on_stdout))
    stderr:read_start(vim.schedule_wrap(on_stderr))
end

-- Function to get the current line and send it to ChatGPT
function M.process_current_line()
    local current_line = vim.api.nvim_get_current_line()
    M.send_to_chatgpt(current_line)
end

-- Command registration for Neovim
function M.setup()
    vim.api.nvim_create_user_command('ChatGPT', M.process_current_line, {})
end

return M

