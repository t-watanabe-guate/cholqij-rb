require 'yaml'

class Cholqij
  class YmlOutput
    class << self
      def output(long_count_list_path)
        arr = []
        File.open(long_count_list_path, 'r') do |f|
          f.each_line{|l| arr << l.chomp! }
        end
        base_hash_list_gmt_584283 = build_from_array(arr, Cholqij::BASE_GMT584283)
        base_hash_list_gmt_584285 = build_from_array(arr, Cholqij::BASE_GMT584285)
        File.open("./yml_output/output_584283_#{Time.now.to_i}.yml", 'w'){|f| f.puts(base_hash_list_gmt_584283.to_yaml) }
        File.open("./yml_output/output_584285_#{Time.now.to_i}.yml", 'w'){|f| f.puts(base_hash_list_gmt_584285.to_yaml) }
      end

      def build_from_array(arr, gmt_mode)
        arr.map{|e|
           Cholqij.lc_to_full(e, gmt_mode).split(/\s+/)
        }.map{|e|
          { 'long_count' => e[0],
            'tzolkin'    => e[1],
            'haab'       => e[2],
            'gregorian'  => e[3],
            'julian'     => e[4]
          }
        }

      end
    end
  end
end
