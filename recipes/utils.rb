
def recipes_root
  File.join(File.dirname(__FILE__), '..')
end

def template_dir
  File.join(recipes_root, 'templates')
end

def template(template_name)
  return File.open(File.join(template_dir, template_name)).read
end
