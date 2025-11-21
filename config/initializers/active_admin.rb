# ActiveAdmin configuration
ActiveAdmin.setup do |config|
  # Site title
  config.site_title = "Falls Paper Admin"
  config.site_title_link = "/"

  # Default namespace
  config.default_namespace = :admin

  # Authentication
  config.authentication_method = :authenticate_admin_user!
  config.current_user_method = :current_user
  config.logout_link_path = :destroy_user_session_path
  config.logout_link_method = :delete

  # Root route
  config.root_to = 'products#index'

  # Comments
  config.comments = true
  config.comments_registration_name = 'AdminComment'

  # Batch actions
  config.batch_actions = true

  # Filters
  config.include_default_association_filters = true

  # Localize format
  config.localize_format = :long

  # Footer
  config.footer = "Falls Paper Admin - #{Date.current.year}"

  # CSV options
  config.csv_options = { col_sep: ',', force_quotes: true }

  # Download links
  config.download_links = [:csv, :xml, :json]

  # Pagination
  config.default_per_page = 30

  # Order clause
  config.order_clause = ActiveAdmin::OrderClause
end
