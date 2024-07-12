module Cleaning
  def clean_storage
    Dir.glob(Rails.root.join('storage', '**', '*').to_s).sort_by(&:length).reverse.each do |x|
      if File.directory?(x) && Dir.empty?(x)
        Dir.rmdir(x)
      end
    end
  end
end