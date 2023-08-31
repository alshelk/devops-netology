
config {
  format = "compact"
  plugin_dir = "~/.tflint.d/plugins"
  module = true
}
plugin "terraform" {
  enabled = true
  preset = "recommended"
}