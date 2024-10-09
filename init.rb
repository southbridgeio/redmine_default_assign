require 'redmine'

# Including dispatcher.rb in case of Rails 2.x
require 'dispatcher' unless Rails::VERSION::MAJOR >= 3

require './plugins/redmine_default_assign/lib/default_assign_issue_patch'
require './plugins/redmine_default_assign/lib/default_assign_project_patch'
require './plugins/redmine_default_assign/lib/default_assign/hooks/default_assign_projects_hooks'
require './plugins/redmine_default_assign/lib/default_assign/hooks/default_assign_issues_hooks'

if Rails::VERSION::MAJOR >= 3
  register_after_redmine_initialize_proc =
    if Redmine::VERSION::MAJOR >= 5
      Rails.application.config.public_method(:after_initialize)
    else
      reloader = defined?(ActiveSupport::Reloader) ? ActiveSupport::Reloader : ActionDispatch::Reloader
      reloader.public_method(:to_prepare)
    end
  register_after_redmine_initialize_proc.call do
    require_dependency 'project'
    require_dependency 'issue'
    Project.send(:include, DefaultAssignProjectPatch)
    Issue.send(:include, DefaultAssignIssuePatch)
  end
else
  Dispatcher.to_prepare do
    require_dependency 'project'
    require_dependency 'issue'
    Project.send(:include, DefaultAssignProjectPatch)
    Issue.send(:include, DefaultAssignIssuePatch)
  end
end

Redmine::Plugin.register :redmine_default_assign do
  name 'Default Assign plugin'
  author 'Robert Chady / Paul Dann'
  author_url 'https://github.com/giddie/redmine_default_assign'
  description 'Plugin implementing Douglas Campos\' ticket-482 code as a plugin.  It has since been extended to offer other features as well.'
  version '0.6'

  settings :default => {'default_assignee_id' => nil,
                        'interactive_assignment' => true,
                        'self_assignment' => false},
           :partial => 'settings/default_assign'
end
