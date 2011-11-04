module TemplateManager
  extend self

  def outer_templates
    templates.keys
  end
  def inner_templates(outer)
    templates[outer].keys
  end
  def inner_template(outer, name)
    templates[outer][name]
  end
private
  def templates
    Dir.chdir(TEMPLATE_PATH) do
      @templates ||= Dir.entries(".").inject({}) do |templates, entry|
        yml_path = File.join(entry, "template.yml")
        if entry != '.' && 
           entry != '..' && 
           File.exists?(yml_path)
          templates[entry] = YAML.load_file(yml_path)
        end
        templates
      end
    end
  end
end