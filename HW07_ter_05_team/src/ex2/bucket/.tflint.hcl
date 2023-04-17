config {
  format = "compact"
  plugin_dir = "~/.tflint.d/plugins"
  module = true
}

plugin "terraform" {
  enabled = true
  preset = "recommended"
}

rule "terraform_module_pinned_source" {
  enabled = false
  style = "flexible"
  default_branches = ["main"]
}