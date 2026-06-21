resource "orbstack_config" "main" {
  cpu              = 7
  memory_mib       = 51200 # 50GB
  start_at_login   = false
  pause_on_sleep   = false
  setup_user_admin = true
  rosetta_enabled  = true
}
