vim.filetype.add {
  pattern = {
    [".*%.sh%.tmpl"] = "sh",
    -- Generic patterns like .env.example
    ['%.env%.%w+'] = 'sh',
  },
}

