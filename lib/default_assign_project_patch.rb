module DefaultAssignProjectPatch
  def self.included(base)
    #base.extend(ClassMethods)
    base.send(:include, InstanceMethods)

    base.class_eval do
      unloadable

      safe_attributes :default_assignee_id
      belongs_to :default_assignee, :class_name => "Principal"
      before_create :set_default_assignee
    end
  end

  #module ClassMethods
  #end

  module InstanceMethods
    def set_default_assignee
      self.default_assignee_id ||=
        Setting.plugin_redmine_default_assign['default_assignee_id']
    end
  end
end
