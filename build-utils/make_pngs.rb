require "json"

SCRIPT_DIR = File.expand_path(File.dirname(__FILE__))
IMAGES_PATH = "#{SCRIPT_DIR}/../assets/image/"

DPI_VALUES_JSON = File.read("#{SCRIPT_DIR}/dpi_values.json")
DPI_VALUES = JSON.parse(DPI_VALUES_JSON)

def make_pngs
  Dir.foreach(IMAGES_PATH) do |imgName|
    if /.*\.svg/.match imgName then
      dpiPair = DPI_VALUES.select {|k,v| imgName.include?(k)}.first
      dpi = dpiPair.last if dpiPair
      if dpi then
        puts "Exporting #{imgName} to PNG at #{dpi} DPI"
        system "\"C:\\Program Files\\Inkscape\\inkscape.exe\" #{IMAGES_PATH}/#{imgName} --export-png=#{IMAGES_PATH}/#{imgName[0...-4]}.png --export-dpi=#{dpi}"
      end
    end
  end
end