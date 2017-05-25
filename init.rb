folders = 'config,lib,models,services,controllers,policies'
Dir.glob("./{#{folders}}/init.rb").each do |file|
  require file
end
