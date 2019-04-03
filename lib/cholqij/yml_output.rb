require 'yaml'

class Cholqij
	class YmlOutput
		class << self
			def output(long_count_list_path)
				arr = []
				File.open(long_count_list_path, 'r') do |f|
					f.each_line{|l| arr << l.chomp! }
				end
				base_hash_list = arr.map{|e|
				 	Cholqij.lc_to_full(e).split(/\s+/).map{|elm|
					 	elm.gsub(/[\(\)]/, '') }
			 	}.map{|e| 
					{ 'long_count' => e[0],
						'tzolkin'    => e[1],
						'haab'       => e[2],
						'modern'     => e[3]
					}
				}
				File.open("./yml_output/output_#{Time.now.to_i}.yml", 'w'){|f| f.puts(base_hash_list.to_yaml) }
			end
		end
	end
end
