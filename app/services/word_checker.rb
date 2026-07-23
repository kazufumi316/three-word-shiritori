class WordChecker
  def self.real_word?(word)
    nodes = []
    Natto::MeCab.new.parse(word) do |node|
      nodes << node if node.stat.zero?
    end
    nodes.size == 1
  end
end
