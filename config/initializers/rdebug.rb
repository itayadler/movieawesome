debug_indicator = Rails.root + 'tmp/debug.txt'

if debug_indicator.exist?
  debug_indicator.delete
  require 'debugger'
  Debugger.wait_connection = true
  Debugger.start_remote
end
