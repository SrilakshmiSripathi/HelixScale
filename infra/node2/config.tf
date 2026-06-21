resource "orbstack_config" "main" {
  cpu              = 16
  memory_mib       = 26624 # 26GB
  start_at_login   = false
  pause_on_sleep   = false
  setup_user_admin = true
  rosetta_enabled  = true
}
