thr = Thread.new {
  require_relative 'web1'
}
thr.join
