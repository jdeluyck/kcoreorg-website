module Jekyll
  module StripRougeTables
    def strip_rouge_tables(input)
      # Remove the entire rouge table wrapper, keeping only the code content
      input.gsub(
        /<div class="highlight">.*?<td class="rouge-code"><pre>(.*?)<\/pre>.*?<\/div>/m,
        '<div class="highlight"><pre class="highlight"><code>\1</code></pre></div>'
      )
    end
  end
end

Liquid::Template.register_filter(Jekyll::StripRougeTables)
