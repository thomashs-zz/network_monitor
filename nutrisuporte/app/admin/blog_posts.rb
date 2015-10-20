ActiveAdmin.register BlogPost do
    
  menu priority: 4, label: "Posts do Blog"

  filter :title
  filter :created_at

  index do 
    column :title
    column :image do |blog_post|
      image_tag(blog_post.image.url(:thumb),width: 100, height: 100)
    end
    column :is_draft do |blog_post|
      blog_post.is_draft ? status_tag('Rascunho') : status_tag('Publicado',:ok)
    end
    default_actions
  end

	form :html => { :enctype => "multipart/form-data" } do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs do
    	f.input :title, as: :string
    	f.input :content, as: :wysihtml5, blocks: [:h1,:h2,:h3,:p]
    	f.input :is_draft, as: :boolean, :label => "Salvar como rascunho"
    	f.input :image, :as => :file, :hint => (f.template.image_tag(f.object.image.url(:thumb)) if f.object.image?) 
      f.input :image_cache, :as => :hidden, :wrapper_html => { :style => "display:none;" }
    end
		f.actions
	end

	show do |post|
		attributes_table do
    	row :title
    	row :url
    	row :content do |p|
        p.content.html_safe
      end
    	row :image do
        image_tag(post.image.url(:thumb))
      end
    end
	end

end
