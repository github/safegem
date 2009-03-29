RACK_ENV = 'development'

class Exception
  def to_hash(extra = nil)
    h = { 'message' => message }
    h = h.merge('backtrace' => backtrace) if %w{development staging test}.include?(RACK_ENV)
    h = h.merge(extra) if extra
    h
  end
end