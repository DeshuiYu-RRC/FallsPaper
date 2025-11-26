ActiveAdmin.register Page do
  permit_params :title, :slug, :content

  index do
    selectable_column
    id_column
    column :title
    column :slug
    column :updated_at
    actions
  end

  filter :title
  filter :slug

  form do |f|
    f.inputs "Page Details" do
      f.input :title
      f.input :slug, hint: "URL-friendly identifier (e.g., about, contact)"
      f.input :content, as: :text, input_html: { rows: 20 }, hint: "You can use HTML tags"
    end
    f.actions
  end

  show do
    attributes_table do
      row :id
      row :title
      row :slug
      row :content do |page|
        raw page.content
      end
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end
end
