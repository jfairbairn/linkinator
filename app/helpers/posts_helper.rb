require 'hpricot'
module PostsHelper
  def posts_by_url(username)
    url_for(:controller => 'posts', :action => 'by', :id => "~#{username}")
  end
  
  def format(content)
    c = simple_format(auto_link(content))
    h = Hpricot(c)
    (h/'a').each do |link|
      next unless link['href']
      if link['href'] =~ /^http:\/\/([a-zA-Z]+\.)?youtube\.com\/watch\?v=([a-zA-Z0-9]+)/
        link.parent.insert_after link.make(youtube_embed($2)), link
      end
      if link['href'] =~ /^http:\/\/(www\.)?vimeo\.com\/([0-9]+)/
        link.parent.insert_after link.make(vimeo_embed($2)), link
      end
    end
    h.to_s
    
  end
  
  private
  def youtube_embed(movie)
    return <<-EOF
<object width='480' height='385' class="embed">
  <param name="movie" value="http://www.youtube.com/v/#{movie}&hl=en&fs=1&rel=0&color1=0xcc2550&color2=0xe87a9f"/>
  <param name="allowFullScreen" value="true"/>
  <param name ="allowscriptaccess" value="always"/>
  <embed src="http://www.youtube.com/v/#{movie}&hl=en&fs=1&rel=0&color1=0xcc2550&color2=0xe87a9f" type="application/x-shockwave-flash" allowscriptaccess="always"/>
</object>
    EOF
  end
  
  def vimeo_embed(movie)
    return <<-EOF
<object width="480" height="385" class="embed">
  <param name="allowfullscreen" value="true" />
  <param name="allowscriptaccess" value="always" />
  <param name="movie" value="http://vimeo.com/moogaloop.swf?clip_id=#{movie}&amp;server=vimeo.com&amp;show_title=1&amp;show_byline=1&amp;show_portrait=0&amp;color=&amp;fullscreen=1" />
  <embed src="http://vimeo.com/moogaloop.swf?clip_id=#{movie}&amp;server=vimeo.com&amp;show_title=1&amp;show_byline=1&amp;show_portrait=0&amp;color=&amp;fullscreen=1" type="application/x-shockwave-flash" allowfullscreen="true" allowscriptaccess="always" width="480" height="385"></embed>
</object>
    EOF
  end
  
end
