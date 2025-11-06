-- configuring the cut & delete behaviour of the imported community plugin
return {
  "gbprod/cutlass.nvim",
  opts = {
    cut_key = "x",
    override_del = true, -- this should be the default
    registers = { -- instead put those removed texts into mainly unused registers
      select = "s",
      delete = "d",
      change = "c",
    },
  },
}
