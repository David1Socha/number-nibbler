# Requires Inkscape to be in PATH

require "json"

scriptDir = File.expand_path(File.dirname(__FILE__))
imagesPath = "#{scriptDir}/../assets/image/"

dpiValuesJson = File.read("#{scriptDir}/dpi_values.json")
dpiValues = JSON.parse(dpiValuesJson)

Dir.foreach(imagesPath) do |imgName|
  if /.*\.svg/.match imgName then
    dpiPair = dpiValues.select {|k,v| imgName.include?(k)}.first
    dpi = dpiPair.last if dpiPair
    if dpi then
      puts "Exporting #{imgName} to PNG at #{dpi} DPI"
      system "inkscape #{imagesPath}/#{imgName} --export-png=#{imagesPath}/#{imgName[0...-4]}.png --export-dpi=#{dpi}"
    end
  end
end