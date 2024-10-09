module DefaultAssign
  module Hooks
    class DefaultAssignProjectsHooks < Redmine::Hook::ViewListener
      # context:
      # * :form - the form builder
      # * :project - the current project
      def view_projects_form(context = {})
        unless context[:project].default_assignee.blank?
          selected = context[:project].default_assignee.id
        end

        options =
          options_from_collection_for_select(
            context[:project].assignable_users, :id, :name,
            (selected.blank? ? nil : selected.to_i))
        can_assign_users = context[:project].assignable_users.any?
        select_tag =
          context[:form].select(:default_assignee_id, options,
                                { :include_blank => l(:none_selected) },
                                :disabled => !can_assign_users)
        content_tag(:p, select_tag)
      end
    end
  end
end
