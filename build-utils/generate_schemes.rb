require "json"
require_relative "make_pngs.rb"

def generate_schemes_of_element(element, mappings)
  element_names = mappings["names"]
  template_name = "#{element_names.first}.svg"
  template = File.read("#{SCRIPT_DIR}/../assets/image/#{template_name}")
  1.upto(element_names.length-1) do |i| #start at 1 because first element is the template/already has the changes
    new_svg = generate_scheme(i, mappings, template)
    File.write("#{IMAGES_PATH}/#{element_names[i]}.svg", new_svg)
  end
end

def generate_scheme(i, mappings, svg)
  element_names = mappings["names"]
  name = element_names[i]
  mappings.drop(1).each do |_,palette| #drop names, because they aren't colors to replace
    #puts "#{_}: #{palette.first} -> #{palette[i]}"
    svg = svg.gsub(palette.first, palette[i])
  end
  svg.gsub(element_names.first, name)
end

color_mappings_json = File.read("#{SCRIPT_DIR}/color_mappings.json")
color_mappings = JSON.parse(color_mappings_json)

element = ARGV.first.downcase
if (element == "all") then
  color_mappings.each do |el,mappings|
    generate_schemes_of_element(el, mappings)
  end
else
  generate_schemes_of_element(element, color_mappings[element])
end

#Build all pngs now that the new svgs have been generated
make_pngs