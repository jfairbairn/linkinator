require 'hpricot'
module PostsHelper
  def posts_by_url(username)
    url_for(:controller => 'posts', :action => 'by', :id => "~#{username}")
  end
  
  def format(content)
    c = simple_format(auto_link(content))
    h = Hpricot(c)
    (h/'a').each do |link|
      next unless link['href'] and link['href'] =~ /^http:\/\/([a-zA-Z]+\.)?youtube\.com\/watch\?v=([a-zA-Z0-9]+)/
      link.parent.insert_after link.make(youtube_embed($2)), link
    end
    h.to_s
    
  end
  
  private
  def youtube_embed(movie)
    return <<-EOF
<object width='480' height='385' class="youtube">
  <param name="movie" value="http://www.youtube.com/v/#{movie}&hl=en&fs=1&rel=0&color1=0xcc2550&color2=0xe87a9f"/>
  <param name="allowFullScreen" value="true"/>
  <param name ="allowscriptaccess" value="always"/>
  <embed src="http://www.youtube.com/v/#{movie}&hl=en&fs=1&rel=0&color1=0xcc2550&color2=0xe87a9f" type="application/x-shockwave-flash" allowscriptaccess="always"/>
</object>
    EOF
  end
  
end
