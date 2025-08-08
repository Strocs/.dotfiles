-- Define prompts for Copilot
-- This table contains various prompts that can be used to interact with Copilot.
local prompts = {
  Explain = "Please explain how the following code works.", -- Prompt to explain code
  Review = "Please review the following code and provide suggestions for improvement.", -- Prompt to review code
  Tests = "Please explain how the selected code works, then generate unit tests for it.", -- Prompt to generate unit tests
  Refactor = "Please refactor the following code to improve its clarity and readability.", -- Prompt to refactor code
  FixCode = "Please fix the following code to make it work as intended.", -- Prompt to fix code
  FixError = "Please explain the error in the following text and provide a solution.", -- Prompt to fix errors
  BetterNamings = "Please provide better names for the following variables and functions.", -- Prompt to suggest better names
  Documentation = "Please provide documentation for the following code.", -- Prompt to generate documentation
  JsDocs = "Please provide JsDocs for the following code.", -- Prompt to generate JsDocs
  DocumentationForGithub = "Please provide documentation for the following code ready for GitHub using markdown.", -- Prompt to generate GitHub documentation
  CreateAPost = "Please provide documentation for the following code to post it in social media, like Linkedin, it has be deep, well explained and easy to understand. Also do it in a fun and engaging way.", -- Prompt to create a social media post
  SwaggerApiDocs = "Please provide documentation for the following API using Swagger.", -- Prompt to generate Swagger API docs
  SwaggerJsDocs = "Please write JSDoc for the following API using Swagger.", -- Prompt to generate Swagger JsDocs
  Summarize = "Please summarize the following text.", -- Prompt to summarize text
  Spelling = "Please correct any grammar and spelling errors in the following text.", -- Prompt to correct spelling and grammar
  Wording = "Please improve the grammar and wording of the following text.", -- Prompt to improve wording
  Concise = "Please rewrite the following text to make it more concise.", -- Prompt to make text concise
}

return {
  "CopilotC-Nvim/CopilotChat.nvim",
  opts = {
    prompts = prompts, -- Use the defined prompts for Copilot
    system_prompt = [[
      You are a expert Software Engineer, you are here to help me with my code, you can also help me with my text, like writing documentation, fixing errors, improving wording, etc. 
      You are very smart and you know how to do everything related to software development. 
      You use a sophisticated technique to understand the code and text I provide you, and you can also use tools to help me with my requests.
      Your answer will consider technical details, best practices, and the latest trends in software development.
    ]],
    model = "claude-3.7-sonnet",
    auto_tool_mode = true, -- Enable auto tool mode for trusted tasks
    mappings = {
      complete = {
        insert = "<Tab>",
      },
      close = {
        normal = "q",
        insert = "<C-c>",
      },
      reset = {
        normal = "<C-l>",
        insert = "<C-l>",
      },
      submit_prompt = {
        normal = "<CR>",
        insert = "<C-s>",
      },
      toggle_sticky = {
        normal = "grr",
      },
      clear_stickies = {
        normal = "grx",
      },
      accept_diff = {
        normal = "<C-y>",
        insert = "<C-y>",
      },
      jump_to_diff = {
        normal = "gj",
      },
      quickfix_answers = {
        normal = "gqa",
      },
      quickfix_diffs = {
        normal = "gqd",
      },
      yank_diff = {
        normal = "gy",
        register = '"', -- Default register to use for yanking
      },
      show_diff = {
        normal = "gd",
        full_diff = false, -- Show full diff instead of unified diff when showing diff window
      },
      show_info = {
        normal = "gi",
      },
      show_context = {
        normal = "gc",
      },
      show_help = {
        normal = "gh",
      },
    },
  },
}
