require 'erb'
require 'fileutils'

PAGES = { 
	:index => 'company',
	:service => 'service',
	:prices => 'prices',
	:contact => 'contact'
}

LAYOUT = 'layout'

class PageGenerator
	PAGE_DIR = File.dirname(__FILE__)
	@@partials = {}
	@@layout = nil

	def initialize(page, name, locals={})
		@page = page.to_sym
		@name = name
		@part = @page
		locals.each do |name, value|
			instance_variable_set("@#{name}", value)
		end
		@part_name ||= PAGES[@part]
	end
	
	def rhtml
		@rhtml ||= File.read(File.join(PAGE_DIR, @page.to_s+'.erb'))
	end
	
	def page_content
		@page_content ||= self.generate
	end
	
	def content_class
		@page == :index ? 'MainPage' : 'Subpage'
	end
	
	def generate
		ERB.new(self.rhtml, 0, "", "@page_content").result(binding)
	end
	
	def html
		return @html if @html
		@@layout ||= File.read(File.join(PAGE_DIR, LAYOUT+'.erb'))
		ERB.new(@@layout, 0, "", "@html").result(binding)
	end
	
	def compile!
		File.open(File.join(PAGE_DIR, @page.to_s+'.html'), "wb") do |file|
			file.write self.html
		end
	end
	
	# helper methods
	def render_partial(partial, locals={})
		locals[:part] ||= @page
		@@partials[partial] ||= PageGenerator.new("_"+partial.to_s, partial.to_s, locals).page_content
	end
	
	def render_brief(part, locals={})
		locals[:part] = part
		part_name = PAGES[part]
		render_partial (part_name+"_brief").to_sym, locals.merge(:part => part)
	end
	
	def brief_tag(html_tag)
		if @link
			%Q(<a href="#{@page}.html">@{html_tag}</a>)
		else
			html_tag
		end
	end
	
	def page_img(img_name=nil)
		img_name ||= @part_name
		brief_tag(%Q(<img src="img/#{img_name}.jpg" height="#{@img_height}">))
	end
end

PAGES.each do |page, name|
	puts name
	page_gen = PageGenerator.new(page, name)
	page_gen.compile!
end