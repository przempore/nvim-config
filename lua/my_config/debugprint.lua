require('debugprint').setup({
  filetypes = {
    cpp = {
      left = 'QLOG_WARN() << "',
      right = '";',
      mid_var = '" << ',
      right_var = ";",
      location = '" << __FILE__ << ":" << __LINE__ << "',
    },
  },
})
